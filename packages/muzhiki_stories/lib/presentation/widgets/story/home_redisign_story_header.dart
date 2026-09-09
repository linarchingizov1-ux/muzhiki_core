import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muzhiki_stories/presentation/service/story_controller.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_progress_painter.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

class HomeRedisignStoryHeader extends StatelessWidget {
  const HomeRedisignStoryHeader({
    super.key,
    required this.storyController,
    required this.onClose,
  });

  final StoryController storyController;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        Positioned.fill(
          child: ValueListenableBuilder<bool>(
            valueListenable: storyController.isDetailOpen,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: storyController.showPrevious,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: storyController.showNext,
                  ),
                ),
              ],
            ),
            builder: (context, isActive, child) =>
                IgnorePointer(ignoring: isActive, child: child),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: topPadding + 50.h,
          child: const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 1],
                  colors: [Color.fromARGB(255, 0, 0, 0), Colors.transparent],
                ),
              ),
              child: SizedBox.expand(),
            ),
          ),
        ),
        Positioned(
          top: topPadding + 15.h,
          left: 22.w,
          right: 22.w,
          child: SlideTransition(
            position: storyController.detailProgress.drive(
              Tween<Offset>(
                begin: Offset.zero,
                end: Offset(0, -(topPadding + 23.h) / 4.h),
              ),
            ),
            child: RepaintBoundary(
              child: SizedBox(
                height: 4.h,
                child: ValueListenableBuilder<int>(
                  valueListenable: storyController.currentStoryIndex,
                  builder: (context, storyIndex, _) {
                    final itemCount =
                        storyController.stories[storyIndex].items.length;
                    return CustomPaint(
                      size: Size.infinite,
                      painter: StoryProgressPainter(
                        storyProgress: storyController.storyController,
                        currentIndex: storyController.currentItemIndex,
                        storyCount: itemCount,
                        barGap: 10.w,
                        trackColor: MuzhikiColors.white.withValues(alpha: 0.6),
                        valueColor: MuzhikiColors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: topPadding,
          left: 22.w,
          right: 22.w,
          height: 40.h,
          child: SlideTransition(
            position: storyController.detailProgress.drive(
              Tween<Offset>(begin: Offset(0, 25.h / 50.h), end: Offset.zero),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<int>(
                    valueListenable: storyController.currentStoryIndex,
                    builder: (context, index, _) {
                      final title = storyController.stories[index].title;
                      ;
                      if (title == null || title.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: MuzhikiColors.white,
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onClose,
                  child: SizedBox(
                    width: 44.w,
                    height: 44.h,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        'assets/svg/close.svg',
                        package: 'muzhiki_stories',
                        width: 12.w,
                        height: 12.h,
                        colorFilter: ColorFilter.mode(
                          MuzhikiColors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
