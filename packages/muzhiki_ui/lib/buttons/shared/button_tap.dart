import 'dart:ui';

import 'package:flutter/material.dart';

bool buttonIsInteractive({required bool disabled, bool isLoading = false}) {
  return !disabled && !isLoading;
}

Color buttonBackgroundColor(Color color, {required bool enabled}) {
  return enabled ? color : color.withValues(alpha: 0.3);
}

/// Фон кнопки: при blur нужен alpha < 1, иначе эффект не видно.
Color resolveButtonSurfaceColor(
  Color color, {
  required bool enabled,
  required bool enableBackdropFilter,
}) {
  final base = buttonBackgroundColor(color, enabled: enabled);
  if (!enableBackdropFilter) return base;
  return base.withValues(alpha: enabled ? 0.55 : 0.25);
}

Widget wrapButtonBackdropFilter({
  required bool enable,
  required Widget child,
  BorderRadius? borderRadius,
  bool clipOval = false,
}) {
  if (!enable) return child;

  final filtered = BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
    child: child,
  );

  if (clipOval) {
    return ClipOval(clipBehavior: Clip.antiAlias, child: filtered);
  }

  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.zero,
    clipBehavior: Clip.antiAlias,
    child: filtered,
  );
}

class ButtonTap extends StatelessWidget {
  const ButtonTap({
    super.key,
    required this.onPressed,
    required this.child,
    this.enabled = true,
  });

  final VoidCallback onPressed;
  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: enabled ? onPressed : null, child: child);
  }
}
