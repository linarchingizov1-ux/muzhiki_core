import 'package:dio/dio.dart';

class AppErrorInterceptor extends Interceptor {
  AppErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final isRefresh = (err.requestOptions.extra['isRefresh'] as bool?) ?? false;
    final tryReq = (err.requestOptions.extra['count_try'] as int?) ?? 0;
    if (isRefresh) {
      return;
    }
    if (tryReq > 3) {
      return;
    } else {
      handler.next(err);
    }
  }
}
