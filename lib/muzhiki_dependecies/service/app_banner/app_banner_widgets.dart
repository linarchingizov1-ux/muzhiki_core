import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBannerWidgets extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;
  final Duration duration;
  final Color color;

  const AppBannerWidgets({
    super.key,
    required this.message,
    required this.onDismiss,
    required this.duration,
    this.color = Colors.grey,
  });

  @override
  State<AppBannerWidgets> createState() => _AppBannerWidgetsState();
}

class _AppBannerWidgetsState extends State<AppBannerWidgets>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animationTranslate;
  late Animation<double> animationOpacity;
  late AnimationController dragBackAnimationController;
  Animation<double>? dragBackAnimation;

  final ValueNotifier<double> dragOffset = ValueNotifier(0);
  final ValueNotifier<bool> startedDraggingUp = ValueNotifier(false);

  Timer? timerDialog;
  late Duration remaining;
  DateTime? startTimeDialog;

  @override
  void initState() {
    super.initState();

    remaining = widget.duration;

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    animationTranslate = Tween<double>(begin: -120, end: 0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic),
    );
    dragBackAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    animationOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animationController);

    animationController.forward();

    startTimer();
  }

  void startTimer() {
    startTimeDialog = DateTime.now();

    timerDialog = Timer(remaining, close);
  }

  void pauseTimer() {
    if (timerDialog == null || startTimeDialog == null) return;

    timerDialog!.cancel();

    final elapsed = DateTime.now().difference(startTimeDialog!);
    remaining -= elapsed;

    if (remaining.isNegative) {
      remaining = Duration.zero;
    }
  }

  void back() {
    dragBackAnimation =
        Tween<double>(begin: dragOffset.value, end: 0).animate(
          CurvedAnimation(
            parent: dragBackAnimationController,
            curve: Curves.easeOutCubic,
          ),
        )..addListener(() {
          dragOffset.value = dragBackAnimation!.value;
        });

    dragBackAnimationController
      ..reset()
      ..forward();

    startedDraggingUp.value = false;
  }

  void resumeTimer() {
    if (remaining == Duration.zero) {
      close();
      return;
    }
    startTimer();
  }

  void close() async {
    timerDialog?.cancel();
    await animationController.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    animationController.dispose();
    timerDialog?.cancel();
    dragOffset.dispose();
    startedDraggingUp.dispose();
    dragBackAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTapDown: (_) => pauseTimer(),
          onTapUp: (_) => resumeTimer(),
          onTapCancel: resumeTimer,

          onVerticalDragStart: (_) => pauseTimer(),
          onVerticalDragEnd: (details) {
            resumeTimer();

            if (details.primaryVelocity != null &&
                details.primaryVelocity! < -500) {
              close();
              return;
            }

            if (dragOffset.value < -70) {
              close();
            } else {
              back();
            }
          },
          onVerticalDragUpdate: (details) {
            final dy = details.delta.dy;

            if (!startedDraggingUp.value) {
              if (dy < 0) {
                startedDraggingUp.value = true;
                dragOffset.value += dy;
              }
              return;
            }

            dragOffset.value += dy;
          },

          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return ValueListenableBuilder<double>(
                valueListenable: dragOffset,
                builder: (context, offset, _) {
                  final translateY = animationTranslate.value + offset;

                  return Transform.translate(
                    offset: Offset(0, translateY),
                    child: Opacity(
                      opacity:
                          (animationOpacity.value *
                                  (1 - (offset.abs() / 180)).clamp(0.0, 1.0))
                              .clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Text(
                widget.message,
                maxLines: 4,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
