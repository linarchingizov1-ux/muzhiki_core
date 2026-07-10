import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_enum.dart';

extension ConnectivityResultMapper on ConnectivityResult {
  RequestNetwork get toRequestNetwork {
    switch (this) {
      case ConnectivityResult.wifi:
        return RequestNetwork.wifi;

      case ConnectivityResult.ethernet:
        return RequestNetwork.ethernet;

      case ConnectivityResult.mobile:
        return RequestNetwork.cellular;

      case ConnectivityResult.none:
        return RequestNetwork.none;

      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
      case ConnectivityResult.satellite:
      case ConnectivityResult.other:
        return RequestNetwork.unknown;
    }
  }
}
