import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/buttons/muzhiki_buttons.dart';
import 'package:muzhiki_ui/effect/muzhiki_effect.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';
import 'package:muzhiki_ui/theme/muzhiki_fonts.dart';

class SoftEdgeScaffoldMetrics {
  const SoftEdgeScaffoldMetrics({
    required this.headerHeight,
    required this.topInset,
    required this.bottomInset,
  });

  final double headerHeight;
  final double topInset;
  final double bottomInset;
}

class SoftEdgeScaffold extends StatelessWidget {
  const SoftEdgeScaffold({
    super.key,
    required this.bodyBuilder,
    this.title,
    this.titleWidget,
    this.onBack,
    this.backEnabled = true,
    this.backIconColor,
    this.leading,
    this.svgAssets,
    this.trailing,
    this.bottomBar,
    this.bottomBarPadding,
    this.backgroundColor = MuzhikiColors.appBackgroudLight,
    this.tintColor,
    this.topBlur = true,
    this.bottomBlur = true,
    this.topBlurSize,
    this.bottomBlurSize,
    this.sigma,
    this.headerTopPadding,
    this.headerBottomPadding,
    this.headerHorizontalPadding,
    this.resizeToAvoidBottomInset = false,
    this.enable = true,
    this.enableBackdropFilter = false,
  });

  final Widget Function(BuildContext context, SoftEdgeScaffoldMetrics metrics)
  bodyBuilder;

  final String? title;
  final Widget? titleWidget;
  final VoidCallback? onBack;
  final bool backEnabled;
  final Color? backIconColor;
  final Widget? leading;
  final Widget? trailing;
  final Widget? bottomBar;
  final EdgeInsetsGeometry? bottomBarPadding;

  final Color backgroundColor;
  final Color? tintColor;
  final bool topBlur;
  final bool bottomBlur;
  final double? topBlurSize;
  final double? bottomBlurSize;
  final double? sigma;
  final String? svgAssets;
  final double? headerTopPadding;
  final double? headerBottomPadding;
  final bool enable;
  final EdgeInsetsGeometry? headerHorizontalPadding;
  final bool resizeToAvoidBottomInset;
  final bool enableBackdropFilter;

  static const _buttons = MuzhikiButtons();
  static const _effect = MuzhikiEffect();

  Widget? _buildLeading() {
    if (leading != null) return leading;
    if (onBack == null) return null;

    return _buttons.back(
      svgAsset: svgAssets,
      onTap: onBack!,
      backgroundColor: MuzhikiColors.isDark
          ? MuzhikiColors.surface
          : MuzhikiColors.grey,
      enabled: backEnabled,
      enableBackdropFilter: enableBackdropFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    MuzhikiColors.depend(context);
    final pageColor = backgroundColor == MuzhikiColors.appBackgroudLight
        ? MuzhikiColors.appBackgroud
        : backgroundColor;
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final headerTop = headerTopPadding ?? 8.h;
    final headerBottom = headerBottomPadding ?? 12.h;
    final headerHeight = topInset + headerTop + 40.r + headerBottom;

    final resolvedTopBlur = topBlurSize ?? (headerHeight + 28);
    final resolvedBottomBlur =
        bottomBlurSize ?? (bottomInset + (bottomBar != null ? 72 : 36));

    final metrics = SoftEdgeScaffoldMetrics(
      headerHeight: headerHeight,
      topInset: topInset,
      bottomInset: bottomInset,
    );

    final leadingWidget = _buildLeading();
    final edgeTint = AppleScrollEdge.defaultTint(
      tintColor: tintColor,
      backgroundColor: pageColor,
    );

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: pageColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: _effect.softEdge(
              enabled: enable,
              top: topBlur,
              bottom: bottomBlur,
              left: false,
              right: false,
              topSize: resolvedTopBlur,
              bottomSize: resolvedBottomBlur,
              tintColor: edgeTint,
              sigma: sigma ?? AppleScrollEdge.sigma,
              controlPoints: AppleScrollEdge.controlPoints,
              child: bodyBuilder(context, metrics),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(top: headerTop, bottom: headerBottom)
                    .add(
                      headerHorizontalPadding ??
                          EdgeInsets.only(left: 16.w, right: 20.w),
                    ),
                child: SizedBox(
                  height: 40.r,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (titleWidget != null)
                        titleWidget!
                      else if (title != null)
                        Text(
                          title!,
                          textAlign: TextAlign.center,
                          style: MuzhikiFonts.manropeStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: MuzhikiColors.black23,
                          ),
                        ),
                      if (leadingWidget != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: leadingWidget,
                        ),
                      if (trailing != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: trailing!,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (bottomBar != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding:
                      bottomBarPadding ??
                      EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                  child: bottomBar!,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
