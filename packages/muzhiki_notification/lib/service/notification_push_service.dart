import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/widgets.dart';
import 'package:muzhiki_notification/config/notification_config.dart';
import 'package:muzhiki_notification/config/notification_storage.dart';
import 'package:muzhiki_notification/widgets/notification_dialog.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPushService with WidgetsBindingObserver {
  NotificationPushService(this._config);

  static const _repeatDialogInterval = Duration(days: 7);

  final NotificationConfig _config;

  bool _observingLifecycle = false;
  bool _isInSettings = false;

  bool get isFirstAuth =>
      _config.sharedPreferences.getBool(NotificationStorageKeys.firstAuth) ??
      true;

  bool get shouldShowPushDialog =>
      isFirstAuth && _config.session.user?.isFake != true;

  Future<void> markFirstAuthCompleted() async {
    await _config.sharedPreferences.setBool(
      NotificationStorageKeys.firstAuth,
      false,
    );
  }

  Future<void> handleOnLoad() async {
    if (shouldShowPushDialog) {
      await _showPushDialog(onAccept: acceptPushPermission);
      return;
    }

    if (await _canShowRepeatDialog()) {
      await _showPushDialog(onAccept: _onDialogAccepted);
      return;
    }

    await _config.registerPush();
  }

  Future<void> acceptPushPermission() async {
    if (!shouldShowPushDialog) return;
    await markFirstAuthCompleted();
    await _onDialogAccepted();
  }

  Future<void> openDeleteAccountInfo() async {
    final appName = _config.session.typeApp.label;
    await _config.urlLauncher.openURL(
      throwError: false,
      url: 'https://public.muzhiki.pro/delete-account?app=$appName',
    );
  }

  Future<void> _showPushDialog({
    required Future<void> Function() onAccept,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    await MuzhikiUi.dialog.standart(
      child: FirebasePushDialog(
        onAccept: onAccept,
        onDeleteAccountInfo: openDeleteAccountInfo,
      ),
    );
  }

  Future<bool> _canShowRepeatDialog() async {
    if (!_config.enableRepeatPushDialogAfterSevenDays) return false;
    if (_config.session.user?.isFake == true) return false;

    final status = await Permission.notification.status;
    if (status.isGranted || status.isProvisional || status.isLimited) {
      return false;
    }

    final milliseconds = _config.sharedPreferences.getInt(
      NotificationStorageKeys.repeatPushDialogShownAt,
    );
    if (milliseconds == null) return true;

    final now = DateTime.now().millisecondsSinceEpoch;
    return now - milliseconds >= _repeatDialogInterval.inMilliseconds;
  }

  Future<void> _onDialogAccepted() async {
    final status = await Permission.notification.status;
    final alreadyAsked =
        _config.sharedPreferences.getInt(
          NotificationStorageKeys.repeatPushDialogShownAt,
        ) !=
        null;
    final openSettings =
        status.isPermanentlyDenied ||
        (Platform.isIOS && status.isDenied && alreadyAsked);

    if (openSettings) {
      _isInSettings = true;
      if (!_observingLifecycle) {
        WidgetsBinding.instance.addObserver(this);
        _observingLifecycle = true;
      }
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
      return;
    }

    await _config.registerPush();

    final permission = await Permission.notification.status;
    if (permission.isGranted ||
        permission.isProvisional ||
        permission.isLimited) {
      await _clearRepeatDialogShownAt();
      return;
    }

    await _markRepeatDialogShownAt();
  }

  Future<void> _markRepeatDialogShownAt() async {
    await _config.sharedPreferences.setInt(
      NotificationStorageKeys.repeatPushDialogShownAt,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> _clearRepeatDialogShownAt() async {
    await _config.sharedPreferences.remove(
      NotificationStorageKeys.repeatPushDialogShownAt,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (!_isInSettings) return;

    _isInSettings = false;
    unawaited(_onReturnedFromSettings());
  }

  Future<void> _onReturnedFromSettings() async {
    try {
      final status = await Permission.notification.status;
      if (status.isGranted || status.isProvisional || status.isLimited) {
        await _clearRepeatDialogShownAt();
        await _config.registerPush();
      } else {
        await _markRepeatDialogShownAt();
      }
    } finally {
      if (_observingLifecycle) {
        WidgetsBinding.instance.removeObserver(this);
        _observingLifecycle = false;
      }
    }
  }
}
