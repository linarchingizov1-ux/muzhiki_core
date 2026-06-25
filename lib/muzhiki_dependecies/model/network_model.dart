import 'package:fresh_dio/fresh_dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/utils/network_status_controller.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/utils/network_vnp_detector.dart';

class NetworkModel {
  final Dio authDio;
  final Dio refreshDio;
  final Fresh<String> fresh;
  final NetworkStatusController networkStatusController;
  final AppVpnDetector vpnDetector;

  const NetworkModel({
    required this.vpnDetector,
    required this.networkStatusController,
    required this.authDio,
    required this.refreshDio,
    required this.fresh,
  });
}
