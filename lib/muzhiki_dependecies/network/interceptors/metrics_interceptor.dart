import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/extension/dio_error_extension.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_enum.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_metric.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/request_storage.dart';

class MetricsContext {
  MetricsContext(this.startedAt) : stopwatch = Stopwatch()..start();

  final DateTime startedAt;
  final Stopwatch stopwatch;
}

class MetricsInterceptor extends Interceptor {
  final RequestStorage metricsStorage;
  const MetricsInterceptor({required this.metricsStorage});
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['metrics'] = MetricsContext(DateTime.now().toUtc());
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final request = response.requestOptions;

    final context = request.extra['metrics'] as MetricsContext;

    context.stopwatch.stop();

    final metrics = RequestMetric(
      startedAt: context.startedAt,

      path: request.uri.path,

      pathRaw:
          request.uri.path +
          (request.uri.hasQuery ? '?${request.uri.query}' : ''),

      method: RequestMethod.values.firstWhere(
        (e) => e.name.toUpperCase() == request.method,
      ),

      durationMs: context.stopwatch.elapsedMilliseconds,

      statusCode: response.statusCode,

      success:
          response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300,

      errorType: null,

      requestSizeBytes: null,

      responseSizeBytes: null,

      networkType: RequestNetwork.unknown,

      vpnActive: null,

      requestId: response.headers.value('x-request-id'),
    );

    metricsStorage.saveMetrics(metrics: metrics);

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final request = err.requestOptions;

    final context = request.extra['metrics'] as MetricsContext;

    context.stopwatch.stop();

    final metrics = RequestMetric(
      startedAt: context.startedAt,

      path: request.uri.path,

      pathRaw:
          request.uri.path +
          (request.uri.hasQuery ? '?${request.uri.query}' : ''),

      method: RequestMethod.values.firstWhere(
        (e) => e.name.toUpperCase() == request.method,
      ),

      durationMs: context.stopwatch.elapsedMilliseconds,

      statusCode: err.response?.statusCode,

      success: false,

      errorType: err.requestError,

      requestSizeBytes: null,

      responseSizeBytes: null,

      networkType: RequestNetwork.unknown,

      vpnActive: null,

      requestId: err.response?.headers.value('x-request-id'),
    );

    metricsStorage.saveMetrics(metrics: metrics);

    handler.next(err);
  }
}
