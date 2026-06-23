import 'package:muzhiki_core/app/bridge/data/model/bridge_session.dart';
import 'package:muzhiki_core/app/bridge/domain/repository/bridge_auth_repository.dart';

class BridgeAuthUsecase {
  final BridgeAuthRepository repository;
  BridgeAuthUsecase({required this.repository});

  Future<BridgeSession?> getCurrentSession() async =>
      await repository.getCurrentSession();

  Future<BridgeSession> refresh() async => await repository.refresh();

  Future<void> logout() async => await repository.logout();

  Stream<BridgeSession> get sessionUpdates => repository.sessionUpdates;

  void dispose() => repository.dispose();

  void seedSession() => repository.seedSession();
}
