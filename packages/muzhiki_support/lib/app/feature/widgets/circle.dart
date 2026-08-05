import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleWidgets extends StatelessWidget {
  final Color colors;
  const CircleWidgets({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.h,
      width: 7.h,
      decoration: BoxDecoration(shape: BoxShape.circle, color: colors),
    );
  }
}
