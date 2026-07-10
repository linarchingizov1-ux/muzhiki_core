import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_exception.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_enum.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_version/model/app_info_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/user_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_batch.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_metric.dart';
import 'package:talker/talker.dart';

class RequestStorage {
  final Dio authDio;
  final bool showTalkerMetricsHttp;
  final SharedPreferences sharedPreferences;

  final List<RequestMetric> _metrics = [];

  static const batchSize = 10;

  Talker get talker => Talker(
    settings: TalkerSettings(
      enabled: true,
      colors: {
        TalkerKey.debug: AnsiPen()..green(),
        TalkerKey.info: AnsiPen()..cyan(),
        TalkerKey.warning: AnsiPen()..yellow(),
        TalkerKey.error: AnsiPen()..red(),
      },
    ),
  );

  RequestStorage({
    required this.sharedPreferences,
    required this.authDio,
    required this.showTalkerMetricsHttp,
  });

  Future<void> init() async {
    final data = sharedPreferences.getString("metrics_data");

    if (data == null) return;

    final json = jsonDecode(data) as List;

    _metrics.addAll(json.map((e) => RequestMetric.fromJson(e)));
  }

  Future<void> addMetrics({
    required UserSession userSession,
    required RequestMetric metrics,
    required TypeApp typeApp,
    required AppInfoModel infoProject,
  }) async {
    try {
      if (_metrics.length == batchSize) {
        await sendMetrics(
          typeApp: typeApp,
          infoProject: infoProject,
          userSession: userSession,
        );
      } else if (_metrics.length > batchSize) {
        _metrics.clear();
        await sharedPreferences.setString("metrics_data", jsonEncode(_metrics));
      } else {
        _metrics.add(metrics);
        await sharedPreferences.setString("metrics_data", jsonEncode(_metrics));
        if (showTalkerMetricsHttp) {
          talker.debug('''
📊 Метрики сохранены локально

Кол-во метрик: ${_metrics.length}

Последний запрос:
${const JsonEncoder.withIndent('  ').convert(metrics.toJson())}
''');
        }
      }
    } on AppException catch (e) {
      talker.error("Ошибка отправки метрик:\n${e.debugMessage}");
    }
  }

  RequestPlatform get platform {
    if (Platform.isAndroid) {
      return RequestPlatform.android;
    } else {
      return RequestPlatform.ios;
    }
  }

  Future<void> sendMetrics({
    required UserSession userSession,
    required TypeApp typeApp,
    required AppInfoModel infoProject,
  }) async {
    if (_metrics.isEmpty) return;
    final userMpid = int.tryParse(userSession.user?.mpid ?? "");

    final batch = RequestBatch(
      batchTimestamp: DateTime.now().toUtc(),

      sessionId: _getSessionId(),

      appName: typeApp.nameApp,

      platform: platform,

      appVersion: infoProject.version,

      mpid: userMpid,

      requests: List.of(_metrics),
    ).toJson();
    if (showTalkerMetricsHttp) {
      talker.debug(
        "Отправляем RequestBatch\n${const JsonEncoder.withIndent('  ').convert(batch)}",
      );
    }

    try {
      await authDio.post(
        "https://metrics.dev.muzhiki.pro/metrics/client-network",
        data: batch,
        options: Options(extra: {"skipMetrics": true, "skipRetry": true}),
      );

      _metrics.clear();

      await sharedPreferences.remove("metrics_data");
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }

  String _getSessionId() {
    return sharedPreferences.getString('metrics_session_id') ?? '';
  }
}
