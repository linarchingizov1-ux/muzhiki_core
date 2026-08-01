import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_svg/flutter_svg.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    required this.onTap,
    this.child,
    this.svgAsset,
    this.icon,
    this.size = 56,
    this.iconSize = 24,
    this.iconColor = Colors.white,
    this.backgroundColor,
    this.enableScale = true,
  });

  final VoidCallback onTap;

  final Widget? child;

  final String? svgAsset;
  final IconData? icon;

  final double size;
  final double iconSize;

  final Color iconColor;
  final Color? backgroundColor;

  final bool enableScale;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scale;

  bool _locked = false;

  GoRouter? _router;
  VoidCallback? _routerListener;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 220),
    );

    _scale = Tween<double>(begin: 1, end: 0.94).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final router = GoRouter.of(context);

    if (identical(router, _router)) {
      return;
    }

    _removeRouterListener();

    _router = router;

    _routerListener = () {
      _reset();
    };

    router.routerDelegate.addListener(_routerListener!);
  }

  void _reset() {
    if (!mounted) return;

    _locked = false;

    _controller
      ..stop()
      ..value = 0;
  }

  void _removeRouterListener() {
    if (_router != null && _routerListener != null) {
      _router!.routerDelegate.removeListener(_routerListener!);
    }

    _router = null;
    _routerListener = null;
  }

  void _onTapDown(TapDownDetails details) {
    if (_locked) return;

    if (widget.enableScale) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (_locked) return;

    _locked = true;

    // iOS style press delay
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!mounted) return;

      widget.onTap();
    });

    // если экран не уйдет - красиво вернуть
    Future.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;

      _controller.reverse();

      _locked = false;
    });
  }

  void _onTapCancel() {
    if (_locked) return;

    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,

      child: AnimatedBuilder(
        animation: _scale,

        builder: (context, child) {
          return Transform.scale(scale: _scale.value, child: child);
        },

        child: widget.child ?? _defaultButton(),
      ),
    );
  }

  Widget _defaultButton() {
    return Container(
      width: widget.size,
      height: widget.size,

      alignment: Alignment.center,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.backgroundColor,
      ),

      child: widget.svgAsset != null
          ? SvgPicture.asset(
              widget.svgAsset!,
              width: widget.iconSize,
              height: widget.iconSize,
              colorFilter: ColorFilter.mode(widget.iconColor, BlendMode.srcIn),
            )
          : Icon(widget.icon, size: widget.iconSize, color: widget.iconColor),
    );
  }

  @override
  void dispose() {
    _removeRouterListener();

    _controller.dispose();

    super.dispose();
  }
}
