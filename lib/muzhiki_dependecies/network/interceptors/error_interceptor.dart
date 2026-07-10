import 'package:dio/dio.dart';

class AppErrorInterceptor extends Interceptor {
  AppErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final isRefresh = (err.requestOptions.extra['isRefresh'] as bool?) ?? false;
    if (isRefresh) {
      return;
    } else {
      handler.next(err);
    }
  }
}
