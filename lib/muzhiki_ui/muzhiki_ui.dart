import 'package:flutter/material.dart';
import 'package:muzhiki_core/muzhiki_ui/ios_circle_button.dart';

abstract class MuzhikiUi {
  static CircleButton circle({
    String? svgAsset,
    IconData? icon,
    required VoidCallback onTap,
    Widget? child,

    required double size,
    required double iconSize,
    Color? backgroundColor,
  }) => CircleButton(
    svgAsset: svgAsset,
    icon: icon,
    onTap: onTap,
    size: size,
    iconSize: iconSize,
    backgroundColor: backgroundColor,
    child: child,
  );
}
