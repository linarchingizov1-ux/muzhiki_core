import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

class SoftEdgeEffect extends StatelessWidget {
  const SoftEdgeEffect({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = false,
    this.right = false,
    this.topSize = 100,
    this.bottomSize = 100,
    this.leftSize = 100,
    this.rightSize = 100,
    this.sigma = 30,
    this.tintColor,
    this.enabled = true,
  });

  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final double topSize;
  final double bottomSize;
  final double leftSize;
  final double rightSize;
  final double sigma;
  final Color? tintColor;
  final bool enabled;

  List<ControlPoint> get _defaultControlPoints => [
     ControlPoint(position: 0.5, type: ControlPointType.visible),
     ControlPoint(position: 1, type: ControlPointType.transparent),
  ];

  EdgeBlur _edge({
    required EdgeType type,
    required double size,
  }) {
    return EdgeBlur(
      type: type,
      size: size,
      sigma: sigma,
      tintColor: tintColor,
      controlPoints: _defaultControlPoints,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!enabled || (!top && !bottom && !left && !right)) {
      return child;
    }

    return SoftEdgeBlur(
      edges: [
        if (top) _edge(type: EdgeType.topEdge, size: topSize.h),
        if (bottom) _edge(type: EdgeType.bottomEdge, size: bottomSize.h),
        if (left) _edge(type: EdgeType.leftEdge, size: leftSize.w),
        if (right) _edge(type: EdgeType.rightEdge, size: rightSize.w),
      ],
      child: child,
    );
  }
}
