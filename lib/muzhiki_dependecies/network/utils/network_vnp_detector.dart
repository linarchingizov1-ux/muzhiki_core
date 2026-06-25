import 'dart:async';
import 'package:vpn_detector/vpn_detector.dart';

class AppVpnDetector {
  final VpnDetector _detector = VpnDetector();

  Stream<VpnStatus> get stream => _detector.onVpnStatusChanged;
}
