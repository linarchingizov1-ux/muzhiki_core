import 'package:muzhiki_dependencies/muzhiki_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationConfig {
  final SessionApp session;
  final SharedPreferences sharedPreferences;
  final MuzhikiUrlLaunch urlLauncher;

  final Future<void> Function() registerPush;

  const NotificationConfig({
    required this.session,
    required this.sharedPreferences,
    required this.urlLauncher,
    required this.registerPush,
  });
}
