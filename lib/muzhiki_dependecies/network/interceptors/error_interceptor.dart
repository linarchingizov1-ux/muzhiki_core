import 'package:dio/dio.dart';

class AppErrorInterceptor extends Interceptor {
  AppErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final isRefresh = (err.requestOptions.extra['isRefresh'] as bool?) ?? false;
    final skipMetrics =
        (err.requestOptions.extra['skipMetrics'] as bool?) ?? false;

    if (isRefresh || skipMetrics) {
      handler.next(err);
      return;
    }

    handler.next(err);
  }
}
