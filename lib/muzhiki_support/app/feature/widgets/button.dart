import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';

enum ButtonMode { classic, black, description, circle, rounded }

class AppButton extends StatelessWidget {
  final void Function() onPressed;
  final ButtonMode mode;
  final String? label;
  final double labelSize;
  final Color backgroundColor;
  final Color? labelColor;
  final EdgeInsets? labelPadding;
  final FontWeight? labelWeight;
  final Color? progressColor;
  final bool? disable;
  final double width, height, sizeProgress;
  final String? description;
  final bool isLoading;
  final String? assetIcon;
  final double borderRadius;
  const AppButton({
    this.sizeProgress = 28,
    this.progressColor = SupportColors.white,
    this.isLoading = false,
    this.width = double.infinity,
    this.labelPadding,
    this.labelSize = 15,
    required this.mode,
    this.height = 56,
    super.key,
    this.backgroundColor = SupportColors.black17,
    this.labelColor,
    this.labelWeight,
    this.assetIcon,
    this.disable,
    this.borderRadius = 16,
    required this.onPressed,
    this.label,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case ButtonMode.classic:
        return InkWell(
          onTap: disable != null && disable! ? null : onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
            height: height.h,
            width: width.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius.r),
              color: disable != null && disable!
                  ? backgroundColor.withValues(alpha: 0.3)
                  : backgroundColor,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: sizeProgress.h,
                      height: sizeProgress.h,
                      child: CircularProgressIndicator(color: progressColor),
                    )
                  : Row(
                      spacing: 12.w,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (assetIcon != null) SvgPicture.asset(assetIcon!),
                        Text(
                          label ?? '',
                          style: TextStyle(
                            fontSize: labelSize.sp,
                            fontWeight: labelWeight ?? FontWeight.w700,
                            color: disable != null && disable!
                                ? (backgroundColor == SupportColors.black17
                                      ? SupportColors.white.withValues(
                                          alpha: 0.3,
                                        )
                                      : SupportColors.black17.withValues(
                                          alpha: 0.3,
                                        ))
                                : backgroundColor == SupportColors.black17
                                ? SupportColors.white
                                : labelColor ?? SupportColors.black17,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      case ButtonMode.description:
        return InkWell(
          onTap: disable != null && disable! ? null : onPressed,
          child: Container(
            width: width.w,
            height: height.h,
            decoration: BoxDecoration(
              color: disable != null && disable!
                  ? backgroundColor.withValues(alpha: 0.3)
                  : backgroundColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: isLoading
                ? SizedBox(
                    width: sizeProgress.h,
                    height: sizeProgress.h,
                    child: CircularProgressIndicator(color: progressColor),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label ?? '',
                        style: TextStyle(
                          fontSize: labelSize.sp,
                          fontWeight:
                              labelWeight ??
                              (backgroundColor != SupportColors.light
                                  ? FontWeight.w700
                                  : FontWeight.w600),
                          color: backgroundColor != SupportColors.light
                              ? SupportColors.white
                              : SupportColors.black17,
                        ),
                      ),
                      if (description != null)
                        FittedBox(
                          child: Text(
                            description!,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: backgroundColor != SupportColors.light
                                  ? SupportColors.white
                                  : SupportColors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        );
      case ButtonMode.black:
        return InkWell(
          onTap: disable != null && disable! ? null : onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
            height: height.h,
            width: width.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius.r),
              color: disable != null && disable!
                  ? SupportColors.black17.withValues(alpha: 0.3)
                  : SupportColors.black17,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: sizeProgress.h,
                      height: sizeProgress.h,
                      child: CircularProgressIndicator(color: progressColor),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label ?? '',
                          style: TextStyle(
                            fontSize: labelSize,
                            fontWeight: labelWeight ?? FontWeight.w700,
                            color: disable != null && disable!
                                ? SupportColors.white.withValues(alpha: 0.5)
                                : SupportColors.white,
                          ),
                        ),
                        if (description != null)
                          FittedBox(
                            child: Text(
                              description!,
                              style: TextStyle(
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
      case ButtonMode.circle:
        return InkWell(
          onTap: disable != null && disable! ? null : onPressed,
          child: Container(
            width: 42.h,
            height: 42.h,
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: disable != null && disable!
                  ? backgroundColor.withValues(alpha: 0.3)
                  : backgroundColor,
            ),
            child: assetIcon != null
                ? SvgPicture.asset(
                    height: 40.h,
                    width: 40.h,
                    assetIcon!,
                    alignment: AlignmentGeometry.center,
                  )
                : SizedBox.shrink(),
          ),
        );
      case ButtonMode.rounded:
        return InkWell(
          onTap: disable != null && disable! ? null : onPressed,
          child: Container(
            height: height.h,
            padding:
                labelPadding ??
                EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.r),
              color: disable != null && disable!
                  ? backgroundColor.withValues(alpha: 0.3)
                  : backgroundColor,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: CircularProgressIndicator(
                        strokeAlign: 0.8,
                        color: progressColor,
                      ),
                    )
                  : Text(
                      label ?? '',
                      style: TextStyle(
                        fontSize: labelSize.sp,
                        color: disable != null && disable!
                            ? labelColor?.withValues(alpha: 0.2) ??
                                  SupportColors.white.withValues(alpha: 0.2)
                            : labelColor ?? SupportColors.white,
                        fontWeight: labelWeight ?? FontWeight.w500,
                      ),
                    ),
            ),
          ),
        );
    }
  }
}
