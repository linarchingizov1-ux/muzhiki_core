import 'package:muzhiki_core/app/bridge/data/model/bridge_session.dart';

abstract class BridgeAuthRepository {
  Future<BridgeSession?> getCurrentSession();

  Future<BridgeSession> refresh();

  Future<void> logout();

  Stream<BridgeSession> get sessionUpdates;

  void dispose();

  void seedSession();
}
