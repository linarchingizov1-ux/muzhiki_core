import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/network_problem_service.dart';

class AppErrorInterceptor extends Interceptor {
  AppErrorInterceptor({this.networkIssueService});

  final NetworkProblemService? networkIssueService;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final isRefresh = (err.requestOptions.extra['isRefresh'] as bool?) ?? false;
    final skipMetrics =
        (err.requestOptions.extra['skipMetrics'] as bool?) ?? false;

    if (isRefresh || skipMetrics) {
      handler.next(err);
      return;
    }

    networkIssueService?.onRequestError(err);
    handler.next(err);
  }
}
