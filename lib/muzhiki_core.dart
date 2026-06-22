import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:muzhiki_core/dependecies/model/dependencies_model.dart';
import 'package:muzhiki_core/dependecies/model/network_model.dart';
import 'package:muzhiki_core/dependecies/model/service_model.dart';
import 'package:muzhiki_core/dependecies/model/storage_model.dart';
import 'package:muzhiki_core/dependecies/network/network_factory.dart';
import 'package:muzhiki_core/dependecies/network/utils/network_vnp_detector.dart';
import 'package:muzhiki_core/dependecies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_core/dependecies/service/session/session.dart';
import 'package:muzhiki_core/dependecies/service/session/token_storage.dart';
import 'package:muzhiki_core/dependecies/service/session/user_session.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

class MuzhikiCore {
  MuzhikiCore._();
  static final I = MuzhikiCore._();
  final _rootKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get routerKey => _rootKey;

  BannerController get banner => BannerController.I;

  bool? _isUninstalling;

  bool get isUninstalling => _isUninstalling ?? true;

  Future<DependenciesModel> init({
    VoidCallback? onSessionResumed,
    bool getRoles = false,
  }) async {
    final directory = await Future.microtask(
      () => getApplicationDocumentsDirectory(),
    );
    final cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(path.join(directory.path, ".cookies")),
    );
    final sharedPreferences = await Future.microtask(
      () => SharedPreferences.getInstance(),
    );
    final secureStorage = const FlutterSecureStorage();
    _isUninstalling = sharedPreferences.getBool('isUninstalling');
    final tokenStorage = SecureStringTokenStorage(secureStorage);
    final hiveStore = HiveCacheStore(directory.path);
    final talker = Talker();
    final vpnDetector = AppVpnDetector();
    vpnDetector.init();
    final network = await NetworkFactory.create(
      vpnDetector: vpnDetector,
      talker: talker,
      store: hiveStore,
      tokenStorage: tokenStorage,
    );
    final UserSession userSession = UserSession(sharedPreferences);
    final session = SessionApp(
      onSessionResumed: onSessionResumed,
      userSession: userSession,
      dioRefresh: network.refreshDio,
      dio: network.authDio,
      sharedPreferences: sharedPreferences,
      fresh: network.fresh,
      cookieJar: cookieJar,
      hiveStore: hiveStore,
    );
    final serviceModel = ServiceModel(
      session: session,
      talker: talker,
      bannerController: BannerController.I,
    );
    final networkModel = NetworkModel(
      mapper: network.mapper,
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
      network: networkModel,
      service: serviceModel,
      storage: storageModel,
    );
  }
}
