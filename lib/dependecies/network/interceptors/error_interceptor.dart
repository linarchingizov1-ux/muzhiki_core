import 'package:dio/dio.dart';
import 'package:muzhiki_core/dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/dependecies/network/extension/dio_error_extension.dart';
import 'package:muzhiki_core/dependecies/network/utils/network_status_controller.dart';
import 'package:muzhiki_core/muzhiki_core.dart';

class AppErrorInterceptor extends Interceptor {
  AppErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final showError = err.requestOptions.extra['showError'] ?? true;
    final isRefreshRequest =
        err.requestOptions.extra['isRefreshRequest'] == true;

    if (showError && !isRefreshRequest && !err.isAuthError) {
      final mapped = AppErrorMapper.I.map(err);

      if (err.isBackendError) {
        NetworkStatusController.I.setErrorBackend();
      }

      MuzhikiCore.I.banner.show(message: mapped.message);
    }

    handler.next(err);
    Future.delayed(
      const Duration(seconds: 1),
      () => NetworkStatusController.I.setOk(),
    );
  }
}
