import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:muzhiki_core/muzhiki_dependecies/model/network_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/interceptors/error_interceptor.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/url_launch/url_launch.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/utils/network_status_controller.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/token_storage.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class NetworkFactory {
  static Future<NetworkModel> create({
    required bool enableTalker,
    required bool showReqHeaders,
    required Talker talker,
    required HiveCacheStore store,
    required SecureTokenStorage tokenStorage,
    required PersistCookieJar cookieJar,
  }) async {
    await cookieJar.forceInit();

    final newtworkStateController = NetworkStatusController.I;
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
          talker.debug("Ошибка в ревреше ${error.message}, stack: $st");
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
      cookieManager,
      talkerInterceptor,

      errorInterceptor,
      cacheInterceptor,
      fresh,
    ]);

    return NetworkModel(
      uriLauncer: MuzhikiUrlLaunch.I,
      networkStatusController: newtworkStateController,
      authDio: authDio,
      refreshDio: refreshDio,
      fresh: fresh,
    );
  }
}
