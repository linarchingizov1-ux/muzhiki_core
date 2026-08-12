import 'package:flutter/material.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';
import 'package:muzhiki_ui/effect/apple_scroll_edge.dart';
import 'package:muzhiki_ui/effect/widgets/soft_edge_effect.dart';

export 'apple_scroll_edge.dart';

final class MuzhikiEffect {
  const MuzhikiEffect();

  /// Soft progressive blur краёв в стиле iOS scroll edge.
  Widget softEdge({
    Key? key,
    required Widget child,
    bool top = true,
    bool bottom = true,
    bool left = false,
    bool right = false,
    double topSize = 100,
    double bottomSize = 100,
    double leftSize = 100,
    double rightSize = 100,
    double sigma = AppleScrollEdge.sigma,
    Color? tintColor,
    List<ControlPoint>? controlPoints,
    bool enabled = true,
  }) {
    return SoftEdgeEffect(
      key: key,
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      topSize: topSize,
      bottomSize: bottomSize,
      leftSize: leftSize,
      rightSize: rightSize,
      sigma: sigma,
      tintColor: tintColor,
      controlPoints: controlPoints,
      enabled: enabled,
      child: child,
    );
  }
}
