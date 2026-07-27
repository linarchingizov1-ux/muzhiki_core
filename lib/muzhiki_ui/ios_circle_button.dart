import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class IOSPressButton extends StatefulWidget {
  const IOSPressButton({
    required this.onTap,
    super.key,
    this.svgAsset,
    this.icon,
    this.size = 40,
    this.iconSize = 16,
    this.child,
    this.backgroundColor,
  });

  final String? svgAsset;
  final IconData? icon;
  final VoidCallback onTap;
  final Widget? child;

  final double size;
  final double iconSize;
  final Color? backgroundColor;

  @override
  State<IOSPressButton> createState() => _IOSPressButtonState();
}

class _IOSPressButtonState extends State<IOSPressButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isPopping = false;

  GoRouter? _router;
  VoidCallback? _routerListener;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      reverseDuration: const Duration(milliseconds: 140),
      value: 0.0,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInOutCubic,
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
      ..value = 1.0;
  }

  void _onTapDown(TapDownDetails details) {
    if (_isPopping) return;

    _controller.forward();
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    if (_isPopping) return;

    _isPopping = true;

    await _controller.reverse();

    if (!mounted) return;

    widget.onTap();
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
        child: Container(
          width: widget.size.r,
          height: widget.size.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.backgroundColor,
          ),
          alignment: Alignment.center,
          child: widget.child != null
              ? widget.child!
              : widget.svgAsset != null
              ? SvgPicture.asset(
                  widget.svgAsset!,
                  width: widget.iconSize.r,
                  height: widget.iconSize.r,
                )
              : Icon(widget.icon, size: widget.iconSize.r, color: Colors.white),
        ),
      ),
    );
  }
}
