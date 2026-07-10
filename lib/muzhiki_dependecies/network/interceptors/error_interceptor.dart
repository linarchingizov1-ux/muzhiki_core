import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_core.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';

class AppErrorInterceptor extends Interceptor {
  AppErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.extra['skipRetry'] == true) {
      handler.next(err);
      return;
    }

    if (err.requestOptions.extra['isRefreshReq'] == true) {
      final mapped = AppErrorMapper.I.map(err);
      MuzhikiDependencies.I.banner.show(message: mapped.message);
    }

    handler.next(err);
  }
}
