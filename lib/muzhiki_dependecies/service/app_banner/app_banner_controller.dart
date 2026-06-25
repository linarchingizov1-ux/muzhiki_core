import 'package:flutter/material.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_widgets.dart';
import 'package:muzhiki_core/muzhiki_dependecies/muzhiki_dependencies.dart';

class BannerController {
  BannerController._();
  OverlayEntry? _entry;

  bool _isShowing = false;
  DateTime? _lastShownAt;
  String? _lastMessage;

  static final I = BannerController._();

  static const _debounce = Duration(seconds: 2);

  void show({
    String message = 'Произошла неизвестная ошибка',
    bool showAtTop = false,
    bool isError = true,
    Duration duration = const Duration(seconds: 4),
  }) {
    final now = DateTime.now();

    if (_lastMessage == message &&
        _lastShownAt != null &&
        now.difference(_lastShownAt!) < _debounce) {
      return;
    }

    if (_isShowing) return;

    _lastMessage = message;
    _lastShownAt = now;
    _isShowing = true;

    final overlay = MuzhikiDependencies.I.routerKey.currentState?.overlay;
    if (overlay == null) return;

    _entry?.remove();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => AppBannerWidgets(
        message: message,
        duration: duration,
        onDismiss: () => _entry?.remove,
      ),
    );

    _entry = entry;
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 5), () {
      _isShowing = false;
    });
  }

  void remove() {
    _entry?.remove();
    _entry = null;
  }
}
