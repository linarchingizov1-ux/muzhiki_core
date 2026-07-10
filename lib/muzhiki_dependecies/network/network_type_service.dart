import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/extension/type_network_extension.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_enum.dart';
import 'package:vpn_detector/vpn_detector.dart';

class NetworkConnectivityService {
  final Connectivity _connectivity;

  RequestNetwork _currentType = RequestNetwork.none;

  RequestNetwork get currentType => _currentType;

  StreamSubscription? _subscription;

  NetworkConnectivityService(this._connectivity);

  Future<void> init() async {
    final result = await _connectivity.checkConnectivity();

    _updateConnection(result);

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _currentType = result.first.toRequestNetwork;
    });
  }

  void _updateConnection(List<ConnectivityResult> result) {
    if (result.isEmpty) {
      _currentType = RequestNetwork.none;
      return;
    }

    _currentType = result.first.toRequestNetwork;
  }

  void dispose() {
    _subscription?.cancel();
  }
}

class InternetCheckNotifier extends ChangeNotifier {
  InternetCheckNotifier();

  static final I = InternetCheckNotifier();

  final VpnDetector _vpnDetector = VpnDetector();
  StreamSubscription<VpnStatus>? _vpnSub;

  bool _isVpnEnabled = false;

  bool get isVpnEnabled => _isVpnEnabled;

  Future<void> init() async {
    _vpnSub = _vpnDetector.onVpnStatusChanged.listen(
      (status) {
        final isEnabled = status == VpnStatus.active;
        if (_isVpnEnabled != isEnabled) {
          _isVpnEnabled = isEnabled;
          notifyListeners();
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (_isVpnEnabled) {
          _isVpnEnabled = false;
          notifyListeners();
        }
      },
    );
  }

  @override
  void dispose() {
    _vpnSub?.cancel();
    super.dispose();
  }
}
