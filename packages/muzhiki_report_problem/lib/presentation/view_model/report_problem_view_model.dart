import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:muzhiki_report_problem/config/report_problem_config.dart';
import 'package:muzhiki_report_problem/domain/queue/manager/queue_manager.dart';
import 'package:path/path.dart' as path;

class ReportProblemViewModel extends ChangeNotifier {
  ReportProblemViewModel({required this.config, required this.queueManager}) {
    descriptionController.addListener(notifyListeners);
  }
  final QueueManager queueManager;
  final ReportProblemConfig config;

  bool isSubmitting = false;
  bool? isSubmitSuccess;
  String? submitError;

  final descriptionController = TextEditingController();

  File? _compressedScreenshot;

  String? screenshotPath;

  static const _maxScreenshotBytes = 10 * 1024 * 1024;

  int? get _mpid => int.tryParse(config.mpid ?? '');

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
      'device_id': config.appInfo.deviceId,
      'manufacturer': config.appInfo.manufacturer,
      'model': config.appInfo.model,
      'screen_width': view.physicalSize.width.round(),
      'screen_height': view.physicalSize.height.round(),
      'locale': PlatformDispatcher.instance.locale.toLanguageTag(),
      'timezone': timezone?.identifier ?? DateTime.now().timeZoneName,
    };
  }

  Future<Map<String, dynamic>> _connection() async {
    final type = config.resolvedNetworkType;
    final details = await config.connectionDetails?.call(type) ?? const {};

    return {'type': type, 'is_online': type != 'none', ...details};
  }

  List<Map<String, dynamic>> _consoleLogs() {
    final items = config.resolvedConsoleLogs;
    return items.map((item) {
      final result = Map<String, dynamic>.from(item);
      final message = result['message'];
      if (message is String) {
        final sanitized = _sanitizeLog(message);
        result['message'] = sanitized.length > 10000
            ? sanitized.substring(0, 10000)
            : sanitized;
      }
      return result;
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
    final items = config.resolvedRecentRequests;
    return items.length > 10 ? items.sublist(items.length - 10) : items;
  }

  Map<String, dynamic> _screenRoute() {
    return config.screenInfo?.call() ??
        {'route': null, 'name': null, 'previous_route': null};
  }

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

      config.showMessageResolved('Файл не может весить больше 10 МБ');

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
      final payload = <String, Object?>{
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

      final sent = await queueManager.createActive(
        payload: payload,
        screenshotPath: screenshotPath,
      );

      isSubmitSuccess = sent;
      if (!sent) {
        submitError =
            'Мы добавили ее в очередь и отправим в фоне, вы можете продолжить работу';
      }
    } catch (_) {
      // Только ошибка записи на диск: отправка идёт в фоне.
      submitError = 'Не удалось сохранить форму о проблеме';
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
