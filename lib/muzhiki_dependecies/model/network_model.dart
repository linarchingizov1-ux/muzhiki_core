import 'package:fresh_dio/fresh_dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/url_launch/url_launch.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/utils/network_status_controller.dart';

class NetworkModel {
  final Dio authDio;
  final MuzhikiUrlLaunch uriLauncer;
  final Dio refreshDio;
  final Fresh<String> fresh;
  final NetworkStatusController networkStatusController;

  const NetworkModel({
    required this.uriLauncer,
    required this.networkStatusController,
    required this.authDio,
    required this.refreshDio,
    required this.fresh,
  });
}
