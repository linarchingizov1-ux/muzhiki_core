part of 'package:muzhiki_core/muzhiki_core.dart';

class MuzhikiDependencies {
  MuzhikiDependencies._();
  static final I = MuzhikiDependencies._();
  final _rootKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get routerKey => _rootKey;

  BannerController get banner => BannerController.I;
  ScreenRadius? divesRadius;
  late bool _isUninstalling;

  Future<DependenciesModel> init({
    bool enableTalker = true,
    bool getRoles = false,
    bool showReqHeaders = false,
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
    final pathCoockies = path.join(
      directory.path,
      '${typeApp.nameApp}/.cookies',
    );

    talker.debug("Папка с куками $pathCoockies");
    final cookie = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(pathCoockies),
    );
    final logCookies = await cookie.loadForRequest(
      Uri.parse('https://auth.muzhiki.pro'),
    );
    talker.debug("Куки: $logCookies");
    final network = await NetworkFactory.create(
      showReqHeaders: showReqHeaders,
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
    talker.debug('Session.init START');

    final beforeInitCookies = await cookie.loadForRequest(
      Uri.parse('https://auth.muzhiki.pro'),
    );

    talker.debug(
      'До session.init(): ${beforeInitCookies.map((e) => '${e.name}=${e.value}').toList()}',
    );

    await session.init();

    final afterInitCookies = await cookie.loadForRequest(
      Uri.parse('https://auth.muzhiki.pro'),
    );

    talker.debug(
      'После session.init(): ${afterInitCookies.map((e) => '${e.name}=${e.value}').toList()}',
    );
    if (_isUninstalling) {
      final beforeClearCookies = await cookie.loadForRequest(
        Uri.parse('https://auth.muzhiki.pro'),
      );

      talker.warning(
        'До cleareSession(): ${beforeClearCookies.map((e) => '${e.name}=${e.value}').toList()}',
      );

      await sharedPreferences.clear();

      session.cleareSession();

      final afterClearCookies = await cookie.loadForRequest(
        Uri.parse('https://auth.muzhiki.pro'),
      );

      talker.warning(
        'После cleareSession(): ${afterClearCookies.map((e) => '${e.name}=${e.value}').toList()}',
      );

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
