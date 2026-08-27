import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/dialog/widgets/delete_account_dialog.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

final class MuzhikiDialog {
  const MuzhikiDialog();

  static GlobalKey<NavigatorState>? _navigatorKey;
  static double Function()? _bottomSheetBottomRadius;

  void configure({
    required GlobalKey<NavigatorState> navigatorKey,
    double Function()? bottomSheetBottomRadius,
  }) {
    _navigatorKey = navigatorKey;
    _bottomSheetBottomRadius = bottomSheetBottomRadius;
  }

  BuildContext? _context([BuildContext? context]) {
    return context ?? _navigatorKey?.currentContext;
  }

  double _bottomRadius() {
    return _bottomSheetBottomRadius?.call() ?? 32.r;
  }

  double _bottomGap(BuildContext context, double base) {
    if (Platform.isIOS) return base;
    return MediaQuery.viewPaddingOf(context).bottom + base;
  }

  Future<T?> standart<T>({
    required Widget child,
    BuildContext? context,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
    bool canPop = true,
    Color? backgroundColor,
  }) async {
    final sheetContext = _context(context);
    if (sheetContext == null) return null;

    return showModalBottomSheet<T>(
      useSafeArea: !Platform.isIOS,
      context: sheetContext,
      isScrollControlled: true,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.easeInOutCubic,
        reverseCurve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 250),
        reverseDuration: const Duration(milliseconds: 350),
      ),
      builder: (context) {
        final sheetColor = backgroundColor ?? MuzhikiColors.surface;

        if (height != null) {
          return PopScope(
            canPop: false,
            child: FractionallySizedBox(
              heightFactor: height,
              child: Container(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 20.h,
                  bottom: 20.h,
                ),
                decoration: BoxDecoration(
                  color: sheetColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(22.r),
                    bottom: Radius.circular(_bottomRadius()),
                  ),
                ),
                child: child,
              ),
            ),
          );
        }

        return PopScope(
          canPop: canPop,
          child:
              Padding(
                    padding: EdgeInsets.only(
                      left: 8.w,
                      right: 8.w,
                      bottom: _bottomGap(context, 8.w),
                      top: 8.w,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: sheetColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(35.r),
                          bottom: Radius.circular(_bottomRadius()),
                        ),
                      ),
                      child: child,
                    ),
                  )
                  .animate()
                  .fade(duration: 250.ms, curve: Curves.easeOut)
                  .moveY(
                    begin: 20,
                    end: 0,
                    duration: 350.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .scale(
                    begin: const Offset(0.97, 0.97),
                    end: const Offset(1, 1),
                    duration: 350.ms,
                    curve: Curves.easeOutCubic,
                  ),
        );
      },
    );
  }

  Future<bool?> needUpdate({
    required Widget child,
    BuildContext? context,
    Color? backgroundColor,
  }) {
    final sheetContext = _context(context);
    if (sheetContext == null) return Future.value(null);

    return showModalBottomSheet<bool>(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: backgroundColor ?? MuzhikiColors.appBackgroud,
      context: sheetContext,
      isDismissible: true,
      enableDrag: false,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: !Platform.isIOS,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: _bottomGap(context, 20.h),
          ),
          child: PopScope(canPop: false, child: child),
        );
      },
    );
  }

  Future<bool?> removeAccountDialog({
    required VoidCallback onOpenDetails,
    BuildContext? context,
    bool isDismissible = true,
    bool enableDrag = true,
    bool canPop = true,
    Color? backgroundColor,
  }) {
    return standart<bool>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      canPop: canPop,
      backgroundColor: backgroundColor,
      child: DeleteAccountDialog(onOpenDetails: onOpenDetails),
    );
  }
}
