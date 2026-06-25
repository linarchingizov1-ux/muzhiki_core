import 'dart:async';

import 'package:muzhiki_core/muzhiki_bridge/data/model/bridge_session.dart';
import 'package:muzhiki_core/muzhiki_bridge/domain/repository/bridge_auth_repository.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';

class BridgeAuthRepositoryImpl implements BridgeAuthRepository {
  BridgeAuthRepositoryImpl(this.session);
  BridgeSession? _session;

  final SessionApp session;

  final StreamController<BridgeSession> _updates =
      StreamController<BridgeSession>.broadcast();

  @override
  Stream<BridgeSession> get sessionUpdates => _updates.stream;

  @override
  Future<void> seedSession() async {
    final token = await session.token ?? '';

    _session = BridgeSession(
      accessToken: token,
      expiresAt: DateTime.now()
          .add(const Duration(hours: 1))
          .millisecondsSinceEpoch,
      user: {'id': session.user?.mpid, 'name': session.user?.username},
    );

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
    final current = _session;

    if (current == null) {
      throw Exception('Отсутствует сессия пользователя');
    }

    final updated = current.copyWith(
      expiresAt: DateTime.now()
          .add(const Duration(hours: 1))
          .millisecondsSinceEpoch,
    );

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
