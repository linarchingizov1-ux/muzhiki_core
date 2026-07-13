import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

  static const int batchSize = 10;
  DateTime? _lastFailedSend;
  bool _isSending = false;

  Talker get talker => Talker();

  RequestStorage({
    required this.sharedPreferences,
    required this.authDio,
    required this.showTalkerMetricsHttp,
  });

  Future<void> init() async {
    try {
      final data = sharedPreferences.getString("metrics_data");
      if (data == null) return;
      final json = jsonDecode(data) as List;
      _metrics.addAll(json.map((e) => RequestMetric.fromJson(e)));
    } catch (e) {
      await sharedPreferences.remove("metrics_data");
    }
  }

  Future<void> addMetrics({
    required UserSession userSession,
    required RequestMetric metrics,
    required TypeApp typeApp,
    required AppInfoModel infoProject,
  }) async {
    _metrics.add(metrics);

    await sharedPreferences.setString(
      "metrics_data",
      jsonEncode(_metrics.map((e) => e.toJson()).toList()),
    );

    if (showTalkerMetricsHttp) {
      talker.debug('📊 Добавлена метрика. Всего накоплено: ${_metrics.length}');
    }

    if (!_isSending && _metrics.length >= batchSize) {
      unawaited(
        sendMetrics(
          typeApp: typeApp,
          infoProject: infoProject,
          userSession: userSession,
        ),
      );
    }
  }

  RequestPlatform get platform =>
      Platform.isAndroid ? RequestPlatform.android : RequestPlatform.ios;

  Future<void> sendMetrics({
    required UserSession userSession,
    required TypeApp typeApp,
    required AppInfoModel infoProject,
  }) async {
    if (_isSending || _metrics.isEmpty) return;
    _isSending = true;
    if (_lastFailedSend != null &&
        DateTime.now().difference(_lastFailedSend!) <
            const Duration(minutes: 1)) {
      return;
    }
    final List<RequestMetric> batchItems = _metrics.take(batchSize).toList();
    final userMpid = int.tryParse(userSession.user?.mpid ?? "");

    final batch = RequestBatch(
      batchTimestamp: DateTime.now().toUtc(),
      sessionId: _getSessionId(),
      appName: typeApp.nameApp,
      platform: platform,
      appVersion: infoProject.version,
      mpid: userMpid,
      requests: batchItems,
    ).toJson();

    final jsonString = jsonEncode(batch);
    const encoder = JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(batch);

    printLong(prettyJson);
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        await authDio.post(
          "https://metrics.dev.muzhiki.pro/metrics/client-network",
          data: jsonString,
          options: Options(extra: {"skipMetrics": true, "skipRetry": true}),
        );

        _metrics.removeRange(0, batchItems.length);
        await sharedPreferences.setString(
          "metrics_data",
          jsonEncode(_metrics.map((e) => e.toJson()).toList()),
        );

        _isSending = false;

        if (_metrics.length >= batchSize) {
          await sendMetrics(
            userSession: userSession,
            typeApp: typeApp,
            infoProject: infoProject,
          );
        }
        return;
      } catch (e) {
        talker.warning("⚠️ Попытка отправки метрик $attempt из 3 провалилась.");
        if (attempt == 3) {
          talker.error("❌ Не удалось отправить батч метрик после 3 попыток.");
          _isSending = false;
          _lastFailedSend = DateTime.now();
          return;
        }
        await Future.delayed(const Duration(milliseconds: 1500));
      } finally {
        if (_metrics.isNotEmpty) _metrics.clear();
        await sharedPreferences.setString(
          "metrics_data",
          jsonEncode(_metrics.map((e) => e.toJson()).toList()),
        );
        _isSending = false;
      }
    }
  }

  String _getSessionId() =>
      sharedPreferences.getString('metrics_session_id') ?? '';
}
