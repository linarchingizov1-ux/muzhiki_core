import 'package:flutter/material.dart';

/// Кнопка активна для нажатия (не disabled и не в loading).
bool buttonIsInteractive({required bool disabled, bool isLoading = false}) {
  return !disabled && !isLoading;
}

/// Область нажатия кнопки с поддержкой disabled-состояния.
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
    return InkWell(
      onTap: enabled ? onPressed : null,
      child: child,
    );
  }
}

/// Цвет фона с учётом disabled-состояния.
Color buttonBackgroundColor(Color color, {required bool enabled}) {
  return enabled ? color : color.withValues(alpha: 0.3);
}
