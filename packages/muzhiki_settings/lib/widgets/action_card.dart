import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muzhiki_settings/config/settings_assets.dart';
import 'package:muzhiki_settings/config/settings_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? icon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? cardPadding;
  final Color? titleColor;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? backgroundIconColor;
  final double? badgeSpacing;
  final double iconSize;
  final double? titleSize;
  final FontWeight? titleWeight;
  final bool isCheckSelection;
  final bool isSelected;
  final bool enabled;
  final bool isLoading;
  final bool showSuffixIcon;
  final Widget? leading;
  final Widget? badge;
  final VoidCallback? onTap;
  final VoidCallback? onIconTap;

  const ActionCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.suffixIcon,
    this.cardPadding,
    this.titleColor,
    this.iconColor,
    this.backgroundColor,
    this.backgroundIconColor,
    this.badgeSpacing,
    this.iconSize = 20,
    this.titleSize = 15,
    this.titleWeight = FontWeight.w500,
    this.isCheckSelection = false,
    this.isSelected = false,
    this.enabled = true,
    this.isLoading = false,
    this.showSuffixIcon = true,
    this.leading,
    this.badge,
    this.onTap,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding:
            cardPadding ??
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? SettingsColors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            if (leading != null || icon != null) ...[
              leading != null
                  ? SizedBox(width: 40.w, height: 40.h, child: leading)
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: enabled ? onIconTap : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        width: 40.w,
                        height: 40.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              backgroundIconColor ?? SettingsColors.background,
                          borderRadius: BorderRadius.circular(60.r),
                        ),
                        child: TweenAnimationBuilder<Color?>(
                          duration: const Duration(milliseconds: 400),
                          tween: ColorTween(
                            end: iconColor ?? SettingsColors.alertTextGrey,
                          ),
                          builder: (context, color, _) => SvgPicture.asset(
                            icon!,
                            width: iconSize.w,
                            height: iconSize.h,
                            colorFilter: ColorFilter.mode(
                              color ??
                                  iconColor ??
                                  SettingsColors.alertTextGrey,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(width: 16.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: titleSize?.sp,
                      height: 1.2,
                      color: titleColor ?? SettingsColors.black23,
                      fontWeight: titleWeight ?? FontWeight.w500,
                    ),
                  ),
                  if (description != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: SettingsColors.alertTextGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (badge != null) ...[
                    if (badgeSpacing != null) SizedBox(height: badgeSpacing?.h),
                    Skeletonizer(enabled: isLoading, child: badge!),
                  ],
                ],
              ),
            ),
            SizedBox(width: 10.w),
            if (showSuffixIcon)
              if (isCheckSelection)
                Container(
                  height: 25.h,
                  width: 25.w,
                  padding: EdgeInsets.all(7.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? SettingsColors.black23
                        : SettingsColors.white,
                  ),
                  child: isSelected
                      ? SvgPicture.asset(SettingsAssets.check)
                      : null,
                )
              else
                suffixIcon ??
                    SvgPicture.asset(
                      SettingsAssets.arrowRight,
                      width: 25.w,
                      height: 25.h,
                      colorFilter: const ColorFilter.mode(
                        SettingsColors.alertTextGrey,
                        BlendMode.srcIn,
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}
