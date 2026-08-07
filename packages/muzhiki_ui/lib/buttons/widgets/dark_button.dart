import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/buttons/shared/button_loading.dart';
import 'package:muzhiki_ui/buttons/shared/button_tap.dart';
import 'package:muzhiki_ui/theme/support_colors.dart';

/// Тёмная кнопка с белым текстом и опциональным подзаголовком.
class DarkButton extends StatelessWidget {
  const DarkButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.description,
    this.height = 56,
    this.width = double.infinity,
    this.borderRadius = 16,
    this.labelSize = 15,
    this.labelWeight,
    this.isLoading = false,
    this.disabled = false,
    this.progressColor = SupportColors.white,
    this.progressSize = 28,
  });

  final VoidCallback onPressed;
  final String label;
  final String? description;
  final double height;
  final double width;
  final double borderRadius;
  final double labelSize;
  final FontWeight? labelWeight;
  final bool isLoading;
  final bool disabled;
  final Color progressColor;
  final double progressSize;

  @override
  Widget build(BuildContext context) {
    final canTap = buttonIsInteractive(disabled: disabled, isLoading: isLoading);
    final bg = !disabled
        ? SupportColors.black17
        : SupportColors.black17.withValues(alpha: 0.3);

    return ButtonTap(
      onPressed: onPressed,
      enabled: canTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius.r),
          color: bg,
        ),
        child: Center(
          child: isLoading
              ? ButtonLoading(color: progressColor, size: progressSize)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: labelSize,
                        fontWeight: labelWeight ?? FontWeight.w700,
                        color: !disabled
                            ? SupportColors.white
                            : SupportColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    if (description != null)
                      FittedBox(
                        child: Text(
                          description!,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: SupportColors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
