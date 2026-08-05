class AppInfoModel {
  final String version;
  final String buildNumber;
  final String platform;
  final String osVersion;
  final String? manufacturer;
  final String model;
  final String deviceId;

  const AppInfoModel({
    required this.version,
    required this.buildNumber,
    required this.platform,
    required this.osVersion,
    required this.manufacturer,
    required this.model,
    required this.deviceId,
  });

  @override
  String toString() {
    return 'AppInfo(version: $version, buildNumber: $buildNumber, platform: $platform, osVersion: $osVersion, manufacturer: $manufacturer, model: $model deviceId: $deviceId)';
  }
}
