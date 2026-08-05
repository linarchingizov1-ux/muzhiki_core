import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClassicButton extends StatelessWidget {
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color backgroudColor;
  final VoidCallback onTap;
  const ClassicButton({
    super.key,
    required this.borderRadius,
    required this.padding,
    required this.backgroudColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroudColor,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
    );
  }
}
