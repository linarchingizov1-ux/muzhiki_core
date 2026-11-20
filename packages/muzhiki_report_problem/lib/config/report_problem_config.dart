import 'package:dio/dio.dart';

class ReportAppInfo {
  final String version;
  final String buildNumber;
  final String platform;
  final String osVersion;
  final String? manufacturer;
  final String model;
  final String deviceId;

  const ReportAppInfo({
    required this.version,
    required this.buildNumber,
    required this.platform,
    required this.osVersion,
    required this.manufacturer,
    required this.model,
    required this.deviceId,
  });
}

class ReportProblemConfig {
  final String? explicitMpid;
  final Object? _rawAppInfo;
  final Object? _legacySession;
  final Object? _legacyTalker;
  final Object? _legacyRequestStorage;
  final Object? _legacyBannerController;
  final Dio dio;
  final String appName;
  final List<Map<String, dynamic>> Function()? recentRequests;
  final List<Map<String, dynamic>> Function()? consoleLogs;
  final String Function()? networkType;
  final Future<Map<String, dynamic>> Function(String networkType)?
  connectionDetails;
  final Map<String, dynamic> Function()? screenInfo;
  final void Function(String message)? showMessage;
  final double dialogBottomRadius;

  const ReportProblemConfig({
    this.explicitMpid,
    required Object appInfo,
    required this.dio,
    required this.appName,
    this.recentRequests,
    this.consoleLogs,
    this.networkType,
    this.connectionDetails,
    this.screenInfo,
    this.showMessage,
    this.dialogBottomRadius = 32,
    @Deprecated('Use mpid instead') Object? session,
    @Deprecated('Use consoleLogs instead') Object? talker,
    @Deprecated('Use recentRequests instead') Object? requestStorage,
    @Deprecated('Use showMessage instead') Object? bannerController,
  }) : _rawAppInfo = appInfo,
       _legacySession = session,
       _legacyTalker = talker,
       _legacyRequestStorage = requestStorage,
       _legacyBannerController = bannerController;

  String? get mpid {
    if (explicitMpid != null) return explicitMpid;
    try {
      return ((_legacySession as dynamic).user?.mpid as String?);
    } catch (_) {
      return null;
    }
  }

  ReportAppInfo get appInfo {
    if (_rawAppInfo is ReportAppInfo) return _rawAppInfo;
    final value = _rawAppInfo as dynamic;
    return ReportAppInfo(
      version: value.version as String,
      buildNumber: value.buildNumber as String,
      platform: value.platform as String,
      osVersion: value.osVersion as String,
      manufacturer: value.manufacturer as String?,
      model: value.model as String,
      deviceId: value.deviceId as String,
    );
  }

  List<Map<String, dynamic>> get resolvedConsoleLogs {
    if (consoleLogs != null) return consoleLogs!.call();
    try {
      final history = ((_legacyTalker as dynamic).history as List).take(100);
      return history.map((item) {
        final value = item as dynamic;
        return <String, dynamic>{
          'timestamp': (value.time as DateTime).toUtc().toIso8601String(),
          'level': value.logLevel?.toString(),
          'message': value.generateTextMessage() as String,
        };
      }).toList();
    } catch (_) {
      return const [];
    }
  }

  List<Map<String, dynamic>> get resolvedRecentRequests {
    if (recentRequests != null) return recentRequests!.call();
    try {
      final metrics = ((_legacyRequestStorage as dynamic).metrics as List)
          .reversed
          .take(10)
          .toList()
          .reversed;
      return metrics.map((metric) {
        final value = metric as dynamic;
        final json = value.toJson() as Map;
        return <String, dynamic>{
          'timestamp': (value.startedAt as DateTime).toUtc().toIso8601String(),
          'method': json['method'],
          'url': value.path,
          'status_code': value.statusCode,
          'duration_ms': value.durationMs,
          'success': value.success,
          'request_id': value.requestId,
          'error': json['error_type'],
        };
      }).toList();
    } catch (_) {
      return const [];
    }
  }

  String get resolvedNetworkType {
    if (networkType != null) return networkType!.call();
    try {
      final metrics = ((_legacyRequestStorage as dynamic).metrics as List);
      if (metrics.isNotEmpty) {
        return (metrics.last as dynamic).networkType.jsonKey as String;
      }
    } catch (_) {}
    return 'unknown';
  }

  void showMessageResolved(String message) {
    if (showMessage != null) {
      showMessage!.call(message);
      return;
    }
    try {
      (_legacyBannerController as dynamic).show(message: message);
    } catch (_) {}
  }
}
