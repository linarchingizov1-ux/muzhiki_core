import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/buttons/shared/button_tap.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';
import 'package:muzhiki_ui/theme/muzhiki_fonts.dart';

enum SmallButtonMode { icon, standart }

enum AlignmentButtonIcon { start, end }

class SmallButton extends StatelessWidget {
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
  final double iconSpacing;
  final VoidCallback? onTap;
  final bool enableBackdropFilter;

  const SmallButton({
    super.key,
    required this.mode,
    this.alignment = AlignmentButtonIcon.start,
    this.icon,
    required this.label,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w500,
    this.labelColor = MuzhikiColors.black23Light,
    this.backgroundColor = MuzhikiColors.lightLight,
    this.radius = 30,
    this.labelPadding,
    this.iconSpacing = 6,
    this.onTap,
    this.enableBackdropFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: MuzhikiFonts.manrope,
        package: MuzhikiFonts.packageName,
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: labelColor,
        height: 1.2,
      ),
    );
    final borderRadius = BorderRadius.circular(radius.r);
    final bg = resolveButtonSurfaceColor(
      backgroundColor,
      enabled: true,
      enableBackdropFilter: enableBackdropFilter,
    );

    return wrapButtonBackdropFilter(
      enable: enableBackdropFilter,
      borderRadius: borderRadius,
      child: Material(
        color: bg,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Padding(
            padding:
                labelPadding ??
                EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
            // widthFactor/heightFactor: по контенту, если родитель не задал
            // ширину; при растягивании текст остаётся по центру.
            child: Align(
              alignment: Alignment.center,
              widthFactor: 1,
              heightFactor: 1,
              child: switch (mode) {
                SmallButtonMode.standart => text,
                SmallButtonMode.icon => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null &&
                        alignment == AlignmentButtonIcon.start) ...[
                      icon!,
                      SizedBox(width: iconSpacing.w),
                    ],
                    text,
                    if (icon != null &&
                        alignment == AlignmentButtonIcon.end) ...[
                      SizedBox(width: iconSpacing.w),
                      icon!,
                    ],
                  ],
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}
