import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/buttons/shared/button_loading.dart';
import 'package:muzhiki_ui/buttons/shared/button_tap.dart';
import 'package:muzhiki_ui/theme/support_colors.dart';

/// Компактная pill-кнопка.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = SupportColors.black17,
    this.labelColor,
    this.height = 45,
    this.padding,
    this.labelSize = 15,
    this.labelWeight,
    this.isLoading = false,
    this.disabled = false,
    this.progressColor = SupportColors.white,
  });

  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;
  final Color? labelColor;
  final double height;
  final EdgeInsets? padding;
  final double labelSize;
  final FontWeight? labelWeight;
  final bool isLoading;
  final bool disabled;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    final canTap = buttonIsInteractive(disabled: disabled, isLoading: isLoading);
    final bg = buttonBackgroundColor(backgroundColor, enabled: !disabled);

    return ButtonTap(
      onPressed: onPressed,
      enabled: canTap,
      child: Container(
        height: height.h,
        padding:
            padding ?? EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.r),
          color: bg,
        ),
        child: Center(
          child: isLoading
              ? ButtonLoading(
                  color: progressColor,
                  size: 20,
                  strokeAlign: 0.8,
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: labelSize.sp,
                    color: !disabled
                        ? labelColor ?? SupportColors.white
                        : labelColor?.withValues(alpha: 0.2) ??
                              SupportColors.white.withValues(alpha: 0.2),
                    fontWeight: labelWeight ?? FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
