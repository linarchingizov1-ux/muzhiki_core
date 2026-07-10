import 'dart:async';
import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/extension/dio_error_extension.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/extension/req_and_res_size_bytes.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_metric.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/request_storage.dart';

import 'package:muzhiki_core/muzhiki_dependecies/network/network_type_service.dart';

class MetricsContext {
  MetricsContext(this.startedAt) : stopwatch = Stopwatch()..start();

  final DateTime startedAt;
  final Stopwatch stopwatch;
}

class MetricsInterceptor extends Interceptor {
  final RequestStorage metricsStorage;
  final NetworkConnectivityService connectivityService;

  const MetricsInterceptor({
    required this.metricsStorage,
    required this.connectivityService,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['metrics'] = MetricsContext(DateTime.now().toUtc());

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _saveMetrics(response: response);

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _saveMetrics(error: err);

    handler.next(err);
  }

  void _saveMetrics({Response? response, DioException? error}) {
    final request = response?.requestOptions ?? error?.requestOptions;

    if (request == null) return;

    final context = request.extra['metrics'] as MetricsContext?;

    if (context == null) return;

    context.stopwatch.stop();

    final metric = RequestMetric(
      startedAt: context.startedAt,

      path: request.uri.path,

      pathRaw:
          request.uri.path +
          (request.uri.hasQuery ? '?${request.uri.query}' : ''),

      method: request.requestMethod,

      durationMs: context.stopwatch.elapsedMilliseconds,

      statusCode: response?.statusCode ?? error?.response?.statusCode,

      success: response.isSuccess,

      errorType: error?.requestError,

      requestSizeBytes: request.requestSizeBytes,

      responseSizeBytes: response.responseSizeBytes,

      networkType: connectivityService.currentType,

      vpnActive: InternetCheckNotifier.I.isVpnEnabled,

      requestId:
          response?.headers.value('x-request-id') ??
          error?.response?.headers.value('x-request-id'),
    );
    unawaited(metricsStorage.saveMetrics(metrics: metric));
  }
}
