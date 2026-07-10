import 'dart:io';

import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_enum.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_version/model/app_info_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_batch.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_metric.dart';

class RequestStorage {
  final Dio authDio;
  final SharedPreferences sharedPreferences;

  final List<RequestMetric> _metrics = [];

  RequestStorage({required this.sharedPreferences, required this.authDio});

  Future<void> saveMetrics({
    required RequestMetric metrics,
    required TypeApp typeApp,
    required AppInfoModel infoProject,
  }) async {
    _metrics.add(metrics);

    await sendMetrics(typeApp: typeApp, infoProject: infoProject);
  }

  RequestPlatform get platform {
    if (Platform.isAndroid) {
      return RequestPlatform.android;
    } else {
      return RequestPlatform.ios;
    }
  }

  Future<void> sendMetrics({
    required TypeApp typeApp,
    required AppInfoModel infoProject,
  }) async {
    if (_metrics.isEmpty) return;

    final batch = RequestBatch(
      batchTimestamp: DateTime.now().toUtc(),

      sessionId: _getSessionId(),

      appName: typeApp.nameApp,

      platform: platform,

      appVersion: infoProject.version,

      mpid: null,

      requests: List.of(_metrics),
    );

    try {
      await authDio.post(
        "https://metrics.dev.muzhiki.pro/metrics/client-network",
        data: batch.toJson(),
      );

      _metrics.clear();
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }

  String _getSessionId() {
    return sharedPreferences.getString('metrics_session_id') ?? '';
  }
}
