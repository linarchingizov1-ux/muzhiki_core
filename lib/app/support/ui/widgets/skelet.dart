import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppSkelet extends StatelessWidget {
  final Widget child;
  final bool lightPage;
  final bool ignoreContainer;
  final bool enable;
  const AppSkelet({
    super.key,
    required this.child,
    this.lightPage = true,
    required this.enable,
    this.ignoreContainer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      ignoreContainers: ignoreContainer,
      ignorePointers: true,
      enabled: enable,
      effect: !lightPage
          ? const RawShimmerEffect(
              colors: [
                Color.fromARGB(181, 42, 38, 38),
                Color.fromARGB(255, 123, 123, 123),
              ],
            )
          : const RawShimmerEffect(
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 208, 208, 208),
              ],
            ),
      child: child,
    );
  }
}
