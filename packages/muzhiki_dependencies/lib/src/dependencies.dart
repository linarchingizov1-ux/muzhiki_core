import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:muzhiki_dependencies/model/dependencies_model.dart';
import 'package:muzhiki_dependencies/model/service_model.dart';
import 'package:muzhiki_dependencies/model/storage_model.dart';
import 'package:muzhiki_dependencies/network/exception/network_map_error.dart';
import 'package:muzhiki_dependencies/network/network_factory.dart';
import 'package:muzhiki_dependencies/network/network_type_service.dart';
import 'package:muzhiki_dependencies/network/token_storage.dart';
import 'package:muzhiki_dependencies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_dependencies/service/app_version/app_version.dart';
import 'package:muzhiki_dependencies/service/session/session.dart';
import 'package:muzhiki_dependencies/service/session/user_session.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:screen_corner_radius/screen_corner_radius.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

class MuzhikiDependencies {
  MuzhikiDependencies._();
  static final I = MuzhikiDependencies._();
  final _rootKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get routerKey => _rootKey;
  ScreenRadius? divesRadius;
  late bool _isUninstalling;

  Future<DependenciesModel> init({
    bool enableTalker = true,
    bool getRoles = false,
    bool showReqHeaders = false,
    required bool needMetricsHttp,
    required bool showTalkerMetricsHttp,
    required TypeApp typeApp,
  }) async {
    final sw = Stopwatch()..start();
    final talker = Talker();

    final directory = await Future.microtask(
      () => getApplicationDocumentsDirectory(),
    );
    final sharedPreferences = await Future.microtask(
      () => SharedPreferences.getInstance(),
    );
    final secureStorage = const FlutterSecureStorage();
    _isUninstalling =
        sharedPreferences.getBool('${typeApp.nameApp}-isUninstalling') ?? true;

    final tokenStorage = SecureTokenStorage(secureStorage);
    final hiveStore = HiveCacheStore(directory.path);

    final mapper = AppErrorMapper.I;
    final pathCoockies = path.join(directory.path, '.cookies');

    final cookie = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(pathCoockies),
    );
    await InternetCheckNotifier.I.init();

    final infoProject = await AppInfoService.I.info;
    final UserSession userSession = UserSession(sharedPreferences);
    final network = await NetworkFactory.create(
      showTalkerMetricsHttp: showTalkerMetricsHttp,
      userSession: userSession,
      typeApp: typeApp,
      infoProject: infoProject,
      sharedPreferences: sharedPreferences,
      needMetricsHttp: needMetricsHttp,
      showReqHeaders: showReqHeaders,
      cookieJar: cookie,
      enableTalker: enableTalker,
      talker: talker,
      store: hiveStore,
      tokenStorage: tokenStorage,
    );
    final session = SessionApp(
      tokenStorage: tokenStorage,
      typeApp: typeApp,
      getRoles: getRoles,
      userSession: userSession,
      dioRefresh: network.refreshDio,
      dio: network.authDio,
      sharedPreferences: sharedPreferences,
      fresh: network.fresh,
      cookieJar: cookie,
      hiveStore: hiveStore,
    );
    divesRadius = await ScreenCornerRadius.get();
    MuzhikiUi.dialog.configure(
      navigatorKey: routerKey,
      bottomSheetBottomRadius: () => divesRadius?.bottomLeft ?? 32,
    );

    await session.init();
    if (_isUninstalling) {
      await sharedPreferences.clear();

      session.cleareSession();

      await sharedPreferences.setBool(
        '${typeApp.nameApp}-isUninstalling',
        false,
      );
    }

    final serviceModel = ServiceModel(
      session: session,
      talker: talker,
      bannerController: BannerController.I,
    );
    final storageModel = StorageModel(
      sharedPreferences: sharedPreferences,
      secure: secureStorage,
      token: tokenStorage,
      directory: directory,
    );
    talker.info(
      'Время инициализации Muzhiki Core INIT: ${sw.elapsedMilliseconds} мс',
    );
    return DependenciesModel(
      mapper: mapper,
      network: network,
      service: serviceModel,
      storage: storageModel,
    );
  }
}
