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
  static const _androidRuntimePermissionSdk = 33;

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
    if (_isGranted(status)) return false;

    final milliseconds = _config.sharedPreferences.getInt(
      NotificationStorageKeys.repeatPushDialogShownAt,
    );
    if (milliseconds == null) return true;

    final now = DateTime.now().millisecondsSinceEpoch;
    return now - milliseconds >= _repeatDialogInterval.inMilliseconds;
  }

  Future<void> _onDialogAccepted() async {
    final status = await Permission.notification.status;
    if (!_canShowNativeDialog(status)) {
      await _openNotificationSettings();
      return;
    }

    await _config.registerPush();

    final after = await Permission.notification.status;
    if (!_isGranted(after)) {
      await _markRepeatDialogShownAt();
    }
  }

  bool _canShowNativeDialog(PermissionStatus status) {
    if (_isGranted(status)) return true;
    if (status.isPermanentlyDenied || status.isRestricted) return false;

    final sdk = _config.androidSdkInt;
    if (Platform.isAndroid &&
        sdk != null &&
        sdk < _androidRuntimePermissionSdk) {
      return false;
    }

    return true;
  }

  bool _isGranted(PermissionStatus status) =>
      status.isGranted || status.isProvisional || status.isLimited;

  Future<void> _openNotificationSettings() async {
    _isInSettings = true;
    if (!_observingLifecycle) {
      WidgetsBinding.instance.addObserver(this);
      _observingLifecycle = true;
    }

    try {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    } catch (_) {
      _isInSettings = false;
      _stopObservingLifecycle();
    }
  }

  Future<void> _markRepeatDialogShownAt() async {
    await _config.sharedPreferences.setInt(
      NotificationStorageKeys.repeatPushDialogShownAt,
      DateTime.now().millisecondsSinceEpoch,
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
      if (_isGranted(status)) {
        await _config.registerPush();
        return;
      }

      await _markRepeatDialogShownAt();
    } finally {
      _stopObservingLifecycle();
    }
  }

  void _stopObservingLifecycle() {
    if (!_observingLifecycle) return;
    WidgetsBinding.instance.removeObserver(this);
    _observingLifecycle = false;
  }

  void dispose() {
    _isInSettings = false;
    _stopObservingLifecycle();
  }
}
