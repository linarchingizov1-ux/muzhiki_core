import 'dart:async';

import 'package:talker/talker.dart';

class RefreshManager {
  RefreshManager({required this.talker});

  final Talker talker;

  Completer<void>? _completer;
  int _waitingRequests = 0;

  bool get isRefreshing => _completer != null;

  Future<void> waitIfRefreshing() async {
    final completer = _completer;
    if (completer == null) return;

    _waitingRequests++;

    talker.debug('[RefreshManager] ⏳ Ждет refresh ($_waitingRequests)');

    try {
      await completer.future;
    } finally {
      _waitingRequests--;
    }
  }

  void start() {
    if (_completer != null) {
      talker.debug('[RefreshManager] Refresh уже выполняется');
      return;
    }

    talker.debug('[RefreshManager] 🚀 Refresh started');

    _completer = Completer<void>();
  }

  void finish({Object? error, StackTrace? stackTrace}) {
    final completer = _completer;
    if (completer == null) {
      talker.warning(
        '[RefreshManager] finish() вызван, но refresh уже завершён',
      );
      return;
    }

    _completer = null;

    if (completer.isCompleted) {
      talker.warning('[RefreshManager] Completer уже завершён');
      return;
    }

    if (error != null) {
      talker.error('[RefreshManager] ❌ Refresh failed', error, stackTrace);

      completer.completeError(error, stackTrace ?? StackTrace.current);
    } else {
      talker.debug('[RefreshManager] ✅ Refresh success');

      completer.complete();
    }
  }
}
