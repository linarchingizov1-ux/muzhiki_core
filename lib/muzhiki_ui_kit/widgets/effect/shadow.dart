import 'package:flutter/material.dart';

class AppShadow extends StatelessWidget {
  final Alignment begin;
  final Alignment end;
  final List<Color> colors;
  const AppShadow({
    super.key,
    required this.begin,
    required this.end,
    this.colors = const [Color.fromARGB(180, 0, 0, 0), Color(0x00000000)],
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: begin, end: end, colors: colors),
          ),
        ),
      ),
    );
  }
}
