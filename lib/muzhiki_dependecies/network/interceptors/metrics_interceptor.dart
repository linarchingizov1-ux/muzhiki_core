import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/extension/dio_error_extension.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_enum.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_metric.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/request_storage.dart';
import 'dart:developer';

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
    log("[ТИП СОЕДИНЕНИЯ]\n\n${connectivityService.currentType}");

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

      method: _parseMethod(request.method),

      durationMs: context.stopwatch.elapsedMilliseconds,

      statusCode: response?.statusCode ?? error?.response?.statusCode,

      success:
          response != null &&
          response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300,

      errorType: error?.requestError,

      requestSizeBytes: null,

      responseSizeBytes: null,

      networkType: connectivityService.currentType,

      vpnActive: null,

      requestId:
          response?.headers.value('x-request-id') ??
          error?.response?.headers.value('x-request-id'),
    );
    final prettyJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(metric.toJson());

    log("[МЕТРИКИ ДЛЯ БЭКА]\n\n$prettyJson");
    metricsStorage.saveMetrics(metrics: metric);
  }

  RequestMethod _parseMethod(String method) {
    return RequestMethod.values.firstWhere(
      (e) => e.name.toUpperCase() == method,
      orElse: () => RequestMethod.get,
    );
  }
}
