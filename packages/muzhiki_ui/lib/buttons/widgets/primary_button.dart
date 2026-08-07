import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muzhiki_ui/buttons/shared/button_loading.dart';
import 'package:muzhiki_ui/buttons/shared/button_tap.dart';
import 'package:muzhiki_ui/theme/support_colors.dart';

/// Широкая кнопка действия с опциональной SVG-иконкой.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = SupportColors.black17,
    this.labelColor,
    this.labelWeight,
    this.labelSize = 15,
    this.height = 56,
    this.width = double.infinity,
    this.borderRadius = 16,
    this.padding,
    this.iconAsset,
    this.isLoading = false,
    this.disabled = false,
    this.progressColor = SupportColors.white,
    this.progressSize = 28,
  });

  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;
  final Color? labelColor;
  final FontWeight? labelWeight;
  final double labelSize;
  final double height;
  final double width;
  final double borderRadius;
  final EdgeInsets? padding;
  final String? iconAsset;
  final bool isLoading;
  final bool disabled;
  final Color progressColor;
  final double progressSize;

  @override
  Widget build(BuildContext context) {
    final canTap = buttonIsInteractive(disabled: disabled, isLoading: isLoading);
    final bg = buttonBackgroundColor(backgroundColor, enabled: !disabled);
    final textColor = _labelColor(!disabled);

    return ButtonTap(
      onPressed: onPressed,
      enabled: canTap,
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius.r),
          color: bg,
        ),
        child: Center(
          child: isLoading
              ? ButtonLoading(color: progressColor, size: progressSize)
              : Row(
                  spacing: 12.w,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (iconAsset != null) SvgPicture.asset(iconAsset!),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: labelSize.sp,
                        fontWeight: labelWeight ?? FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Color _labelColor(bool enabled) {
    if (!enabled) {
      return backgroundColor == SupportColors.black17
          ? SupportColors.white.withValues(alpha: 0.3)
          : SupportColors.black17.withValues(alpha: 0.3);
    }
    if (backgroundColor == SupportColors.black17) {
      return SupportColors.white;
    }
    return labelColor ?? SupportColors.black17;
  }
}
