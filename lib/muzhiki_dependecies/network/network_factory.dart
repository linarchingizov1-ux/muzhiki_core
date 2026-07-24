import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:muzhiki_core/muzhiki_dependecies/model/network_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/interceptors/metrics_interceptor.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/request_storage.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/network_type_service.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/token_storage.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/url_launch/url_launch.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_version/model/app_info_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/user_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:uuid/uuid.dart';

bool showIsBackendProblem = false;

class NetworkFactory {
  static Future<NetworkModel> create({
    required bool enableTalker,
    required bool showReqHeaders,
    required Talker talker,
    required HiveCacheStore store,
    required SharedPreferences sharedPreferences,
    required SecureTokenStorage tokenStorage,
    required PersistCookieJar cookieJar,
    required bool needMetricsHttp,
    required bool showTalkerMetricsHttp,
    required UserSession userSession,
    required TypeApp typeApp,
    required AppInfoModel infoProject,
  }) async {
    await cookieJar.forceInit();
    final baseOptions = BaseOptions(
      connectTimeout: const Duration(minutes: 5),
      receiveTimeout: const Duration(minutes: 5),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    final sessionId = Uuid().v4().replaceAll('-', '').substring(0, 8);
    sharedPreferences.setString('metrics_session_id', sessionId);
    final refreshDio = Dio(baseOptions);
    final authDio = Dio(baseOptions);
    final metricsDio = Dio(baseOptions);

    final fresh = Fresh<AuthTokens>(
      tokenStorage: tokenStorage,
      httpClient: refreshDio,
      tokenHeader: (token) {
        talker.warning('Токен в заголовок: ${token.accessToken}');

        return {'Authorization': 'Bearer ${token.accessToken}'};
      },
      shouldRefresh: (response) {
        final code = response?.statusCode;

        final isAuthError = code == 401 || code == 419;

        if (isAuthError && showIsBackendProblem) {
          talker.warning('[Fresh] Refresh остановлен: backend problem');
          BannerController.I.show(
            message: "Сервисы временно недоступны\nПопробуйте позже",
          );
          return false;
        }

        return isAuthError;
      },
      refreshToken: (token, client) async {
        const maxAttempts = 5;
        const delay = Duration(seconds: 5);

        for (var attempt = 1; attempt <= maxAttempts; attempt++) {
          talker.debug("Попытка ревреша $attempt");
          try {
            final response = await client.get(
              'https://auth.muzhiki.pro/api/v1/auth/refreshs',
              options: Options(extra: {"isRefresh": true}),
            );

            final access = response.data['data']['access_token'] as String;

            return AuthTokens(
              accessToken: access,
              refreshToken: token?.refreshToken ?? "",
            );
          } catch (e, st) {
            final error = AppErrorMapper.I.map(e, st);

            if (error.message == "Resresh-токен не найден в базе." ||
                error.message == "Токен уже использован ранее." ||
                error.message == "Refresh token был отозван") {
              throw RevokeTokenException();
            }

            if (attempt < maxAttempts) {
              talker.warning(
                '[Refresh] ошибка ревреша ${error.message}. Повторная попытка через ${delay.inSeconds}s',
              );

              await Future.delayed(delay);

              continue;
            } else {
              showIsBackendProblem = true;
              break;
            }
          }
        }
        talker.debug("Вышли из цикла и делаем Exception");
        return AuthTokens(
          accessToken: token?.accessToken ?? "",
          refreshToken: token?.refreshToken ?? "",
        );
      },
    );
    final cookieManager = CookieManager(cookieJar);
    final metricsStorage = RequestStorage(
      showTalkerMetricsHttp: showTalkerMetricsHttp,
      sharedPreferences: sharedPreferences,
      authDio: metricsDio,
    );
    await metricsStorage.init();
    final connectivityService = NetworkConnectivityService(Connectivity());
    await connectivityService.init();
    final metricsInterceptor = MetricsInterceptor(
      showTalkerMetricsHttp: showTalkerMetricsHttp,
      userSession: userSession,
      typeApp: typeApp,
      infoProject: infoProject,
      metricsStorage: metricsStorage,
      connectivityService: connectivityService,
    );
    final talkerInterceptor = !kReleaseMode
        ? TalkerDioLogger(
            talker: talker,
            settings: TalkerDioLoggerSettings(
              enabled: enableTalker,
              printErrorData: false,
              printErrorHeaders: false,
              printErrorMessage: true,
              printRequestData: false,
              printRequestExtra: false,
              printRequestHeaders: showReqHeaders,
              printResponseData: true,
              printResponseHeaders: false,
              printResponseMessage: false,
              printResponseRedirects: false,
              printResponseTime: false,
            ),
          )
        : null;
    refreshDio.interceptors.addAll([cookieManager, ?talkerInterceptor]);
    metricsDio.interceptors.addAll([
      if (showTalkerMetricsHttp) ?talkerInterceptor,
    ]);
    authDio.interceptors.addAll([
      fresh,
      ?talkerInterceptor,
      if (needMetricsHttp) metricsInterceptor,
    ]);

    return NetworkModel(
      requestStorage: metricsStorage,
      uriLauncer: MuzhikiUrlLaunch.I,
      authDio: authDio,
      refreshDio: refreshDio,
      fresh: fresh,
    );
  }
}
