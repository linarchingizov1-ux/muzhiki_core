import 'package:fresh_dio/fresh_dio.dart';
import 'package:muzhiki_dependencies/network/metrics/request_storage.dart';
import 'package:muzhiki_dependencies/network/token_storage.dart';
import 'package:muzhiki_dependencies/network/url_launch/url_launch.dart';

class NetworkModel {
  final Dio authDio;
  final MuzhikiUrlLaunch uriLauncer;
  final Dio refreshDio;
  final Fresh<AuthTokens> fresh;
  final RequestStorage requestStorage;

  const NetworkModel({
    required this.requestStorage,
    required this.uriLauncer,
    required this.authDio,
    required this.refreshDio,
    required this.fresh,
  });
}
