import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      reverseDuration: const Duration(milliseconds: 140),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_isAnimating || widget.onSelected == null) return;

    _isAnimating = true;

    widget.onSelected!(!widget.isSelected);

    _controller.forward(from: 0).then((_) async {
      if (!mounted) return;

      await _controller.reverse();

      if (mounted) {
        _isAnimating = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppSkelet(
      enable: widget.isLoading,
      ignoreContainer: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 11.h),
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
