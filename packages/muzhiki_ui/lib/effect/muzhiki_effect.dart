import 'package:flutter/material.dart';
import 'package:muzhiki_ui/effect/widgets/soft_edge_effect.dart';

final class MuzhikiEffect {
  const MuzhikiEffect();

  /// Soft progressive blur краёв (через soft_edge_blur), как у iOS scroll edge.
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
    double sigma = 30,
    Color? tintColor,
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
      enabled: enabled,
      child: child,
    );
  }
}
