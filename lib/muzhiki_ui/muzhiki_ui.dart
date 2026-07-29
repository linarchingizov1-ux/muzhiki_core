import 'package:flutter/material.dart';
import 'package:muzhiki_core/muzhiki_ui/buttons/circle_button.dart';

abstract final class MuzhikiUi {
  static final buttons = MuzhikiButtons._();
  static final appbars = MuzhikiAppBar._();
  static final dialog = MuzhikiDialog._();
}

final class MuzhikiButtons {
  const MuzhikiButtons._();

  CircleButton circle({
    String? svgAsset,
    IconData? icon,
    Color iconColor = Colors.white,
    Widget? child,
    required VoidCallback onTap,
    double size = 40,
    double iconSize = 16,
    Color? backgroundColor,
  }) => CircleButton(
    svgAsset: svgAsset,
    iconColor: iconColor,
    icon: icon,
    onTap: onTap,
    size: size,
    iconSize: iconSize,
    backgroundColor: backgroundColor,
    child: child,
  );

  // ClassicButton classic({
  //   required double borderRadius,
  //   EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
  //     vertical: 5,
  //     horizontal: 10,
  //   ),
  //   Color backgroudColor = Colors.black,
  //   required VoidCallback onTap,
  // }) => ClassicButton();
}

final class MuzhikiAppBar {
  const MuzhikiAppBar._();
}

final class MuzhikiDialog {
  const MuzhikiDialog._();
}
