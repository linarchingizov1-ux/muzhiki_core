import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_version/model/app_info_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  AppInfoService._();

  static final AppInfoService I = AppInfoService._();

  AppInfoModel? _appInfo;

  Future<AppInfoModel> get info async {
    if (_appInfo != null) {
      return _appInfo!;
    }

    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;

      _appInfo = AppInfoModel(
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
        platform: 'android',
        osVersion: androidInfo.version.release,
        manufacturer: androidInfo.manufacturer,
        model: androidInfo.model,
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
      );
    }

    return _appInfo!;
  }

  Future<void> init() async {
    await info;
  }
}
