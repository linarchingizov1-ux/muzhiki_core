import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleWidgets extends StatelessWidget {
  final Color colors;
  final double size;
  const CircleWidgets({super.key, required this.colors, this.size = 7});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.r,
      width: size.r,
      decoration: BoxDecoration(shape: BoxShape.circle, color: colors),
    );
  }
}
