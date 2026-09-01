import 'package:flutter/material.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';
import 'package:muzhiki_ui/effect/apple_scroll_edge.dart';

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
    this.sigma = AppleScrollEdge.sigma,
    this.tintColor,
    this.controlPoints,
    this.enabled = true,
  });

  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  /// Высота/ширина зоны blur в logical pixels (без доп. ScreenUtil).
  final double topSize;
  final double bottomSize;
  final double leftSize;
  final double rightSize;
  final double sigma;
  final Color? tintColor;
  final List<ControlPoint>? controlPoints;
  final bool enabled;

  EdgeBlur _edge({
    required EdgeType type,
    required double size,
  }) {
    return EdgeBlur(
      type: type,
      size: size,
      sigma: sigma,
      tintColor: tintColor,
      controlPoints: controlPoints ?? AppleScrollEdge.controlPoints,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!enabled || (!top && !bottom && !left && !right)) {
      return child;
    }

    return SoftEdgeBlur(
      edges: [
        if (top) _edge(type: EdgeType.topEdge, size: topSize),
        if (bottom) _edge(type: EdgeType.bottomEdge, size: bottomSize),
        if (left) _edge(type: EdgeType.leftEdge, size: leftSize),
        if (right) _edge(type: EdgeType.rightEdge, size: rightSize),
      ],
      child: child,
    );
  }
}
