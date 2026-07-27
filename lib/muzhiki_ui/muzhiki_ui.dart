import 'package:flutter/material.dart';
import 'package:muzhiki_core/muzhiki_ui/circle_button.dart';

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
    required double size,
    required double iconSize,
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
