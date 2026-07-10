import 'dart:async';
import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/extension/dio_error_extension.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/extension/req_and_res_size_bytes.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_metric.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/request_storage.dart';

import 'package:muzhiki_core/muzhiki_dependecies/network/network_type_service.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_version/model/app_info_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/user_session.dart';

class MetricsContext {
  MetricsContext(this.startedAt) : stopwatch = Stopwatch()..start();

  final DateTime startedAt;
  final Stopwatch stopwatch;
  bool completed = false;
}

class MetricsInterceptor extends Interceptor {
  final RequestStorage metricsStorage;
  final TypeApp typeApp;
  final UserSession userSession;
  final bool showTalkerMetricsHttp;
  final AppInfoModel infoProject;
  final NetworkConnectivityService connectivityService;

  const MetricsInterceptor({
    required this.metricsStorage,
    required this.connectivityService,
    required this.typeApp,
    required this.infoProject,
    required this.userSession,
    required this.showTalkerMetricsHttp,
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
    if (context?.completed ?? true) return;
    if (context == null) return;
    context.completed = true;
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

    unawaited(
      metricsStorage.addMetrics(
        userSession: userSession,
        metrics: metric,
        typeApp: typeApp,
        infoProject: infoProject,
      ),
    );
  }
}
