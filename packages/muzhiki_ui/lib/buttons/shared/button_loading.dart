import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Индикатор загрузки для кнопок.
class ButtonLoading extends StatelessWidget {
  const ButtonLoading({
    super.key,
    required this.color,
    this.size = 28,
    this.strokeAlign,
  });

  final Color color;
  final double size;
  final double? strokeAlign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.h,
      height: size.h,
      child: CircularProgressIndicator(
        color: color,
        strokeAlign: strokeAlign ?? -1,
      ),
    );
  }
}
