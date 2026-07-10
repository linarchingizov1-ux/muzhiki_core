class AppInfoModel {
  final String version;
  final String buildNumber;

  const AppInfoModel({required this.version, required this.buildNumber});

  @override
  String toString() {
    return 'AppInfo(version: $version, buildNumber: $buildNumber)';
  }
}
