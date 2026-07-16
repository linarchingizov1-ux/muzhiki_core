import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_ui_kit/config/core_colors.dart';
import 'package:muzhiki_core/muzhiki_ui_kit/config/core_fonts.dart';

enum SmallButtonMode { icon, standart }

enum AlignmentButtonIcon { start, end }

class AppButtonSmall extends StatelessWidget {
  final SmallButtonMode mode;
  final AlignmentButtonIcon alignment;
  final Widget? icon;
  final String label;
  final double fontSize;
  final FontWeight fontWeight;
  final Color labelColor;
  final Color backgroundColor;
  final double radius;
  final EdgeInsetsGeometry? labelPadding;
  final VoidCallback? onTap;

  const AppButtonSmall({
    super.key,
    required this.mode,
    this.alignment = AlignmentButtonIcon.start,
    this.icon,
    required this.label,
    this.fontSize = 15,
    this.fontWeight = CoreFonts.medium,
    this.labelColor = CoreColors.black23,
    this.backgroundColor = CoreColors.light,
    this.radius = 30,
    this.labelPadding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      style: TextStyle(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: labelColor,
        height: 1.2,
      ),
    );

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius.r),
        onTap: onTap,
        child: Padding(
          padding:
              labelPadding ??
              EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
          child: switch (mode) {
            SmallButtonMode.standart => text,
            SmallButtonMode.icon => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null && alignment == AlignmentButtonIcon.start) ...[
                  icon!,
                  SizedBox(width: 6.w),
                ],
                text,
                if (icon != null && alignment == AlignmentButtonIcon.end) ...[
                  SizedBox(width: 6.w),
                  icon!,
                ],
              ],
            ),
          },
        ),
      ),
    );
  }
}
