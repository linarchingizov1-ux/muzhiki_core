import 'package:flutter/material.dart';

/// Шрифты `muzhiki_ui`.
///
/// Внутри пакета и в приложениях всегда указывай [packageName],
/// иначе Flutter откатывается на системный (SF Pro / Roboto).
abstract final class MuzhikiFonts {
  static const manrope = 'Manrope';
  static const inter = 'Inter';
  static const packageName = 'muzhiki_ui';

  /// Готовый TextStyle с Manrope из пакета.
  static TextStyle manropeStyle({
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    Color? color,
    double? height,
    double? letterSpacing,
    TextAlign? textAlign,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      inherit: true,
      fontFamily: manrope,
      package: packageName,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }
}
