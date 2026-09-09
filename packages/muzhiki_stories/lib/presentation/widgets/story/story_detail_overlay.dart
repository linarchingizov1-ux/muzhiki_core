import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_stories/data/model/story_model.dart';
import 'package:muzhiki_stories/presentation/service/story_controller.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_geometry.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

class StoryDetailOverlay extends StatelessWidget {
  final StoryController storyController;
  final StoryGeometry storyGeometry;
  final StoryModel story;

  const StoryDetailOverlay({
    super.key,
    required this.storyController,
    required this.storyGeometry,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ValueListenableBuilder<bool>(
        valueListenable: storyController.canExpand,
        builder: (context, canExpand, child) => DraggableScrollableSheet(
          controller: storyController.sheet,
          initialChildSize: 0,
          minChildSize: 0,
          maxChildSize: canExpand
              ? storyGeometry.maxSize
              : StoryGeometry.defaultMidSize,
          snap: true,
          snapSizes: storyGeometry.snapSizes,
          builder: (context, scrollController) {
            storyController.detailScroll = scrollController;
            return FadeTransition(
              opacity: storyController.textOpacity,
              child: ScaleTransition(
                scale: storyController.textScale,
                alignment: Alignment.topCenter,
                child: NotificationListener<ScrollMetricsNotification>(
                  onNotification: (notification) {
                    storyController.updateCanExpand(
                      notification.metrics.maxScrollExtent,
                    );
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: canExpand ? null : const ClampingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 27.w,
                      right: 27.w,
                      top: 24.h,
                      bottom: MediaQuery.paddingOf(context).bottom + 96.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (story.title != null && story.title!.isNotEmpty) ...[
                          Text(
                            story.title!,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: MuzhikiColors.black23,
                            ),
                          ),
                          SizedBox(height: 12.h),
                        ],
                        MarkdownBody(
                          data: story.markdownBody ?? '',
                          styleSheet: MarkdownStyleSheet(
                            h1: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: MuzhikiColors.black23,
                              height: 1.4,
                            ),
                            h1Padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                            h2: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: MuzhikiColors.black23,
                              height: 1.4,
                            ),
                            h2Padding: EdgeInsets.only(top: 14.h, bottom: 6.h),
                            h3: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: MuzhikiColors.black23.withAlpha(230),
                              height: 1.4,
                            ),
                            h3Padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
                            h4: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: MuzhikiColors.black23.withAlpha(200),
                            ),
                            h5: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: MuzhikiColors.black23.withAlpha(180),
                            ),
                            h6: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                              color: MuzhikiColors.black23.withAlpha(150),
                            ),
                            p: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: MuzhikiColors.black23,
                              height: 1.4,
                            ),
                            pPadding: EdgeInsets.only(bottom: 8.h),
                            strong: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MuzhikiColors.black23,
                            ),
                            listBullet: TextStyle(
                              fontSize: 15.sp,
                              color: MuzhikiColors.black23,
                            ),
                            listBulletPadding: EdgeInsets.only(
                              right: 8.w,
                              top: 2.h,
                            ),
                            tableHead: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: MuzhikiColors.black23,
                            ),
                            tableBody: TextStyle(
                              fontSize: 13.sp,
                              color: MuzhikiColors.black23.withAlpha(220),
                            ),
                            tableCellsPadding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 8.h,
                            ),
                            tableBorder: TableBorder.all(
                              color: MuzhikiColors.black23.withAlpha(40),
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            horizontalRuleDecoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 1,
                                  color: MuzhikiColors.black23.withAlpha(50),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
