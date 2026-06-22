import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:muzhiki_core/dependecies/model/network_model.dart';
import 'package:muzhiki_core/dependecies/network/interceptors/error_interceptor.dart';
import 'package:muzhiki_core/dependecies/network/utils/network_status_controller.dart';
import 'package:muzhiki_core/dependecies/network/utils/network_vnp_detector.dart';
import 'package:muzhiki_core/dependecies/service/session/token_storage.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class NetworkFactory {
  static Future<NetworkModel> create({
    required AppVpnDetector vpnDetector,
    required Talker talker,
    required HiveCacheStore store,
    required SecureStringTokenStorage tokenStorage,
  }) async {
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
    final fresh = Fresh<String>(
      tokenStorage: tokenStorage,
      httpClient: refreshDio,
      tokenHeader: (token) => {'Authorization': 'Bearer $token'},
      shouldRefresh: (response) {
        final code = response?.statusCode;
        return code == 401 || code == 419;
      },
      refreshToken: (token, client) async {
        try {
          final response = await client.get(
            'AppPathConstant.refresh',
            options: Options(
              extra: {'isRefreshRequest': true, 'showError': false},
            ),
          );

          final newAccessToken =
              response.data['data']['access_token'] as String?;

          if (newAccessToken == null || newAccessToken.isEmpty) {
            throw RevokeTokenException();
          }

          return newAccessToken;
        } catch (e, st) {
          talker.error('Ошибка ревреша', e, st);
          throw RevokeTokenException();
        }
      },
    );
    final talkerInterceptor = TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printErrorData: false,
        printErrorHeaders: false,

        printErrorMessage: true,

        printRequestData: false,
        printRequestExtra: false,
        printRequestHeaders: false,

        printResponseData: true,

        printResponseHeaders: false,

        printResponseMessage: false,

        printResponseRedirects: false,
        printResponseTime: false,
      ),
    );
    refreshDio.interceptors.addAll([talkerInterceptor]);

    authDio.interceptors.addAll([
      // talkerInterceptor,
      errorInterceptor,
      cacheInterceptor,
      fresh,
    ]);

    return NetworkModel(
      networkStatusController: newtworkStateController,
      authDio: authDio,
      refreshDio: refreshDio,
      fresh: fresh,
      vpnDetector: vpnDetector,
    );
  }
}
