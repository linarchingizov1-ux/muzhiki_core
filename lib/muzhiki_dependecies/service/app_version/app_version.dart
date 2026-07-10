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

    _appInfo = AppInfoModel(
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );

    return _appInfo!;
  }

  Future<void> init() async {
    await info;
  }
}
