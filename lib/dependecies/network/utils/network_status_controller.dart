import 'package:flutter/foundation.dart';

enum NetworkStatus { ok, offline, serverError }

class NetworkStatusController {
  NetworkStatusController._();

  static final I = NetworkStatusController._();

  final ValueNotifier<NetworkStatus> status = ValueNotifier(NetworkStatus.ok);

  bool get isOffline => status.value == NetworkStatus.offline;
  bool get isBackend => status.value == NetworkStatus.serverError;

  void setOffline() {
    status.value = NetworkStatus.offline;
  }

  void setOk() {
    status.value = NetworkStatus.ok;
  }

  void setErrorBackend() {
    status.value = NetworkStatus.serverError;
  }
}
