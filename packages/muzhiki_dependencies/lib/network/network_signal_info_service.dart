import 'dart:io';

import 'package:flutter/services.dart';

abstract final class NetworkSignalInfoService {
  static const _channel = MethodChannel('report_problem/network_info');

  static Future<int?> cellularDbm() => _invoke<int>('getCellularDbm');

  static Future<int?> wifiRssi() => _invoke<int>('getWifiRssi');

  static Future<String?> carrierName() => _invoke<String>('getCarrierName');

  static Future<List<Map<String, dynamic>>> simsInfo() async {
    if (!Platform.isAndroid) return const [];
    try {
      final result = await _channel.invokeListMethod<Map<Object?, Object?>>(
        'getSimsInfo',
      );
      return result
              ?.map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
              .toList() ??
          const [];
    } on Exception {
      return const [];
    }
  }

  static Future<T?> _invoke<T>(String method) async {
    if (!Platform.isAndroid) return null;
    try {
      return await _channel.invokeMethod<T>(method);
    } on Exception {
      return null;
    }
  }
}
