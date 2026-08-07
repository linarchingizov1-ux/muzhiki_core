import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/buttons/shared/button_loading.dart';
import 'package:muzhiki_ui/buttons/shared/button_tap.dart';
import 'package:muzhiki_ui/theme/support_colors.dart';

/// Кнопка с заголовком и описанием (две строки).
class LabeledButton extends StatelessWidget {
  const LabeledButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.description,
    this.height = 56,
    this.width = double.infinity,
    this.borderRadius = 16,
    this.backgroundColor = SupportColors.black17,
    this.padding,
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
  final Color backgroundColor;
  final EdgeInsets? padding;
  final double labelSize;
  final FontWeight? labelWeight;
  final bool isLoading;
  final bool disabled;
  final Color progressColor;
  final double progressSize;

  @override
  Widget build(BuildContext context) {
    final canTap = buttonIsInteractive(disabled: disabled, isLoading: isLoading);
    final bg = buttonBackgroundColor(backgroundColor, enabled: !disabled);
    final isLight = backgroundColor == SupportColors.light;

    return ButtonTap(
      onPressed: onPressed,
      enabled: canTap,
      child: Container(
        padding: padding,
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: isLoading
            ? Center(
                child: ButtonLoading(color: progressColor, size: progressSize),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: labelSize.sp,
                      fontWeight:
                          labelWeight ??
                          (isLight ? FontWeight.w600 : FontWeight.w700),
                      color: isLight ? SupportColors.black17 : SupportColors.white,
                    ),
                  ),
                  if (description != null)
                    FittedBox(
                      child: Text(
                        description!,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10.sp,
                          color: isLight ? SupportColors.grey : SupportColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
