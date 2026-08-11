import 'package:muzhiki_notification/config/notification_config.dart';
import 'package:muzhiki_notification/config/notification_storage.dart';
import 'package:muzhiki_notification/widgets/notification_dialog.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

class FirstAuthPushService {
  FirstAuthPushService(this._config);

  final NotificationConfig _config;

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
      await MuzhikiUi.dialog.standart(
        child: FirebasePushDialog(
          onAccept: acceptPushPermission,
          onDeleteAccountInfo: openDeleteAccountInfo,
        ),
      );
      return;
    }
    await _config.registerPush();
  }

  Future<void> acceptPushPermission() async {
    if (!shouldShowPushDialog) return;
    await markFirstAuthCompleted();
    await _config.registerPush();
  }

  Future<void> openDeleteAccountInfo() async {
    final appName = _config.session.typeApp.label;
    await _config.urlLauncher.openURL(
      throwError: false,
      url: 'https://public.muzhiki.pro/delete-account?app=$appName',
    );
  }
}
