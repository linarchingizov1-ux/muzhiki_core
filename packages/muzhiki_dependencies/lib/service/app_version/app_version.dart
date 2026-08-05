import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:muzhiki_dependencies/service/app_version/model/app_info_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:android_id/android_id.dart';

class AppInfoService {
  AppInfoService._();

  static final AppInfoService I = AppInfoService._();

  AppInfoModel? _appInfo;
  String deviceId = '';

  Future<AppInfoModel> get info async {
    if (_appInfo != null) {
      return _appInfo!;
    }

    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      final deviceId = await const AndroidId().getId() ?? '';

      _appInfo = AppInfoModel(
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
        platform: 'android',
        osVersion: androidInfo.version.release,
        manufacturer: androidInfo.manufacturer,
        model: androidInfo.model,
        deviceId: deviceId,
      );
    } else {
      final iosInfo = await deviceInfo.iosInfo;

      _appInfo = AppInfoModel(
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
        platform: 'ios',
        osVersion: iosInfo.systemVersion,
        manufacturer: 'Apple',
        model: iosInfo.utsname.machine,
        deviceId: iosInfo.identifierForVendor ?? '',
      );
    }

    return _appInfo!;
  }

  Future<void> init() async {
    await info;
  }
}
