import 'package:flutter/material.dart';
import 'package:muzhiki_ui/buttons/widgets/circle_button.dart';
import 'package:muzhiki_ui/buttons/widgets/dark_button.dart';
import 'package:muzhiki_ui/buttons/widgets/labeled_button.dart';
import 'package:muzhiki_ui/buttons/widgets/pill_button.dart';
import 'package:muzhiki_ui/buttons/animated_button.dart';
import 'package:muzhiki_ui/buttons/choi_widgets.dart';
import 'package:muzhiki_ui/buttons/widgets/primary_button.dart';
import 'package:muzhiki_ui/buttons/shared/button_tap.dart';
import 'package:muzhiki_ui/theme/support_colors.dart';

/// Фабрика кнопок UI-kit.
///
/// ```dart
/// AppButton.primary(label: 'Сохранить', onPressed: _save);
/// AppButton.circle(iconAsset: 'assets/icons/back.svg', onPressed: context.pop);
/// AppButton.back(svgAsset: backIcon, onTap: context.pop);
/// ```
abstract final class AppButton {
  const AppButton._();

  // ── CTA-кнопки ───────────────────────────────────────────────

  static Widget primary({
    Key? key,
    required String label,
    required VoidCallback onPressed,
    String? iconAsset,
    Color backgroundColor = SupportColors.black17,
    Color? labelColor,
    FontWeight? labelWeight,
    double labelSize = 15,
    double height = 56,
    double width = double.infinity,
    double borderRadius = 16,
    EdgeInsets? padding,
    bool isLoading = false,
    bool disabled = false,
    Color progressColor = SupportColors.white,
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

  static Widget dark({
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

  static Widget labeled({
    Key? key,
    required String label,
    required VoidCallback onPressed,
    String? description,
    double height = 56,
    double borderRadius = 16,
    Color backgroundColor = SupportColors.black17,
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

  static Widget labeledAnimated({
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

  static Widget pill({
    Key? key,
    required String label,
    required VoidCallback onPressed,
    Color backgroundColor = SupportColors.black17,
    Color? labelColor,
    double height = 45,
    EdgeInsets? padding,
    bool isLoading = false,
    bool disabled = false,
    FontWeight? labelWeight,
    double labelSize = 15,
    Color progressColor = SupportColors.white,
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

  static Widget circle({
    Key? key,
    required String iconAsset,
    required VoidCallback onPressed,
    Color backgroundColor = SupportColors.alertTextGrey,
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

  // ── Навигация ────────────────────────────────────────────────

  static Widget back({
    Key? key,
    required String svgAsset,
    required VoidCallback onTap,
    Color backgroundColor = SupportColors.alertTextGrey,
    Color iconColor = SupportColors.white,
    double size = 40,
  }) {
    return AnimatedButton(
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

  static Widget close({
    Key? key,
    required VoidCallback onTap,
    double size = 44,
    Color backgroundColor = SupportColors.black17,
    Color iconColor = SupportColors.white,
    double iconSize = 24,
  }) {
    return AnimatedButton(
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

  static Widget icon({
    Key? key,
    required String svgAsset,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color iconColor = SupportColors.white,
    double size = 40,
    double iconSize = 16,
  }) {
    return AnimatedButton(
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

  // ── Интерактивные обёртки ────────────────────────────────────

  static Widget pressable({
    Key? key,
    required Widget child,
    required VoidCallback onTap,
    double scale = 1.02,
    bool enabled = true,
  }) {
    return AnimatedButton(
      key: key,
      scale: scale,
      onTap: onTap,
      enabled: enabled,
      size: 40,
      iconSize: 16,
      iconColor: SupportColors.white,
      child: child,
    );
  }

  static Widget card({
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

  static Widget filterChip({
    required String label,
    required bool isSelected,
    required ValueChanged<bool>? onSelected,
    int badgeCount = 0,
    bool isLoading = false,
  }) {
    return ChoiceWidgets(
      label: label,
      isSelected: isSelected,
      onSelected: onSelected,
      newMessage: badgeCount,
      isLoading: isLoading,
    );
  }

  static Widget cameraShutter({
    required VoidCallback onTap,
    double size = 52,
    Color backgroundColor = SupportColors.light,
  }) {
    return AnimatedButton(
      size: size,
      backgroundColor: backgroundColor,
      scale: 1.1,
      onTap: onTap,
      iconSize: 16,
      iconColor: SupportColors.white,
    );
  }

  static Widget menuItem({
    required Widget child,
    VoidCallback? onTap,
    double scale = 1.01,
  }) {
    return pressable(scale: scale, onTap: onTap ?? () {}, child: child);
  }
}
