class AppAssets {
  AppAssets._();
  static final I = AppAssets._();

  final svg = AppAssetsSvg.I;
  final png = AppAssetsPng.I;
}

class AppAssetsPng {
  const AppAssetsPng._();
  static final I = const AppAssetsPng._();

  final backgroundNotWorking = 'assets/image/background_not_working.png';
  final authBackground = 'assets/image/logo_background.png';
  final starEnable = 'assets/image/star_e.png';
  final starDisable = 'assets/image/star_dis.png';
  final authLogo = 'assets/image/logo.png';
  final informatorBackground = 'assets/image/informator_background.png';
}

class AppAssetsSvg {
  const AppAssetsSvg._();

  static final I = const AppAssetsSvg._();
  final logout = 'assets/icon/logout.svg';
  final dashboard = 'assets/icon/dashboard.svg';
  final arrowBack = 'assets/icon/arrow_back.svg';
  final info = 'assets/icon/info.svg';
  final doc = 'assets/icon/doc.svg';
  final close = 'assets/icon/close.svg';
  final recodeVideo = 'assets/icon/recorde_video.svg';
  final file = 'assets/icon/file.svg';
  final image = 'assets/icon/image.svg';
  final screpka = 'assets/icon/screpka.svg';
  final speaker = 'assets/icon/speaker.svg';
}
