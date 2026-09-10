import 'dart:async';

import 'package:muzhiki_dependencies/service/session/session.dart';

class BridgeSession {
  const BridgeSession({
    required this.accessToken,
    required this.expiresAt,
    required this.user,
  });

  final String accessToken;
  final int expiresAt;
  final Map<String, dynamic>? user;
}

class BridgeAuth {
  BridgeAuth(this._app);

  final SessionApp _app;
  BridgeSession? _session;
  final _updates = StreamController<BridgeSession>.broadcast();

  Stream<BridgeSession> get sessionUpdates => _updates.stream;

  Future<String?> _readAccessToken({int retries = 5}) async {
    await _app.ready;
    for (var i = 0; i < retries; i++) {
      final token = await _app.accessToken;
      if (token != null && token.isNotEmpty) return token;
      if (i < retries - 1) {
        await Future<void>.delayed(const Duration(milliseconds: 550));
      }
    }
    return null;
  }

  BridgeSession _build(String token) => BridgeSession(
    accessToken: token,
    expiresAt: DateTime.now()
        .add(const Duration(hours: 1))
        .millisecondsSinceEpoch,
    user: {'id': _app.user?.mpid, 'name': _app.user?.username},
  );

  void _set(BridgeSession session) {
    _session = session;
    if (!_updates.isClosed) _updates.add(session);
  }

  Future<void> seedSession() async {
    final token = await _readAccessToken();
    if (token != null) _set(_build(token));
  }

  Future<BridgeSession?> ensureSession() async {
    if (_session == null || _session!.accessToken.isEmpty) {
      await seedSession();
    }
    final session = _session;
    if (session == null || session.accessToken.isEmpty) return null;
    return session;
  }

  Future<BridgeSession> refresh() async {
    final token = await _readAccessToken();
    if (token == null) throw Exception('Отсутствует сессия пользователя');
    final updated = _build(token);
    _set(updated);
    return updated;
  }

  void logout() => _session = null;

  void dispose() {
    if (!_updates.isClosed) _updates.close();
  }
}
