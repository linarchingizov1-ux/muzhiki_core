import 'dart:io';

import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_exception.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_enum.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_version/model/app_info_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/user_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_batch.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_metric.dart';
import 'package:talker/talker.dart';

class RequestStorage {
  final Dio authDio;
  final SharedPreferences sharedPreferences;

  final List<RequestMetric> _metrics = [];

  int tryCount = 0;

  RequestStorage({required this.sharedPreferences, required this.authDio});

  Future<void> saveMetrics({
    required UserSession userSession,
    required RequestMetric metrics,
    required TypeApp typeApp,
    required AppInfoModel infoProject,
  }) async {
    if (tryCount > 3) return;
    _metrics.add(metrics);
    Talker().debug(_metrics);
    try {
      await sendMetrics(
        typeApp: typeApp,
        infoProject: infoProject,
        userSession: userSession,
      );
    } on AppException catch (e) {
      BannerController.I.show(message: e.message);
    } finally {
      tryCount++;
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
    Talker().debug("Отправляем метрики\n\n$batch");
    try {
      await authDio.post(
        "https://metrics.dev.muzhiki.pro/metrics/client-network",
        data: batch,
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
