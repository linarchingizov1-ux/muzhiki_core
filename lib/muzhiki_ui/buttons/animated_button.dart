import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

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

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isPopping = false;

  GoRouter? _router;
  VoidCallback? _routerListener;

  double _getScale() {
    if (widget.child != null) {
      return 1.05;
    }

    return 1.12;
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 450),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: _getScale()).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final router = GoRouter.of(context);

    if (identical(_router, router)) {
      return;
    }

    _removeRouterListener();

    _router = router;

    _routerListener = () {
      _resetPressState();
    };

    router.routerDelegate.addListener(_routerListener!);
  }

  @override
  void dispose() {
    _removeRouterListener();
    _controller.dispose();

    super.dispose();
  }

  void _removeRouterListener() {
    final router = _router;
    final listener = _routerListener;

    if (router != null && listener != null) {
      router.routerDelegate.removeListener(listener);
    }

    _router = null;
    _routerListener = null;
  }

  void _resetPressState() {
    if (!mounted) return;

    _isPopping = false;

    _controller
      ..stop()
      ..value = 0.0;
  }

  void _onTapDown(TapDownDetails details) {
    if (_isPopping) return;

    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) async {
    if (_isPopping) return;

    _isPopping = true;

    try {
      final animation = _controller.forward();

      await _waitAnimationProgress(0.5);

      if (mounted) {
        widget.onTap();
      }

      await animation;

      if (mounted) {
        await _controller.reverse();
      }
    } finally {
      _isPopping = false;
    }
  }

  Future<void> _waitAnimationProgress(double value) {
    final completer = Completer<void>();

    void listener() {
      if (_controller.value >= value) {
        _controller.removeListener(listener);
        completer.complete();
      }
    }

    _controller.addListener(listener);

    return completer.future;
  }

  void _onTapCancel() {
    if (_isPopping) return;

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
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: widget.child ?? _defaultButton(),
      ),
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
