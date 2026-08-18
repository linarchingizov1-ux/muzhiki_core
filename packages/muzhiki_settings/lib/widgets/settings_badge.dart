import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

class SettingsBadge extends StatelessWidget {
  final String label;
  final String? icon;
  final Color? color;
  final Color? backgroundColor;
  final double fontSize;

  const SettingsBadge({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.backgroundColor,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      padding: backgroundColor != null
          ? EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(21.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Padding(
              padding: EdgeInsets.only(top: 1.5.h),
              child: SvgPicture.asset(
                icon!,
                width: 12.w,
                height: 12.h,
                colorFilter: ColorFilter.mode(
                  MuzhikiColors.black23,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: 5.w),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: MuzhikiFonts.manropeStyle(
                fontSize: fontSize.sp,
                color: color ?? MuzhikiColors.greyText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}