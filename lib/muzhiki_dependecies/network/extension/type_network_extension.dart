import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_enum.dart';

extension ConnectivityResultMapper on ConnectivityResult {
  RequestNetwork get toRequestNetwork {
    switch (this) {
      case ConnectivityResult.wifi:
        return RequestNetwork.wifi;

      case ConnectivityResult.mobile:
        return RequestNetwork.cellular;

      case ConnectivityResult.ethernet:
        return RequestNetwork.ethernet;

      case ConnectivityResult.bluetooth:
        return RequestNetwork.bluetooth;

      case ConnectivityResult.vpn:
        return RequestNetwork.vpn;

      case ConnectivityResult.satellite:
        return RequestNetwork.satellite;

      case ConnectivityResult.other:
        return RequestNetwork.other;

      case ConnectivityResult.none:
        return RequestNetwork.none;
    }
  }
}
