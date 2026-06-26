import 'package:flutter/material.dart';

class DotsIndicatorWidgets extends StatelessWidget {
  final int count;
  final int currentIndex;
  final double dotSize;
  final double activeDotWidth;
  final double spacing;
  final Color dotColor;
  final Color activeDotColor;
  final ValueChanged<int>? onTap;

  const DotsIndicatorWidgets({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.dotColor,
    required this.activeDotColor,
    this.dotSize = 10,
    this.activeDotWidth = 20,
    this.spacing = 6,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;

        return GestureDetector(
          onTap: onTap == null ? null : () => onTap!(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            height: dotSize,
            width: isActive ? activeDotWidth : dotSize,
            decoration: BoxDecoration(
              color: isActive ? activeDotColor : dotColor,
              borderRadius: BorderRadius.circular(dotSize),
            ),
          ),
        );
      }),
    );
  }
}
