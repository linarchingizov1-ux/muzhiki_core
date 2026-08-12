import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

class ButtonLoading extends StatelessWidget {
  const ButtonLoading({
    super.key,
    this.color,
    this.backgroundColor,
    this.size = 28,
    this.strokeAlign,
  });

  /// Явный цвет индикатора. Если null — берётся контрастный к [backgroundColor].
  final Color? color;

  /// Фон кнопки, по которому подбирается видимый цвет индикатора.
  final Color? backgroundColor;

  final double size;
  final double? strokeAlign;

  static Color contrastOn(Color background) {
    return background.computeLuminance() > 0.45
        ? MuzhikiColors.black17
        : MuzhikiColors.white;
  }

  Color get _resolvedColor {
    if (color != null) return color!;
    return contrastOn(backgroundColor ?? MuzhikiColors.black17);
  }

  bool _useCupertino(BuildContext context) {
    return switch (Theme.of(context).platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => true,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    final progressColor = _resolvedColor;
    final side = size.h;

    if (_useCupertino(context)) {
      return SizedBox(
        width: side,
        height: side,
        child: CupertinoActivityIndicator(
          color: progressColor,
          radius: side / 2,
        ),
      );
    }

    return SizedBox(
      width: side,
      height: side,
      child: CircularProgressIndicator(
        color: progressColor,
        strokeWidth: 2.5,
        strokeAlign: strokeAlign ?? BorderSide.strokeAlignInside,
      ),
    );
  }
}
