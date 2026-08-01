import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/notification.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/skelet.dart';

class ChoiceWidgets extends StatefulWidget {
  final bool isSelected;
  final bool isLoading;
  final String label;
  final int newMessage;
  final ValueChanged<bool>? onSelected;

  const ChoiceWidgets({
    super.key,
    this.newMessage = 0,
    this.isLoading = false,
    required this.onSelected,
    required this.isSelected,
    required this.label,
  });

  @override
  State<ChoiceWidgets> createState() => _ChoiceWidgetsState();
}

class _ChoiceWidgetsState extends State<ChoiceWidgets>
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
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 260),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
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

      await Future.delayed(const Duration(milliseconds: 50));

      if (mounted && widget.onSelected != null) {
        widget.onSelected!(!widget.isSelected);
      }

      await animation;

      if (mounted) {
        await _controller.reverse();
      }
    } finally {
      _isPopping = false;
    }
  }

  void _onTapCancel() {
    if (_isPopping) return;

    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AppSkelet(
      enable: widget.isLoading,
      ignoreContainer: true,
      child: GestureDetector(
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
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48.r),
              color: widget.isSelected
                  ? SupportColors.black1
                  : SupportColors.light,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10.w,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: widget.isSelected
                        ? SupportColors.white
                        : SupportColors.black1,
                  ),
                ),
                if (widget.newMessage > 0)
                  NotificationWidgets(count: widget.newMessage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
