import 'package:flutter/material.dart';
import 'package:muzhiki_ui/buttons/animated_button.dart';
import 'package:muzhiki_ui/buttons/choi_widgets.dart';
import 'package:muzhiki_ui/dialog/app_dialog.dart';

export 'buttons/app_button.dart';
export 'buttons/buttons.dart';
export 'dialog/dialog.dart';
export 'theme/support_colors.dart';
export 'widgets/button_small.dart';
export 'widgets/legacy_button.dart';
export 'widgets/notification.dart';
export 'widgets/skelet.dart';
export 'buttons/animated_button.dart';
export 'buttons/choi_widgets.dart';

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
    Key? key,
    Color iconColor = Colors.white,
    Widget? child,
    required VoidCallback onTap,
    double size = 40,
    double iconSize = 16,
    Color? backgroundColor,
    double scale = 1.1,
    bool enabled = true,
  }) => AnimatedButton(
    key: key,
    svgAsset: svgAsset,
    scale: scale,
    iconColor: iconColor,
    icon: icon,
    onTap: onTap,
    size: size,
    iconSize: iconSize,
    backgroundColor: backgroundColor,
    enabled: enabled,
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

  Future<T?> standart<T>({
    required Widget child,
    BuildContext? context,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
    bool canPop = true,
  }) =>
      AppDialog.standart<T>(
        child: child,
        context: context,
        height: height,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        canPop: canPop,
      );

  Future<bool?> needUpdate({
    required Widget child,
    BuildContext? context,
  }) =>
      AppDialog.needUpdate(child: child, context: context);
}