import 'dart:async';

class RefreshManager {
  Completer<void>? _completer;

  bool get isRefreshing => _completer != null;

  Future<void> waitIfRefreshing() {
    return _completer?.future ?? Future.value();
  }

  void start() {
    _completer ??= Completer<void>();
  }

  void finish({Object? error, StackTrace? stackTrace}) {
    final completer = _completer;
    if (completer == null) return;

    _completer = null;

    if (completer.isCompleted) return;

    if (error != null) {
      completer.completeError(error, stackTrace ?? StackTrace.current);
    } else {
      completer.complete();
    }
  }
}
