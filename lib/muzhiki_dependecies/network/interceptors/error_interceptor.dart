import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_core.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';

class AppErrorInterceptor extends Interceptor {
  AppErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final isRefreshRequest = err.requestOptions.extra['isRefreshReq'] ?? false;
    if (isRefreshRequest) {
      final mapped = AppErrorMapper.I.map(err);

      MuzhikiDependencies.I.banner.show(message: mapped.message);
    } else {
      handler.next(err);
    }
  }
}
