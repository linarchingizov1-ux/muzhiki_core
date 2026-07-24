import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/refresh_manager.dart';
import 'package:talker/talker.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokenStorage,
    required this.refreshManager,
    required this.talker,
  });

  final TokenStorage tokenStorage;
  final RefreshManager refreshManager;
  final Talker talker;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (options.extra["isRefresh"] != true && refreshManager.isRefreshing) {
        talker.debug(
          '[AuthInterceptor] ⏳ Ожидание refresh перед ${options.method} ${options.uri}',
        );

        await refreshManager.waitIfRefreshing();

        talker.debug(
          '[AuthInterceptor] ✅ Refresh завершён, продолжаем ${options.method} ${options.uri}',
        );
      }

      final token = await tokenStorage.read();

      if (token?.accessToken.isNotEmpty ?? false) {
        options.headers["Authorization"] = "Bearer ${token!.accessToken}";
      }

      handler.next(options);
    } on DioException catch (e) {
      handler.reject(e);
    } catch (e, st) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          stackTrace: st,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}
