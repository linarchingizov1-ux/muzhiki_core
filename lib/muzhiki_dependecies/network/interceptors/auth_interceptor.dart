import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/refresh_manager.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.tokenStorage, required this.refreshManager});

  final TokenStorage<AuthTokens> tokenStorage;
  final RefreshManager refreshManager;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (options.extra["isRefresh"] != true) {
        await refreshManager.waitIfRefreshing();
      }

      final token = await tokenStorage.read();

      if (token != null && token.accessToken.isNotEmpty) {
        options.headers["Authorization"] = "Bearer ${token.accessToken}";
      }

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}
