import 'package:flutter/material.dart';
import 'package:muzhiki_ui/buttons/shared/button_tap.dart';
import 'package:muzhiki_ui/buttons/widgets/animated_button.dart';
import 'package:muzhiki_ui/buttons/widgets/choi_widgets.dart';
import 'package:muzhiki_ui/buttons/widgets/circle_button.dart';
import 'package:muzhiki_ui/buttons/widgets/dark_button.dart';
import 'package:muzhiki_ui/buttons/widgets/labeled_button.dart';
import 'package:muzhiki_ui/buttons/widgets/pill_button.dart';
import 'package:muzhiki_ui/buttons/widgets/primary_button.dart';
import 'package:muzhiki_ui/buttons/widgets/small_button.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

export 'widgets/small_button.dart';

final class MuzhikiButtons {
  const MuzhikiButtons();

  Widget primary({
    Key? key,
    required String label,
    required VoidCallback onPressed,
    String? iconAsset,
    Color backgroundColor = MuzhikiColors.black17,
    Color? labelColor,
    FontWeight? labelWeight,
    double labelSize = 15,
    double height = 56,
    double width = double.infinity,
    double borderRadius = 16,
    EdgeInsets? padding,
    bool isLoading = false,
    bool disabled = false,
    Color progressColor = MuzhikiColors.white,
    double progressSize = 28,
  }) {
    return PrimaryButton(
      key: key,
      label: label,
      iconAsset: iconAsset,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      labelColor: labelColor,
      labelWeight: labelWeight,
      labelSize: labelSize,
      height: height,
      width: width,
      borderRadius: borderRadius,
      padding: padding,
      isLoading: isLoading,
      disabled: disabled,
      progressColor: progressColor,
      progressSize: progressSize,
    );
  }

  Widget dark({
    Key? key,
    required String label,
    required VoidCallback onPressed,
    String? description,
    double height = 56,
    bool isLoading = false,
    bool disabled = false,
    double borderRadius = 16,
  }) {
    return DarkButton(
      key: key,
      label: label,
      description: description,
      onPressed: onPressed,
      height: height,
      isLoading: isLoading,
      disabled: disabled,
      borderRadius: borderRadius,
    );
  }

  Widget labeled({
    Key? key,
    required String label,
    required VoidCallback onPressed,
    String? description,
    double height = 56,
    double borderRadius = 16,
    Color backgroundColor = MuzhikiColors.black17,
    bool isLoading = false,
    bool disabled = false,
    EdgeInsets? padding,
    double labelSize = 15,
    FontWeight? labelWeight,
  }) {
    return LabeledButton(
      key: key,
      label: label,
      description: description,
      onPressed: onPressed,
      height: height,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      isLoading: isLoading,
      disabled: disabled,
      padding: padding,
      labelSize: labelSize,
      labelWeight: labelWeight,
    );
  }

  Widget labeledAnimated({
    Key? key,
    required String label,
    required VoidCallback onPressed,
    String? description,
    double height = 58,
    double borderRadius = 44,
    bool isLoading = false,
    bool disabled = false,
    double pressScale = 1.03,
  }) {
    final interactive = buttonIsInteractive(
      disabled: disabled,
      isLoading: isLoading,
    );

    return pressable(
      scale: pressScale,
      onTap: onPressed,
      enabled: interactive,
      child: IgnorePointer(
        child: LabeledButton(
          key: key,
          label: label,
          description: description,
          onPressed: onPressed,
          height: height,
          borderRadius: borderRadius,
          isLoading: isLoading,
          disabled: disabled,
        ),
      ),
    );
  }

  Widget pill({
    Key? key,
    required String label,
    required VoidCallback onPressed,
    Color backgroundColor = MuzhikiColors.black17,
    Color? labelColor,
    double height = 45,
    EdgeInsets? padding,
    bool isLoading = false,
    bool disabled = false,
    FontWeight? labelWeight,
    double labelSize = 15,
    Color progressColor = MuzhikiColors.white,
  }) {
    return PillButton(
      key: key,
      label: label,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      labelColor: labelColor,
      height: height,
      padding: padding,
      isLoading: isLoading,
      disabled: disabled,
      labelWeight: labelWeight,
      labelSize: labelSize,
      progressColor: progressColor,
    );
  }

