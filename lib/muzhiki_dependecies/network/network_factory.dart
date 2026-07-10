import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:muzhiki_core/muzhiki_dependecies/model/network_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/interceptors/error_interceptor.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/interceptors/metrics_interceptor.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/request_storage.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/network_type_service.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/url_launch/url_launch.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/token_storage.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_version/model/app_info_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/user_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

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
    required UserSession userSession,
    required TypeApp typeApp,
    required AppInfoModel infoProject,
  }) async {
    await cookieJar.forceInit();

    final cacheOptions = CacheOptions(
      store: store,
      policy: CachePolicy.refreshForceCache,
      hitCacheOnErrorCodes: [500],
      hitCacheOnNetworkFailure: true,
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      cipher: null,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );
    final baseOptions = BaseOptions(
      connectTimeout: const Duration(minutes: 5),
      receiveTimeout: const Duration(minutes: 5),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    final refreshDio = Dio(baseOptions);
    final authDio = Dio(baseOptions);
    final errorInterceptor = AppErrorInterceptor();
    final cacheInterceptor = DioCacheInterceptor(options: cacheOptions);

    final fresh = Fresh<AuthTokens>(
      tokenStorage: tokenStorage,
      httpClient: refreshDio,
      tokenHeader: (token) => {'Authorization': 'Bearer ${token.accessToken}'},
      shouldRefresh: (response) {
        final code = response?.statusCode;
        return code == 401 || code == 419;
      },
      refreshToken: (token, client) async {
        try {
          final response = await client.get(
            'https://auth.muzhiki.pro/api/v1/auth/refresh',
            options: Options(extra: {"isRefreshReq": true}),
          );
          final access = response.data['data']['access_token'] as String?;
          if (access == null ||
              response.data["error"] == "Токен уже использован ранее." ||
              response.data["error"] == "Resresh-токен не найден в базе." ||
              response.data["error"] == "Refresh token был отозван") {
            throw RevokeTokenException();
          }
          return AuthTokens(accessToken: access, refreshToken: "");
        } catch (e, st) {
          final error = AppErrorMapper.I.map(e, st);
          if (error.message == "Resresh-токен не найден в базе." ||
              error.message == "Токен уже использован ранее." ||
              error.message == "Refresh token был отозван") {
            throw RevokeTokenException();
          }
          return token ?? const AuthTokens(accessToken: "", refreshToken: "");
        }
      },
    );
    final cookieManager = CookieManager(cookieJar);
    final metricsStorage = RequestStorage(
      sharedPreferences: sharedPreferences,
      authDio: authDio,
    );
    final connectivityService = NetworkConnectivityService(Connectivity());
    await connectivityService.init();
    final metricsInterceptor = MetricsInterceptor(
      userSession: userSession,
      typeApp: typeApp,
      infoProject: infoProject,
      metricsStorage: metricsStorage,
      connectivityService: connectivityService,
    );
    final talkerInterceptor = TalkerDioLogger(
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
    );
    refreshDio.interceptors.addAll([cookieManager, talkerInterceptor]);

    authDio.interceptors.addAll([
      if (needMetricsHttp) metricsInterceptor,
      cookieManager,
      talkerInterceptor,

      errorInterceptor,
      cacheInterceptor,
      fresh,
    ]);

    return NetworkModel(
      uriLauncer: MuzhikiUrlLaunch.I,
      authDio: authDio,
      refreshDio: refreshDio,
      fresh: fresh,
    );
  }
}
