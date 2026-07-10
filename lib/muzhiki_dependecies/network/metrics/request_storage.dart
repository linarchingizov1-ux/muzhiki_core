import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_metric.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

class RequestStorage {
  final Dio authDio;
  final SharedPreferences sharedPreferences;
  const RequestStorage({
    required this.sharedPreferences,
    required this.authDio,
  });

  Future<void> saveMetrics({required RequestMetric metrics}) async {
    await _postMetrics(metrics: metrics);
  }

  Future<void> _postMetrics({required RequestMetric metrics}) async {
    try {
      final metricsJson = jsonEncode(metrics);
      Talker().debug(metricsJson);

      // final response = await authDio.post(
      //   "https://metrics.dev.muzhiki.pro/metrics/client-network",
      //   data: {

      //   }
      // );
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }
}
