import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_bounceable/flutter_bounceable.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    required this.onTap,
    super.key,
    this.svgAsset,
    this.icon,
    required this.size,
    required this.iconSize,
    required this.iconColor,
    this.child,
    this.isGlasses = false,
    this.backgroundColor,
  });

  final String? svgAsset;
  final bool isGlasses;
  final IconData? icon;
  final Color iconColor;
  final VoidCallback onTap;
  final Widget? child;

  final double size;
  final double iconSize;
  final Color? backgroundColor;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _getScale() {
    if (widget.child != null) {
      return 1.05;
    }

    return 1.12;
  }

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      scaleFactor: _getScale() - 1,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 250),

      onTap: widget.onTap,

      child: widget.child ?? _defaultButton(),
    );
  }

  Widget _defaultButton() {
    return Container(
      width: widget.size.r,
      height: widget.size.r,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.backgroundColor,
      ),

      alignment: Alignment.center,

      child: widget.svgAsset != null
          ? SvgPicture.asset(
              widget.svgAsset!,
              width: widget.iconSize.r,
              height: widget.iconSize.r,
              colorFilter: ColorFilter.mode(widget.iconColor, BlendMode.srcIn),
            )
          : Icon(widget.icon, size: widget.iconSize.r, color: widget.iconColor),
    );
  }
}
