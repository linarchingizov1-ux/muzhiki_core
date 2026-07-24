import 'dart:async';

class RefreshManager {
  Completer<void>? _completer;

  bool get isRefreshing => _completer != null;

  Future<void> waitIfRefreshing() async {
    final completer = _completer;
    if (completer != null) {
      await completer.future;
    }
  }

  void start() {
    _completer ??= Completer<void>();
  }

  void success() {
    _completer?.complete();
    _completer = null;
  }

  void error(Object error, StackTrace stackTrace) {
    _completer?.completeError(error, stackTrace);
    _completer = null;
  }
}
