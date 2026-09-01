import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:muzhiki_dependencies/network/exception/network_exception.dart';
import 'package:muzhiki_dependencies/network/extension/dio_error_extension.dart';
import 'package:muzhiki_dependencies/service/app_banner/app_banner_widget.dart';

import 'package:muzhiki_dependencies/src/dependencies.dart';

class BannerController {
  BannerController._();
  OverlayEntry? _entry;

  bool _isShowing = false;
  DateTime? _lastShownAt;
  String? _lastMessage;

  static final I = BannerController._();

  static const _debounce = Duration(seconds: 2);

  void show({
    BannerType type = BannerType.standart,
    String message = 'Произошла неизвестная ошибка',
    String? title,
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
      builder: (_) => AppBannerWidget(
        type: type,
        title: title ?? '',
        message: message,
        duration: duration,
        onDismiss: remove,
      ),
    );

    _entry = entry;
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 5), () {
      _isShowing = false;
    });
  }

  void showError({
    required AppException error,
    BannerType type = BannerType.standart,
    String? message,
    String? title,
  }) {
    final originalError = error.originalError;
    if (originalError is DioException && originalError.isConnectionProblem) {
      return;
    }

    show(message: message ?? error.message, type: type, title: title);
  }

  void remove() {
    _entry?.remove();
    _entry = null;
  }
}
