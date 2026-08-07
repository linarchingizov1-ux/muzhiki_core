import 'package:flutter/widgets.dart';
import 'package:muzhiki_ui/other/circle.dart';
import 'package:muzhiki_ui/other/notification.dart';
import 'package:muzhiki_ui/other/skelet.dart';

final class MuzhikiOther {
  const MuzhikiOther();
  Widget circle({Key? key, required Color colors, double size = 7}) =>
      CircleWidgets(key: key, colors: colors, size: size);
  Widget notification({Key? key, required int count, EdgeInsets? padding}) =>
      NotificationWidgets(count: count, padding: padding);

  Widget skelet({
    Key? key,
    required bool enable,
    required Widget child,
    bool lightPage = true,
    bool ignoreContainer = false,
  }) => AppSkelet(
    key: key,
    enable: enable,
    lightPage: lightPage,
    ignoreContainer: ignoreContainer,
    child: child,
  );
}
