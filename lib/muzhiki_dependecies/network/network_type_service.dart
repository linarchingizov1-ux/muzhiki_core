import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/extension/type_network_extension.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_enum.dart';

class NetworkConnectivityService {
  final Connectivity _connectivity;

  RequestNetwork _currentType = RequestNetwork.none;

  RequestNetwork get currentType => _currentType;

  StreamSubscription? _subscription;

  NetworkConnectivityService(this._connectivity);

  Future<void> init() async {
    final result = await _connectivity.checkConnectivity();

    _currentType = result.first.toRequestNetwork;

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _currentType = result.first.toRequestNetwork;
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
