import 'package:flutter/material.dart';
import 'package:muzhiki_ui/effect/widgets/edge_dim_effect.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

final class MuzhikiEffect {
  const MuzhikiEffect();

  /// Затемнение границ сверху и снизу в стиле iOS AppBar / scroll edge.
  Widget edgeDim({
    Key? key,
    required Widget child,
    Color color = MuzhikiColors.black1,
    double topHeight = 48,
    double bottomHeight = 48,
    double topOpacity = 0.35,
    double bottomOpacity = 0.35,
    bool top = true,
    bool bottom = true,
    bool enabled = true,
  }) {
    return EdgeDimEffect(
      key: key,
      color: color,
      topHeight: topHeight,
      bottomHeight: bottomHeight,
      topOpacity: topOpacity,
      bottomOpacity: bottomOpacity,
      top: top,
      bottom: bottom,
      enabled: enabled,
      child: child,
    );
  }
}
