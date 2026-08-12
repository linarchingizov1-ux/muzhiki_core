import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/buttons/shared/button_loading.dart';
import 'package:muzhiki_ui/buttons/shared/button_tap.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

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
    this.enableBackdropFilter = false,
    this.progressColor = MuzhikiColors.white,
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
  final bool enableBackdropFilter;
  final Color progressColor;
  final double progressSize;

  @override
  Widget build(BuildContext context) {
    final canTap = buttonIsInteractive(
      disabled: disabled,
      isLoading: isLoading,
    );
    final bg = !disabled
        ? MuzhikiColors.black17
        : MuzhikiColors.black17.withValues(alpha: 0.3);
    final radius = BorderRadius.circular(borderRadius.r);

    return ButtonTap(
      onPressed: onPressed,
      enabled: canTap,
      child: wrapButtonBackdropFilter(
        enable: enableBackdropFilter,
        borderRadius: radius,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
          height: height.h,
          width: width == double.infinity ? double.infinity : width.w,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: bg,
          ),
          alignment: Alignment.center,
          child: isLoading
              ? ButtonLoading(color: progressColor, size: progressSize)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: labelSize,
                        fontWeight: labelWeight ?? FontWeight.w700,
                        color: !disabled
                            ? MuzhikiColors.white
                            : MuzhikiColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    if (description != null)
                      FittedBox(
                        child: Text(
                          description!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: MuzhikiColors.grey,
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
