import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

class ChatSendFlight {
  ChatSendFlight._();

  static void play({
    required BuildContext context,
    required GlobalKey originKey,
    required String text,
  }) {
    if (text.trim().isEmpty) return;

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    final originContext = originKey.currentContext;
    if (overlay == null || originContext == null) return;

    final originBox = originContext.findRenderObject();
    if (originBox is! RenderBox || !originBox.hasSize) return;

    final origin = originBox.localToGlobal(Offset.zero);
    final size = originBox.size;
    final screen = MediaQuery.sizeOf(context);

    const duration = Duration(milliseconds: 420);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return _FlightBubble(
          origin: origin,
          originSize: size,
          screenSize: screen,
          text: text.trim(),
          duration: duration,
          onDone: () {
            entry.remove();
          },
        );
      },
    );

    overlay.insert(entry);
  }
}

class _FlightBubble extends StatefulWidget {
  final Offset origin;
  final Size originSize;
  final Size screenSize;
  final String text;
  final Duration duration;
  final VoidCallback onDone;

  const _FlightBubble({
    required this.origin,
    required this.originSize,
    required this.screenSize,
    required this.text,
    required this.duration,
    required this.onDone,
  });

  @override
  State<_FlightBubble> createState() => _FlightBubbleState();
}

class _FlightBubbleState extends State<_FlightBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _t = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    _controller.forward().whenComplete(() {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = widget.screenSize.width * 0.75;
    final start = widget.origin;
    final endX = widget.screenSize.width - 17.w - maxWidth;
    final endY = start.dy - 72.h;

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _t,
        builder: (context, child) {
          final t = _t.value;
          final dx = start.dx + (endX - start.dx) * t;
          final dy = start.dy + (endY - start.dy) * t - 18.h * (4 * t * (1 - t));
          final opacity = t < 0.75 ? 1.0 : (1 - (t - 0.75) / 0.25);
          final scale = 1 - (0.08 * t);

          return Stack(
            children: [
              Positioned(
                left: dx,
                top: dy,
                width: widget.originSize.width,
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Transform.scale(
                    alignment: Alignment.bottomRight,
                    scale: scale,
                    child: child,
                  ),
                ),
              ),
            ],
          );
        },
        child: Material(
          type: MaterialType.transparency,
          child: Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: MuzhikiColors.light,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Вы',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: MuzhikiColors.blood,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.text,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12.sp,
                        color: MuzhikiColors.isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }
}
