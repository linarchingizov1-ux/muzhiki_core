class SupportAssets {
  SupportAssets._();
  static final I = SupportAssets._();

  final svg = _SupportAssetsSvg();
  final png = _SupportAssetsPng();
}

class _SupportAssetsPng {
  const _SupportAssetsPng();
  static const _base = 'packages/muzhiki_core/assets/support/png';
  final starEnable = '$_base/star_e.png';
  final starDisable = '$_base/star_dis.png';
  final informatorBackground = '$_base/informator_background.png';
}

class _SupportAssetsSvg {
  const _SupportAssetsSvg();

  static const _base = 'packages/muzhiki_core/assets/support/svg';
  final arrowBack = '$_base/arrow_back.svg';
  final dashboard = '$_base/dashboard.svg';
  final logout = '$_base/logout.svg';
  final add = '$_base/add.svg';
  final info = '$_base/info.svg';
  final doc = '$_base/doc.svg';
  final close = '$_base/close.svg';
  final recodeVideo = '$_base/recorde_video.svg';
  final file = '$_base/file.svg';
  final image = '$_base/image.svg';
  final screpka = '$_base/screpka.svg';
  final speaker = '$_base/speaker.svg';
}
