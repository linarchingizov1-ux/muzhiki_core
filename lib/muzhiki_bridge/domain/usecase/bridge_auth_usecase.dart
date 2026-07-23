import 'package:muzhiki_core/muzhiki_bridge/data/model/bridge_session.dart';
import 'package:muzhiki_core/muzhiki_bridge/domain/repository/bridge_auth_repository.dart';

class BridgeAuthUsecase {
  final BridgeAuthRepository repository;
  BridgeAuthUsecase({required this.repository});

  Future<BridgeSession?> getCurrentSession() async =>
      await repository.getCurrentSession();

  Future<BridgeSession> refresh() async => await repository.refresh();

  Future<void> logout() async => await repository.logout();

  Stream<BridgeSession> get sessionUpdates => repository.sessionUpdates;

  void dispose() => repository.dispose();

  Future<void> seedSession() => repository.seedSession();
}
