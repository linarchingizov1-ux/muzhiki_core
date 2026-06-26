import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mp_master_app/src/core/config/color/app_colors.dart';
import 'package:mp_master_app/src/features/widgets/interface/measure.dart';

class AppDraggable extends StatefulWidget {
  final Widget? appbar;
  final Widget? header;
  final Widget? background;
  final double? backgroundImageSize;
  final bool onScale;
  final Widget sheet;
  final bool isDraggable;
  final Color? headerColor;
  final Color backgroundColor;
  final Future<void> Function()? onRefresh;

  const AppDraggable({
    this.backgroundImageSize,
    this.background,
    this.isDraggable = true,
    this.headerColor,
    this.backgroundColor = AppColors.white,
    super.key,
    this.appbar,
    this.onRefresh,
    this.onScale = true,
    this.header,
    required this.sheet,
  });

  @override
  State<AppDraggable> createState() => _AppDraggableState();
}

class _AppDraggableState extends State<AppDraggable> {
  final progress = ValueNotifier<double>(0);
  final minSize = ValueNotifier<double>(0);
  final maxSize = ValueNotifier<double>(0);
  final controller = DraggableScrollableController();
  double? headerHeight;
  double appBarHeight = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onDrag);
  }

  @override
  void dispose() {
    controller.removeListener(_onDrag);
    minSize.dispose();
    progress.dispose();
    controller.dispose();
    super.dispose();
  }

  void _onDrag() {
    final current = controller.size;

    final p = ((current - minSize.value) / (maxSize.value - minSize.value))
        .clamp(0.0, 1.0);
    progress.value = p > 0.99 ? 1.0 : p;
  }

  void _recalculateSizes(BoxConstraints constraints) {
    final currentAppBarHeight = widget.appbar == null ? 0.0 : appBarHeight;

    final max =
        (constraints.maxHeight - currentAppBarHeight) / constraints.maxHeight;

    maxSize.value = max.clamp(0.0, 1.0);

    if (headerHeight != null) {
      final min =
          (constraints.maxHeight - currentAppBarHeight - headerHeight!) /
          constraints.maxHeight;

      minSize.value = min.clamp(0.0, 1.0);
    }
    if (widget.backgroundImageSize != null) {
      final min =
          (constraints.maxHeight - widget.backgroundImageSize!) /
          constraints.maxHeight;

      minSize.value = min.clamp(0.0, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (widget.appbar == null && maxSize.value == 0) {
          _recalculateSizes(constraints);
        }

        return Stack(
          children: [
            if (widget.headerColor != null)
              Positioned.fill(child: ColoredBox(color: widget.headerColor!)),
            if (widget.background != null)
              Positioned(
                height: widget.backgroundImageSize,
                top: 0,
                left: 0,
                right: 0,
                child: widget.onScale
                    ? _ScaleAnimated(
                        valueListenable: progress,
                        child: widget.background!,
                      )
                    : widget.background!,
              ),
            if (widget.headerColor != null)
              Positioned.fill(
                child: ValueListenableBuilder<double>(
                  valueListenable: progress,
                  builder: (context, value, child) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          radius: 0.2,
                          colors: [
                            widget.headerColor!.withValues(alpha: value * 0.2),
                            widget.headerColor!.withValues(alpha: value),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            RefreshIndicator.noSpinner(
              onRefresh: widget.onRefresh ?? () async {},
              child: SingleChildScrollView(
                physics: widget.isDraggable == false
                    ? const NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                child: Column(
                  children: [
                    if (widget.appbar != null)
                      MeasureSize(
                        onChange: (size) {
                          appBarHeight = size.height;
                          _recalculateSizes(constraints);
                        },
                        child: widget.appbar!,
                      ),
                    if (widget.header != null)
                      MeasureSize(
                        onChange: (size) {
                          headerHeight = size.height;
                          _recalculateSizes(constraints);
                        },
                        child: widget.onScale
                            ? _ScaleAnimated(
                                valueListenable: progress,
                                child: widget.header!,
                              )
                            : widget.header!,
                      ),
                  ],
                ),
              ),
            ),

            ValueListenableBuilder<double>(
              valueListenable: minSize,
              builder: (context, min, child) {
                return ValueListenableBuilder(
                  valueListenable: maxSize,
                  builder: (context, max, child) {
                    if (min == 0 || max == 0) {
                      return const SizedBox.shrink();
                    }
                    final needOver =
                        widget.appbar == null ||
                        widget.appbar != null && widget.background != null;
                    final minS = !needOver ? min : min + 0.03.h;
                    if (widget.isDraggable) {
                      return DraggableScrollableSheet(
                        snapAnimationDuration: const Duration(
                          milliseconds: 150,
                        ),
                        controller: controller,
                        initialChildSize: minS,
                        minChildSize: minS,
                        maxChildSize: max,
                        snap: true,
                        snapSizes: [minS, max],
                        builder: (context, scrollController) {
                          return AnimatedBuilder(
                            animation: progress,
                            builder: (context, child) {
                              final radius = (1.0 - progress.value) * 25;

                              return Material(
                                color: widget.backgroundColor,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(radius),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: child,
                              );
                            },
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Padding(
                                padding: widget.appbar != null
                                    ? EdgeInsets.all(15.r)
                                    : EdgeInsets.symmetric(
                                        vertical: 20.h,
                                        horizontal: 15.w,
                                      ),
                                child: widget.sheet,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: widget.appbar != null
                              ? minSize.value
                              : minSize.value + 0.03.h,
                          child: Material(
                            color: widget.backgroundColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: SizedBox(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(
                                  left: 17.w,
                                  right: 17.w,
                                  bottom:
                                      MediaQuery.paddingOf(context).bottom +
                                      5.h,
                                  top: 20.h,
                                ),
                                child: widget.sheet,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _ScaleAnimated extends StatelessWidget {
  final ValueListenable<double> valueListenable;
  final Widget child;
  const _ScaleAnimated({required this.child, required this.valueListenable});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: valueListenable,
      builder: (context, value, child) {
        final scale = 1 - (0.1 * value);
        return Transform.scale(
          scale: scale > 0.999 ? 1.0 : scale,
          child: child,
        );
      },
      child: child,
    );
  }
}
