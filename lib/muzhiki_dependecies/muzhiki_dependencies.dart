import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:muzhiki_core/muzhiki_dependecies/model/dependencies_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/model/network_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/model/service_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/model/storage_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/network_factory.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/utils/network_vnp_detector.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/token_storage.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/user_session.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';
import 'package:vpn_detector/vpn_detector.dart';

class MuzhikiDependencies {
  MuzhikiDependencies._();
  static final I = MuzhikiDependencies._();
  final _rootKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get routerKey => _rootKey;

  BannerController get banner => BannerController.I;

  late bool _isUninstalling;

  Future<DependenciesModel> init({
    bool enableTalker = true,
    bool getRoles = false,
    bool vpnDetectorOn = true,
    required TypeApp typeApp,
  }) async {
    final directory = await Future.microtask(
      () => getApplicationDocumentsDirectory(),
    );
    final sharedPreferences = await Future.microtask(
      () => SharedPreferences.getInstance(),
    );
    final secureStorage = const FlutterSecureStorage();
    _isUninstalling = sharedPreferences.getBool('isUninstalling') ?? true;
    final tokenStorage = SecureStringTokenStorage(secureStorage);
    final hiveStore = HiveCacheStore(directory.path);
    final talker = Talker();
    final vpnDetector = AppVpnDetector();
    final mapper = AppErrorMapper.I;
    final cookie = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(path.join(directory.path, '.cookies')),
    );

    final network = await NetworkFactory.create(
      cookieJar: cookie,
      enableTalker: enableTalker,
      vpnDetector: vpnDetector,
      talker: talker,
      store: hiveStore,
      tokenStorage: tokenStorage,
    );
    final UserSession userSession = UserSession(sharedPreferences);
    final session = SessionApp(
      typeApp: typeApp,
      userSession: userSession,
      dioRefresh: network.refreshDio,
      dio: network.authDio,
      sharedPreferences: sharedPreferences,
      fresh: network.fresh,
      cookieJar: cookie,
      hiveStore: hiveStore,
    );
    await session.init();
    if (_isUninstalling) {
      await sharedPreferences.clear();
      session.cleareSession();
      await sharedPreferences.setBool('isUninstalling', false);
    }

    final serviceModel = ServiceModel(
      session: session,
      talker: talker,
      bannerController: BannerController.I,
    );
    if (vpnDetectorOn) {
      vpnDetector.stream.listen((status) {
        if (status == VpnStatus.active) {
          BannerController.I.show(
            message:
                "Активно VPN соединение.\nНекоторые функции могут быть недоступны",
          );
        }
      });
    }
    final networkModel = NetworkModel(
      vpnDetector: network.vpnDetector,
      networkStatusController: network.networkStatusController,
      authDio: network.authDio,
      refreshDio: network.refreshDio,
      fresh: network.fresh,
    );
    final storageModel = StorageModel(
      sharedPreferences: sharedPreferences,
      secure: secureStorage,
      token: tokenStorage,
      directory: directory,
    );

    return DependenciesModel(
      mapper: mapper,
      network: networkModel,
      service: serviceModel,
      storage: storageModel,
    );
  }
}