  /// Компактная pill-кнопка (текст / текст + иконка).
  Widget small({
    Key? key,
    required String label,
    SmallButtonMode mode = SmallButtonMode.standart,
    AlignmentButtonIcon alignment = AlignmentButtonIcon.start,
    Widget? icon,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w500,
    Color labelColor = MuzhikiColors.black23,
    Color backgroundColor = MuzhikiColors.light,
    double radius = 30,
    EdgeInsetsGeometry? labelPadding,
    VoidCallback? onTap,
  }) {
    return SmallButton(
      key: key,
      mode: mode,
      alignment: alignment,
      icon: icon,
      label: label,
      fontSize: fontSize,
      fontWeight: fontWeight,
      labelColor: labelColor,
      backgroundColor: backgroundColor,
      radius: radius,
      labelPadding: labelPadding,
      onTap: onTap,
    );
  }

  Widget circle({
    Key? key,
    required String iconAsset,
    required VoidCallback onPressed,
    Color backgroundColor = MuzhikiColors.alertTextGrey,
    double size = 42,
    double iconSize = 40,
    bool disabled = false,
  }) {
    return CircleButton(
      key: key,
      iconAsset: iconAsset,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      size: size,
      iconSize: iconSize,
      disabled: disabled,
    );
  }

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

  Widget back({
    Key? key,
    required String svgAsset,
    required VoidCallback onTap,
    Color backgroundColor = MuzhikiColors.alertTextGrey,
    Color iconColor = MuzhikiColors.white,
    double size = 40,
  }) {
    return animated(
      key: key,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      svgAsset: svgAsset,
      size: size,
      iconSize: 16,
      scale: 1.1,
      onTap: onTap,
    );
  }

  Widget close({
    Key? key,
    required VoidCallback onTap,
    double size = 44,
    Color backgroundColor = MuzhikiColors.black17,
    Color iconColor = MuzhikiColors.white,
    double iconSize = 24,
  }) {
    return animated(
      key: key,
      size: size,
      iconColor: iconColor,
      iconSize: iconSize,
      backgroundColor: backgroundColor,
      icon: Icons.close,
      scale: 1.1,
      onTap: onTap,
    );
  }

  Widget icon({
    Key? key,
    required String svgAsset,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color iconColor = MuzhikiColors.white,
    double size = 40,
    double iconSize = 16,
  }) {
    return animated(
      key: key,
      svgAsset: svgAsset,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      size: size,
      iconSize: iconSize,
      scale: 1.1,
      onTap: onTap,
    );
  }

  Widget pressable({
    Key? key,
    required Widget child,
    required VoidCallback onTap,
    double scale = 1.02,
    bool enabled = true,
  }) {
    return animated(
      key: key,
      scale: scale,
      onTap: onTap,
      enabled: enabled,
      size: 40,
      iconSize: 16,
      iconColor: MuzhikiColors.white,
      child: child,
    );
  }

  Widget card({
    Key? key,
    required Widget child,
    required VoidCallback onTap,
    double scale = 1.02,
    bool enabled = true,
  }) {
    return pressable(
      key: key,
      scale: scale,
      onTap: onTap,
      enabled: enabled,
      child: child,
    );
  }

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

  Widget filterChip({
    required String label,
    required bool isSelected,
    required ValueChanged<bool>? onSelected,
    int badgeCount = 0,
    bool isLoading = false,
  }) {
    return choi(
      label: label,
      isSelected: isSelected,
      onSelected: onSelected,
      newMessage: badgeCount,
      isLoading: isLoading,
    );
  }

  Widget cameraShutter({
    required VoidCallback onTap,
    double size = 52,
    Color backgroundColor = MuzhikiColors.light,
  }) {
    return animated(
      size: size,
      backgroundColor: backgroundColor,
      scale: 1.1,
      onTap: onTap,
      iconSize: 16,
      iconColor: MuzhikiColors.white,
    );
  }

  Widget menuItem({
    required Widget child,
    VoidCallback? onTap,
    double scale = 1.01,
  }) {
    return pressable(scale: scale, onTap: onTap ?? () {}, child: child);
  }
}
