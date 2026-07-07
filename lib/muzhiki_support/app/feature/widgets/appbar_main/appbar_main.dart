import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_assets.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/appbar_main/menu.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/skelet.dart';

class SupportAppBar extends StatefulWidget {
  final SessionApp sessionApp;
  final void Function()? firebaseRemoveFCM;
  const SupportAppBar({
    super.key,
    required this.sessionApp,
    this.firebaseRemoveFCM,
  });

  @override
  State<SupportAppBar> createState() => _SupportAppBarState();
}

class _SupportAppBarState extends State<SupportAppBar> {
  final GlobalKey _menuKey = GlobalKey();
  bool _menuTapLocked = false;

  Future<void> _openMenu(BuildContext context) async {
    if (_menuTapLocked) return;
    if (DialogMenu.isShowing) return;

    _menuTapLocked = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        _menuTapLocked = false;
        return;
      }

      final rect = getWidgetRectSafe(_menuKey);
      if (rect == null) {
        _menuTapLocked = false;
        return;
      }

      try {
        await DialogMenu.showAnimationTopMenu(
          firebaseRemoveFCM: widget.firebaseRemoveFCM,
          sessionApp: widget.sessionApp,
          context: context,
          anchorRect: rect,
        );
      } finally {
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 120), () {
            if (mounted) {
              _menuTapLocked = false;
            }
          });
        } else {
          _menuTapLocked = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 20.h,
        left: 17.w,
        right: 17.w,
      ),
      child: SizedBox(
        height: 44.h,
        child: Row(
          children: [
            Container(
              key: _menuKey,
              width: 40.h,
              height: 40.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: SupportColors.blood,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => _openMenu(context),
                child: Center(
                  child: SvgPicture.asset(SupportAssets.I.svg.dashboard),
                ),
              ),
            ),
            SizedBox(width: 13.w),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: AppSkelet(
                      enable: widget.sessionApp.user == null,
                      child: Text(
                        widget.sessionApp.user?.username ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: SupportColors.black17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.sessionApp.user != null &&
                widget.sessionApp.user!.roles != null)
              Text(
                widget.sessionApp.user!.roles!.currentRole.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: SupportColors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DialogMenu {
  static bool _isShowing = false;
  static bool _isClosing = false;

  static bool get isShowing => _isShowing;

  static Future<void> showAnimationTopMenu({
    required BuildContext context,
    required Rect anchorRect,
    required SessionApp sessionApp,
    required void Function()? firebaseRemoveFCM,
  }) async {
    if (_isShowing || _isClosing) return;

    _isShowing = true;

    try {
      await showGeneralDialog(
        context: context,
        useRootNavigator: true,
        barrierDismissible: true,
        barrierLabel: 'menu',
        barrierColor: const Color.fromARGB(86, 0, 0, 0),
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, _, _) => const SizedBox.shrink(),
        transitionBuilder: (dialogContext, anim, _, _) {
          final a = toOverlayRect(context, anchorRect);

          if (anim.status == AnimationStatus.reverse ||
              anim.status == AnimationStatus.dismissed) {
            return const SizedBox.shrink();
          }

          final tOpen = Curves.easeOutCubic.transform(anim.value);
          final tContent = Curves.easeOutCubic.transform(
            const Interval(0.18, 1).transform(anim.value),
          );

          Widget appear(Widget w, {Offset from = Offset.zero}) {
            return Opacity(
              opacity: tContent,
              child: Transform.translate(
                offset: Offset(
                  from.dx * (1 - tContent),
                  from.dy * (1 - tContent),
                ),
                child: w,
              ),
            );
          }

          final menuPadding = EdgeInsets.only(
            top: a.bottom + 14.h,
            left: 17.w,
            right: 17.w,
            bottom: 20.h,
          );

          void closeDialog() {
            if (_isClosing) return;
            _isClosing = true;

            final navigator = Navigator.of(dialogContext, rootNavigator: true);
            if (navigator.canPop()) {
              navigator.pop();
            }

            Future.microtask(() {
              _isClosing = false;
            });
          }

          return Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CircleReveal(
                    t: tOpen,
                    center: a.center,
                    child: Padding(
                      padding: menuPadding,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appear(
                            DashboardMenuBottomWidgets(
                              sessionApp: sessionApp,
                              firebaseRemoveFCM: firebaseRemoveFCM,
                            ),
                            from: const Offset(0, 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned.fromRect(
                  rect: a,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: SupportColors.appBackgroud,
                    ),
                    child: Material(
                      color: Colors.red,
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: closeDialog,
                        child: Center(
                          child: SvgPicture.asset(
                            SupportAssets.I.svg.dashboard,
                            colorFilter: const ColorFilter.mode(
                              SupportColors.darkGrey,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: a.top,
                  left: a.right + 12.w,
                  height: a.height,
                  child: appear(
                    SupportAppBarMenu(sessionApp: sessionApp),
                    from: const Offset(-12, 0),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } finally {
      _isShowing = false;
      _isClosing = false;
    }
  }
}

class CircleReveal extends StatelessWidget {
  const CircleReveal({
    super.key,
    required this.t,
    required this.center,
    required this.child,
  });

  final double t;
  final Offset center;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    final radius = lerpDouble(
      0,
      screenSize.longestSide * 1.15,
      math.pow(Curves.easeInOutSine.transform(t), 1.2).toDouble(),
    )!;

    return ClipPath(
      clipper: _CircleClipper(center: center, radius: radius),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            color: SupportColors.black17,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18.r),
              bottomRight: Radius.circular(18.r),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _CircleClipper extends CustomClipper<Path> {
  _CircleClipper({required this.center, required this.radius});

  final Offset center;
  final double radius;

  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(covariant _CircleClipper oldClipper) {
    return oldClipper.center != center || oldClipper.radius != radius;
  }
}

Rect? getWidgetRectSafe(GlobalKey key) {
  final context = key.currentContext;
  if (context == null) return null;

  final renderObject = context.findRenderObject();
  if (renderObject is! RenderBox) return null;
  if (!renderObject.hasSize) return null;

  final topLeft = renderObject.localToGlobal(Offset.zero);
  return topLeft & renderObject.size;
}

Rect toOverlayRect(BuildContext context, Rect globalRect) {
  final overlay = Overlay.of(context, rootOverlay: true);
  final overlayBox = overlay.context.findRenderObject() as RenderBox;
  final overlayTopLeft = overlayBox.localToGlobal(Offset.zero);
  return globalRect.shift(-overlayTopLeft);
}
