import 'package:flutter/material.dart';
import 'package:muzhiki_core/muzhiki_ui/buttons/circle_button.dart';

abstract final class MuzhikiUi {
  static final buttons = MuzhikiButtons._();
}

final class MuzhikiButtons {
  const MuzhikiButtons._();

  CircleButton circle({
    String? svgAsset,
    IconData? icon,
    Widget? child,
    required VoidCallback onTap,
    double size = 40,
    double iconSize = 16,
    Color? backgroundColor,
  }) {
    return CircleButton(
      svgAsset: svgAsset,
      icon: icon,
      onTap: onTap,
      size: size,
      iconSize: iconSize,
      backgroundColor: backgroundColor,
      child: child,
    );
  }
}
