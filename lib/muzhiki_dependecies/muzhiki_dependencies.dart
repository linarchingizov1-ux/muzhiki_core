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
    required bool needMetricsHttp,
    required TypeApp typeApp,
  }) async {
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
    final talker = Talker();
    final mapper = AppErrorMapper.I;
    final pathCoockies = path.join(directory.path, '.cookies');

    final cookie = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(pathCoockies),
    );
    await InternetCheckNotifier.I.init();
    final network = await NetworkFactory.create(
      sharedPreferences: sharedPreferences,
      needMetricsHttp: needMetricsHttp,
      showReqHeaders: showReqHeaders,
      cookieJar: cookie,
      enableTalker: enableTalker,
      talker: talker,
      store: hiveStore,
      tokenStorage: tokenStorage,
    );
    final UserSession userSession = UserSession(sharedPreferences);
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

    return DependenciesModel(
      mapper: mapper,
      network: network,
      service: serviceModel,
      storage: storageModel,
    );
  }
}
