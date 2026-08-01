import 'package:flutter/material.dart';
import 'package:muzhiki_core/muzhiki_ui/buttons/animated_button.dart';
import 'package:muzhiki_core/muzhiki_ui/buttons/choi_widgets.dart';

abstract final class MuzhikiUi {
  static final buttons = MuzhikiButtons._();
  static final appbars = MuzhikiAppBar._();
  static final dialog = MuzhikiDialog._();
}

final class MuzhikiButtons {
  const MuzhikiButtons._();

  AnimatedButton animated({
    String? svgAsset,
    IconData? icon,
    Color iconColor = Colors.white,
    Widget? child,
    required VoidCallback onTap,
    double size = 40,
    double iconSize = 16,
    Color? backgroundColor,
  }) => AnimatedButton(
    svgAsset: svgAsset,
    iconColor: iconColor,
    icon: icon,
    onTap: onTap,
    size: size,
    iconSize: iconSize,
    backgroundColor: backgroundColor,
    child: child,
  );

  ChoiceWidgets choi({
    required void Function(bool)? onSelected,
    required bool isSelected,
    required String label,
    int newMessage = 0,
    bool isLoading = false,
  }) => ChoiceWidgets(
    isLoading: isLoading,
    newMessage: newMessage,
    onSelected: onSelected,
    isSelected: isSelected,
    label: label,
  );
}

final class MuzhikiAppBar {
  const MuzhikiAppBar._();
}

final class MuzhikiDialog {
  const MuzhikiDialog._();
}
