import 'dart:io';
import 'package:muzhiki_report_problem/data/repository/report_problem_repository_impl.dart';
import 'package:muzhiki_report_problem/domain/queue/model/problem_queue.dart';
import 'package:muzhiki_report_problem/domain/repository/report_problem_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

class QueueManager {
  QueueManager({
    required this.shared,
    required this.dir,
    required this.authDio,
  });

  final SharedPreferences shared;
  final Directory dir;
  late ReportProblemRepository repository;
  final Dio authDio;

  static const String urlPing = 'https://metrics.dev.muzhiki.pro/health';
  static const int ok = 200;

  static const _storageKey = 'problem_queue';
  static const _storageTtl = Duration(days: 7);
  static const _retryDelays = [
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 15),
  ];

  /// Всё, что лежит на устройстве (в порядке создания).
  /// Источник правды для SharedPreferences.
  final Map<String, ProblemQueue> _stored = {};

  final Queue<ProblemQueue> _active = Queue();
  final Queue<ProblemQueue> _postponed = Queue();

  static const _pingInterval = Duration(seconds: 1);

  final _statusController = StreamController<bool>.broadcast();

  /// true - сервис ответил 200, false - недоступен. Эмитит только при смене статуса.
  Stream<bool> get serviceAvailable => _statusController.stream;

  bool? _lastStatus;
  Timer? _pingTimer;
  bool _pingInProgress = false;

  bool _activeRunning = false;
  bool _postponedRunning = false;

  Directory get _screenshotsDir =>
      Directory(path.join(dir.path, 'problem_screenshots'));

  /// Инициализируем коллекцию и синхронизируем с локальными данными.
  /// Вызывать один раз при старте приложения.
  Future<void> init() async {
    repository = ReportProblemRepositoryImpl(authDio);
    final threshold = DateTime.now().subtract(_storageTtl);
    final items = _readStored()..sort((a, b) => a.date.compareTo(b.date));

    for (final item in items) {
      if (item.date.isBefore(threshold)) {
        await _deleteScreenshot(item);
        continue;
      }
      _stored[item.id] = item;
      _postponed.add(item);
    }

    await _persist();
    unawaited(_drainPostponed());
  }

  /// Сохранение в очередь [active].
  Future<void> createActive({
    required Map<String, Object?> payload,
    String? screenshotPath,
  }) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();

    // Копируем скриншот в постоянное хранилище: ViewModel удалит свой файл в dispose.
    final storedScreenshot = await _copyScreenshot(id, screenshotPath);

    final item = ProblemQueue(
      id: id,
      date: DateTime.now(),
      payload: payload,
      screenshotPath: storedScreenshot,
    );

    _stored[id] = item;
    await _persist();

    _active.add(item);
    unawaited(_drainActive());
  }

  /// Текущая коллекция проблем.
  List<ProblemQueue> getQueue() => List.unmodifiable(_stored.values);

  /// Вызвать при появлении сети (см. ниже).
  void retryPostponed() => unawaited(_drainPostponed());

  // ---------------------------------------------------------------- active

  Future<void> _drainActive() async {
    if (_activeRunning) return;
    _activeRunning = true;
    try {
      while (_active.isNotEmpty) {
        final item = _active.removeFirst();
        if (await _send(item)) {
          await _remove(item);
        } else {
          _createPostponed(item);
        }
      }
    } finally {
      _activeRunning = false;
    }
    unawaited(_drainPostponed());
  }

  // -------------------------------------------------------------- postponed

  void _createPostponed(ProblemQueue item) => _postponed.add(item);

  Future<void> _drainPostponed() async {
    if (_postponedRunning) return;
    _postponedRunning = true;
    try {
      while (_postponed.isNotEmpty) {
        final item = _postponed.first;
        var sent = false;

        for (final delay in _retryDelays) {
          if (!await _isOnline()) {
            _startPingPolling(); // проверяем раз в 60 с, пока не ответит 200
            return; // элемент остаётся в очереди, попытки не потрачены
          }
          _stopPingPolling();

          await Future<void>.delayed(delay);

          if (await _send(item)) {
            sent = true;
            break;
          }
        }

        _postponed.removeFirst();
        // После 3 неудач запись остаётся на устройстве до следующего запуска.
        if (sent) await _remove(item);
      }
    } finally {
      _postponedRunning = false;
    }
  }

  // ---------------------------------------------------------------- network

  Future<bool> _send(ProblemQueue item) async {
    try {
      final screenshot = item.screenshotPath;
      final hasScreenshot =
          screenshot != null && await File(screenshot).exists();

      return await repository.sendBugReport(
        payload: item.payload,
        screenshotPath: hasScreenshot ? screenshot : null,
      );
    } catch (_) {
      return false;
    }
  }

  Future<bool> _isOnline() async {
    var available = false;
    try {
      final response = await authDio
          .get<void>(
            urlPing,
            options: Options(
              sendTimeout: const Duration(seconds: 3),
              receiveTimeout: const Duration(seconds: 3),
              validateStatus: (_) => true,
            ),
          )
          .timeout(const Duration(seconds: 5));
      available = response.statusCode == ok;
    } catch (_) {
      available = false;
    }

    _emitStatus(available);
    return available;
  }

  void _emitStatus(bool available) {
    if (_lastStatus == available || _statusController.isClosed) return;
    _lastStatus = available;
    _statusController.add(available);
  }
  // ---------------------------------------------------------------- storage

  List<ProblemQueue> _readStored() {
    final raw = shared.getStringList(_storageKey) ?? const <String>[];
    final result = <ProblemQueue>[];
    for (final json in raw) {
      try {
        result.add(
          ProblemQueue.fromJson(jsonDecode(json) as Map<String, dynamic>),
        );
      } catch (_) {
        // Битая запись - пропускаем, при следующем _persist она исчезнет.
      }
    }
    return result;
  }

  Future<void> _persist() => shared.setStringList(
    _storageKey,
    _stored.values.map((e) => jsonEncode(e.toJson())).toList(),
  );

  Future<void> _remove(ProblemQueue item) async {
    _stored.remove(item.id);
    await _deleteScreenshot(item);
    await _persist();
  }

  Future<String?> _copyScreenshot(String id, String? sourcePath) async {
    if (sourcePath == null) return null;
    final source = File(sourcePath);
    if (!await source.exists()) return null;

    final target = _screenshotsDir;
    if (!await target.exists()) await target.create(recursive: true);

    final copyPath = path.join(target.path, '$id.jpg');
    await source.copy(copyPath);
    return copyPath;
  }

  Future<void> _deleteScreenshot(ProblemQueue item) async {
    final screenshot = item.screenshotPath;
    if (screenshot == null) return;
    final file = File(screenshot);
    if (await file.exists()) await file.delete();
  }

  void _startPingPolling() {
    if (_pingTimer != null) return;

    _pingTimer = Timer.periodic(_pingInterval, (_) async {
      if (_pingInProgress) return; // не накладываем проверки друг на друга
      _pingInProgress = true;
      try {
        if (await _isOnline()) {
          _stopPingPolling();
          unawaited(_drainPostponed());
        }
      } finally {
        _pingInProgress = false;
      }
    });
  }

  void _stopPingPolling() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  Future<void> dispose() async {
    _stopPingPolling();
    await _statusController.close();
  }
}
