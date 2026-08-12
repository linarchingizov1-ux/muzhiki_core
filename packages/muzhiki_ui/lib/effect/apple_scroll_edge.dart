import 'package:flutter/material.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

/// Параметры soft scroll-edge в духе iOS (UIScrollEdgeEffect.soft).
abstract final class AppleScrollEdge {
  /// Сила размытия у края (равномерный sigma + мягкая маска).
  static const double sigma = 22;

  /// Control points: полный blur у края → плавный сход в контент.
  static List<ControlPoint> get controlPoints => [
         ControlPoint(position: 0.0, type: ControlPointType.visible),
         ControlPoint(position: 0.42, type: ControlPointType.visible),
         ControlPoint(position: 1.0, type: ControlPointType.transparent),
      ];

  /// Полупрозрачный material-tint. Непрозрачный цвет полностью скрывает blur.
  static Color materialTint(Color background) {
    final luminance = background.computeLuminance();
    if (luminance > 0.5) {
      return Color.alphaBlend(
        Colors.white.withValues(alpha: 0.22),
        background.withValues(alpha: 0.42),
      );
    }
    return Color.alphaBlend(
      Colors.white.withValues(alpha: 0.06),
      background.withValues(alpha: 0.48),
    );
  }

  static Color defaultTint({Color? tintColor, Color? backgroundColor}) {
    if (tintColor != null) {
      return tintColor.a >= 1.0
          ? tintColor.withValues(alpha: 0.45)
          : tintColor;
    }
    return materialTint(backgroundColor ?? MuzhikiColors.appBackgroud);
  }
}
