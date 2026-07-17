import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_exception.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/network_signal_info_service.dart';
import 'package:muzhiki_core/muzhiki_report_problem/config/report_problem_config.dart';
import 'package:muzhiki_core/muzhiki_report_problem/domain/repository/report_problem_repository.dart';
import 'package:path/path.dart' as path;
import 'package:talker/talker.dart';

class ReportProblemViewModel extends ChangeNotifier {
  ReportProblemViewModel({required this.config, required this._repository}) {
    descriptionController.addListener(notifyListeners);
  }

  final ReportProblemConfig config;
  final ReportProblemRepository _repository;

  bool isSubmitting = false;
  bool? isSubmitSuccess;
  String? submitError;

  final descriptionController = TextEditingController();

  File? _compressedScreenshot;

  String? screenshotPath;

  static const _maxScreenshotBytes = 10 * 1024 * 1024;

  int? get _mpid => int.tryParse(config.session.user?.mpid ?? '');

  String get _occurredAt => DateTime.now().toUtc().toIso8601String();

  Map<String, dynamic> get _app => {
    'name': config.appName,
    'version': config.appInfo.version,
    'build': config.appInfo.buildNumber,
    'environment': kDebugMode ? 'development' : 'production',
  };

  Future<Map<String, dynamic>> _device() async {
    final view = PlatformDispatcher.instance.views.first;
    TimezoneInfo? timezone;
    try {
      timezone = await FlutterTimezone.getLocalTimezone();
    } catch (_) {
      timezone = null;
    }

    return {
      'platform': config.appInfo.platform,
      'os_version': config.appInfo.osVersion,
      'manufacturer': config.appInfo.manufacturer,
      'model': config.appInfo.model,
      'screen_width': view.physicalSize.width.round(),
      'screen_height': view.physicalSize.height.round(),
      'locale': PlatformDispatcher.instance.locale.toLanguageTag(),
      'timezone': timezone?.identifier ?? DateTime.now().timeZoneName,
    };
  }

  Future<Map<String, dynamic>> _connection() async {
    final metrics = config.requestStorage.metrics;
    final type = metrics.isNotEmpty
        ? metrics.last.networkType.jsonKey
        : 'unknown';

    int? signalStrength;
    String? carrier;

    try {
      switch (type) {
        case 'cellular':
          final sims = await NetworkSignalInfoService.simsInfo();
          if (sims.isNotEmpty) {
            carrier = sims.map(_simLabel).join(' | ');
          } else {
            carrier = await NetworkSignalInfoService.carrierName();
          }
          // signal_strength dBm активной симкарты
          signalStrength = await NetworkSignalInfoService.cellularDbm();
        case 'wifi':
          signalStrength = await NetworkSignalInfoService.wifiRssi();
      }
    } catch (_) {}

    return {
      'type': type,
      'is_online': type != 'none',
      'carrier': carrier,
      'signal_strength': signalStrength,
    };
  }

  String _simLabel(Map<String, dynamic> sim) {
    final name = (sim['carrier'] as String?) ?? '?';
    return sim['is_data_sim'] == true ? '$name (активная)' : name;
  }

  List<Map<String, dynamic>> _consoleLogs() {
    final history = config.talker.history;
    final items = history.length > 100
        ? history.sublist(history.length - 100)
        : history;

    return items.map((item) {
      final message = item.generateTextMessage();
      final sanitizedMessage = _sanitizeLog(message);

      return {
        'timestamp': item.time.toUtc().toIso8601String(),
        'level': _logLevel(item.logLevel),
        'message': sanitizedMessage.length > 10000
            ? sanitizedMessage.substring(0, 10000)
            : sanitizedMessage,
      };
    }).toList();
  }

  String _sanitizeLog(String message) {
    final withoutResponseBody = message.replaceFirst(
      RegExp(r'\nData:[\s\S]*$'),
      '\nData: [removed]',
    );

    return withoutResponseBody.replaceAllMapped(
      RegExp(r'(https?://[^\s?]+)\?[^\s]+'),
      (match) => match.group(1)!,
    );
  }

  List<Map<String, dynamic>> _recentRequests() {
    final metrics = config.requestStorage.metrics;
    final items = metrics.length > 10
        ? metrics.sublist(metrics.length - 10)
        : metrics;

    return items.map((metric) {
      final json = metric.toJson();
      final statusCode = metric.statusCode;

      return {
        'timestamp': metric.startedAt.toUtc().toIso8601String(),
        'method': json['method'],
        'url': metric.path,
        'status_code': statusCode,
        'duration_ms': metric.durationMs,
        'success': metric.success,
        'request_id': metric.requestId,
        'error': json['error_type'],
      };
    }).toList();
  }

  Map<String, dynamic> _screenRoute() {
    return config.screenInfo?.call() ??
        {'route': null, 'name': null, 'previous_route': null};
  }

  String _logLevel(LogLevel? level) => switch (level) {
    LogLevel.verbose => 'debug',
    LogLevel.debug => 'debug',
    LogLevel.info => 'info',
    LogLevel.warning => 'warning',
    LogLevel.error => 'error',
    LogLevel.critical => 'fatal',
    null => 'info',
  };

  Future<void> setScreenshot(XFile? pickedFile) async {
    await _deleteCompressedScreenshot();

    if (pickedFile == null) {
      screenshotPath = null;
      notifyListeners();
      return;
    }

    final targetPath = path.join(
      path.dirname(pickedFile.path),
      'bug_report_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    XFile? compressed;
    try {
      compressed = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        targetPath,
        minWidth: 1920,
        minHeight: 1080,
        quality: 90,
        format: CompressFormat.jpeg,
      );
    } catch (_) {
      compressed = null;
    }

    final compressedFile = compressed == null ? null : File(compressed.path);
    final resultFile = compressed ?? pickedFile;

    if (await resultFile.length() > _maxScreenshotBytes) {
      if (compressedFile != null && await compressedFile.exists()) {
        await compressedFile.delete();
      }

      screenshotPath = null;
      _compressedScreenshot = null;
      notifyListeners();

      config.bannerController.show(
        message: 'Файл не может весить больше 10 МБ',
      );

      return;
    }

    screenshotPath = resultFile.path;
    _compressedScreenshot = compressedFile;
    notifyListeners();
  }

  Future<void> _deleteCompressedScreenshot() async {
    final file = _compressedScreenshot;
    _compressedScreenshot = null;

    if (file != null && await file.exists()) {
      await file.delete();
    }
  }

  bool get isValid => descriptionController.text.trim().isNotEmpty;

  Future<void> submit() async {
    if (isSubmitting) return;
    isSubmitting = true;
    submitError = null;
    notifyListeners();
    try {
      final payload = {
        'description': descriptionController.text.trim(),
        'mpid': _mpid,
        'occurred_at': _occurredAt,
        'app': _app,
        'device': await _device(),
        'connection': await _connection(),
        'console_logs': _consoleLogs(),
        'recent_requests': _recentRequests(),
        'screen': _screenRoute(),
      };

      final isSent = await _repository.sendBugReport(
        payload: payload,
        screenshotPath: screenshotPath,
      );

      if (!isSent) {
        submitError = 'Не удалось отправить форму о проблеме';
      }
      isSubmitSuccess = isSent;
    } on AppException catch (e) {
      submitError = e.message;
      isSubmitSuccess = false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _deleteCompressedScreenshot();
    descriptionController.dispose();
    super.dispose();
  }
}
