import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

/// Затемнение верхнего и нижнего края, как у iOS AppBar / scroll edge.
class EdgeDimEffect extends StatelessWidget {
  const EdgeDimEffect({
    super.key,
    required this.child,
    this.color = MuzhikiColors.black1,
    this.topHeight = 48,
    this.bottomHeight = 48,
    this.topOpacity = 0.35,
    this.bottomOpacity = 0.35,
    this.top = true,
    this.bottom = true,
    this.enabled = true,
  });

  final Widget child;
  final Color color;
  final double topHeight;
  final double bottomHeight;
  final double topOpacity;
  final double bottomOpacity;
  final bool top;
  final bool bottom;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled || (!top && !bottom)) return child;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        if (top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topHeight.h,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withValues(alpha: topOpacity),
                      color.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: bottomHeight.h,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      color.withValues(alpha: bottomOpacity),
                      color.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
