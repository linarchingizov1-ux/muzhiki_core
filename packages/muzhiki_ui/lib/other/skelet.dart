import 'package:flutter/material.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppSkelet extends StatelessWidget {
  final Widget child;

  /// `null` — автоматически по [MuzhikiColors.isDark].
  final bool? lightPage;
  final bool ignoreContainer;
  final bool enable;

  const AppSkelet({
    super.key,
    required this.child,
    this.lightPage,
    required this.enable,
    this.ignoreContainer = false,
  });

  @override
  Widget build(BuildContext context) {
    final useLightShimmer = lightPage ?? !MuzhikiColors.isDark;

    return Skeletonizer(
      ignoreContainers: ignoreContainer,
      ignorePointers: true,
      enabled: enable,
      effect: useLightShimmer
          ? RawShimmerEffect(
              colors: [
                MuzhikiColors.surface,
                MuzhikiColors.light,
              ],
            )
          : RawShimmerEffect(
              colors: [
                MuzhikiColors.blackOpticalZero,
                MuzhikiColors.grey,
              ],
            ),
      child: child,
    );
  }
}
