import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StoryProgressPainter extends CustomPainter {
  final Animation<double> storyProgress;
  final ValueListenable<int> currentIndex;
  final int storyCount;
  final double barGap;
  final Color trackColor;
  final Color valueColor;

  StoryProgressPainter({
    required this.storyProgress,
    required this.currentIndex,
    required this.storyCount,
    required this.barGap,
    required this.trackColor,
    required this.valueColor,
  }) : super(repaint: Listenable.merge([storyProgress, currentIndex]));

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = (size.width - barGap * (storyCount - 1)) / storyCount;
    final barRadius = Radius.circular(size.height / 2);
    final trackPaint = Paint()..color = trackColor;
    final valuePaint = Paint()..color = valueColor;

    for (var index = 0; index < storyCount; index++) {
      final left = index * (barWidth + barGap);
      final filled = index < currentIndex.value
          ? 1.0
          : index == currentIndex.value
          ? storyProgress.value
          : 0.0;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, 0, barWidth, size.height),
          barRadius,
        ),
        trackPaint,
      );
      if (filled > 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(left, 0, barWidth * filled, size.height),
            barRadius,
          ),
          valuePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(StoryProgressPainter oldDelegate) =>
      oldDelegate.storyCount != storyCount ||
      oldDelegate.barGap != barGap ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.valueColor != valueColor;
}
