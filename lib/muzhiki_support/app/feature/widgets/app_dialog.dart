import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_core.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';

class AppDialog {
  static Future<T?> standart<T>({
    required Widget child,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
    bool canPop = true,
  }) async {
    final context = MuzhikiDependencies.I.routerKey.currentContext;
    if (context == null) return null;

    return await showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.ease,
        reverseCurve: Curves.easeIn,
        duration: const Duration(milliseconds: 350),
        reverseDuration: const Duration(milliseconds: 250),
      ),
      builder: (_) {
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
                  color: SupportColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      MuzhikiDependencies.I.divesRadius?.bottomLeft ?? 32.r,
                    ),
                  ),
                ),
                child: child,
              ),
            ),
          );
        } else {
          return PopScope(
            canPop: canPop,
            child:
                Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: SupportColors.white,
                          borderRadius: BorderRadius.circular(40.r),
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
        }
      },
    );
  }

  static Future<bool?> needUpdate({required Widget child}) {
    final context = MuzhikiDependencies.I.routerKey.currentContext;
    if (context == null) return Future.value(null);
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.zero),
      backgroundColor: SupportColors.appBackgroud,
      context: context,
      isDismissible: true,
      enableDrag: false,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).padding.bottom + 20.h,
          ),
          child: PopScope(canPop: false, child: child),
        );
      },
    );
  }
}
