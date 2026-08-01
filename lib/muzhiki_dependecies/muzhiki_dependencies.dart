part of 'package:muzhiki_core/muzhiki_core.dart';

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
    talker.debug('Создали Talker: ${sw.elapsedMilliseconds}ms');

    final directory = await Future.microtask(
      () => getApplicationDocumentsDirectory(),
    );
    talker.debug('Взяли директорию: ${sw.elapsedMilliseconds}ms');
    final sharedPreferences = await Future.microtask(
      () => SharedPreferences.getInstance(),
    );
    talker.debug('Взяли SharedPreferences: ${sw.elapsedMilliseconds}ms');
    final secureStorage = const FlutterSecureStorage();
    _isUninstalling =
        sharedPreferences.getBool('${typeApp.nameApp}-isUninstalling') ?? true;
    talker.debug('Проверили статус удаления: ${sw.elapsedMilliseconds}ms');

    final tokenStorage = SecureTokenStorage(secureStorage);
    final hiveStore = HiveCacheStore(directory.path);

    final mapper = AppErrorMapper.I;
    final pathCoockies = path.join(directory.path, '.cookies');

    final cookie = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(pathCoockies),
    );
    talker.debug('Создали CookieJar: ${sw.elapsedMilliseconds}ms');
    await InternetCheckNotifier.I.init();
    talker.debug(
      'Инициализировали InternetCheckNotifier: ${sw.elapsedMilliseconds}ms',
    );
    final infoProject = await AppInfoService.I.info;
    talker.debug('Получили информацию о проекте: ${sw.elapsedMilliseconds}ms');
    final UserSession userSession = UserSession(sharedPreferences);
    talker.debug('Создали UserSession: ${sw.elapsedMilliseconds}ms');
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
    talker.debug('Создали Network: ${sw.elapsedMilliseconds}ms');
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
    talker.debug('Создали Session: ${sw.elapsedMilliseconds}ms');
    divesRadius = await ScreenCornerRadius.get();
    talker.debug(
      'Получили радиус скругления экрана: ${sw.elapsedMilliseconds}ms',
    );
    await session.init();
    talker.debug('Инициализировали Session: ${sw.elapsedMilliseconds}ms');
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
