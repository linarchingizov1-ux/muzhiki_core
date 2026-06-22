import 'package:fresh_dio/fresh_dio.dart';
import 'package:muzhiki_core/dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/dependecies/network/utils/network_status_controller.dart';
import 'package:muzhiki_core/dependecies/network/utils/network_vnp_detector.dart';

class NetworkModel {
  final Dio authDio;
  final Dio refreshDio;
  final Fresh<String> fresh;
  final NetworkMapErrorApp mapper;
  final NetworkStatusController networkStatusController;
  final AppVpnDetector vpnDetector;

  const NetworkModel({
    required this.vpnDetector,
    required this.mapper,
    required this.networkStatusController,
    required this.authDio,
    required this.refreshDio,
    required this.fresh,
  });
}
