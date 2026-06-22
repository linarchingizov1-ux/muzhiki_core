import 'dart:async';

import 'package:muzhiki_core/muzhiki_core.dart';
import 'package:vpn_detector/vpn_detector.dart';

class AppVpnDetector {
  final VpnDetector _detector = VpnDetector();
  StreamSubscription<VpnStatus>? _sub;

  void init() {
    _sub?.cancel();

    _sub = _detector.onVpnStatusChanged.listen((status) {
      if (status != VpnStatus.active) return;

      MuzhikiCore.I.banner.show(
        message:
            'Активно VPN соединение, некоторые функции могут быть недоступны',
      );
    });
  }

  void dispose() {
    _sub?.cancel();
  }
}
