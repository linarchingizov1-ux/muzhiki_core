import 'dart:async';

import 'package:muzhiki_bridge/data/model/bridge_session.dart';
import 'package:muzhiki_bridge/domain/repository/bridge_auth_repository.dart';
import 'package:muzhiki_dependencies/service/session/session.dart';

class BridgeAuthRepositoryImpl implements BridgeAuthRepository {
  BridgeAuthRepositoryImpl(this.session);
  BridgeSession? _session;

  final SessionApp session;

  final StreamController<BridgeSession> _updates =
      StreamController<BridgeSession>.broadcast();

  @override
  Stream<BridgeSession> get sessionUpdates => _updates.stream;

  Future<String?> _readAccessToken({int retries = 5}) async {
    await session.ready;

    for (var attempt = 0; attempt < retries; attempt++) {
      final token = await session.accessToken;
      if (token != null && token.isNotEmpty) return token;
      if (attempt == retries - 1) break;
      await Future<void>.delayed(const Duration(milliseconds: 120));
    }

    return null;
  }

  BridgeSession _buildSession(String token) {
    return BridgeSession(
      accessToken: token,
      expiresAt: DateTime.now()
          .add(const Duration(hours: 1))
          .millisecondsSinceEpoch,
      user: {'id': session.user?.mpid, 'name': session.user?.username},
    );
  }

  @override
  Future<void> seedSession() async {
    final token = await _readAccessToken();
    if (token == null) return;

    _session = _buildSession(token);

    if (!_updates.isClosed) {
      _updates.add(_session!);
    }
  }

  @override
  Future<BridgeSession?> getCurrentSession() async {
    return _session;
  }

  @override
  Future<BridgeSession> refresh() async {
    final token = await _readAccessToken();
    if (token == null) {
      throw Exception('Отсутствует сессия пользователя');
    }

    final updated = _buildSession(token);
    _session = updated;

    if (!_updates.isClosed) {
      _updates.add(updated);
    }

    return updated;
  }

  @override
  Future<void> logout() async {
    _session = null;
  }

  @override
  void dispose() {
    if (!_updates.isClosed) {
      _updates.close();
    }
  }
}
