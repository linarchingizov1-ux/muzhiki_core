import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/buttons/shared/button_loading.dart';
import 'package:muzhiki_ui/buttons/shared/button_tap.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = MuzhikiColors.black17,
    this.labelColor,
    this.height = 45,
    this.padding,
    this.labelSize = 15,
    this.labelWeight,
    this.isLoading = false,
    this.disabled = false,
    this.enableBackdropFilter = false,
    this.progressColor,
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
  final bool enableBackdropFilter;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    final canTap = buttonIsInteractive(
      disabled: disabled,
      isLoading: isLoading,
    );
    final bg = resolveButtonSurfaceColor(
      backgroundColor,
      enabled: !disabled,
      enableBackdropFilter: enableBackdropFilter,
    );
    final radius = BorderRadius.circular(40.r);

    return wrapButtonBackdropFilter(
      enable: enableBackdropFilter,
      borderRadius: radius,
      child: ButtonTap(
        onPressed: onPressed,
        enabled: canTap,
        child: Container(
          height: height.h,
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          decoration: BoxDecoration(
            borderRadius: radius,
            color: bg,
          ),
          alignment: Alignment.center,
          child: isLoading
              ? ButtonLoading(
                  color: progressColor,
                  backgroundColor: bg,
                  size: 20,
                )
              : Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: labelSize.sp,
                    color: !disabled
                        ? labelColor ?? MuzhikiColors.white
                        : labelColor?.withValues(alpha: 0.2) ??
                              MuzhikiColors.white.withValues(alpha: 0.2),
                    fontWeight: labelWeight ?? FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
