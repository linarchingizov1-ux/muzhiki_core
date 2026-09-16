import 'package:flutter/material.dart';
import 'package:muzhiki_stories/data/model/story_enums.dart';
import 'package:muzhiki_stories/presentation/service/story_cache_manager.dart';
import 'package:muzhiki_stories/presentation/service/story_controller.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_geometry.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_image.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({
    super.key,
    required this.page,
    required this.lockToSingleStory,
    required this.cacheManager,
    required this.storyController,
    required this.storyGeometry,
    required this.appBarHeight,
  });

  final int page;
  final bool lockToSingleStory;
  final StoryCacheManager cacheManager;
  final StoryController storyController;
  final StoryGeometry storyGeometry;
  final double appBarHeight;

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  bool get _isCurrentPage =>
      widget.lockToSingleStory ||
      widget.page == widget.storyController.currentStoryIndex.value;

  ({String imageUrl, StoryFirstScreenMode mode, int itemIndex}) _imageInfo() {
    final controller = widget.storyController;
    final storyIndex = widget.lockToSingleStory
        ? controller.currentStoryIndex.value
        : widget.page;
    final story = controller.stories[storyIndex];
    final items = story.items;
    if (items.isEmpty) {
      return (imageUrl: '', mode: story.firstScreenMode, itemIndex: 0);
    }

    final isCurrentStory = storyIndex == controller.currentStoryIndex.value;
    final itemIndex = isCurrentStory
        ? controller.currentItemIndex.value.clamp(0, items.length - 1)
        : 0;
    final item = items[itemIndex];

    return (
      imageUrl: item.imageUrl,
      mode: story.firstScreenMode,
      itemIndex: itemIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.storyController.storiesListenable,
        widget.storyController.currentStoryIndex,
        widget.storyController.currentItemIndex,
      ]),
      builder: (context, _) {
        final imageInfo = _imageInfo();

        return RepaintBoundary(
          child: ValueListenableBuilder<double>(
            valueListenable: widget.storyController.sheetSize,
            child: StoryImage(
              key: ValueKey('${widget.page}-${imageInfo.itemIndex}'),
              imageUrl: imageInfo.imageUrl,
              imageProvider: widget.cacheManager.imageProvider(
                imageUrl: imageInfo.imageUrl,
                mode: imageInfo.mode,
              ),
              storyController: widget.storyController,
              onLoadedChanged: _isCurrentPage
                  ? widget.storyController.setCurrentImageLoaded
                  : null,
            ),
            builder: (context, size, child) {
              final blur = widget.storyGeometry.appBarBlurAt(size);

              return SoftEdgeBlur(
                edges: blur != 0
                    ? [
                        EdgeBlur(
                          type: EdgeType.topEdge,
                          size: widget.appBarHeight,
                          sigma: 50 * blur,
                          controlPoints: [
                            ControlPoint(
                              position: 0.8,
                              type: ControlPointType.visible,
                            ),
                            ControlPoint(
                              position: 1,
                              type: ControlPointType.transparent,
                            ),
                          ],
                        ),
                      ]
                    : const [],
                child: ClipRRect(
                  clipper: StoryPhotoClipper(
                    size: size,
                    geometry: widget.storyGeometry,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: double.infinity,
                      height: widget.storyGeometry.photoHeightAt(size),
                      child: child,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
