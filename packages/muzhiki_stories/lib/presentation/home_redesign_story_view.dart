import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muzhiki_stories/data/model/story_enums.dart';
import 'package:muzhiki_stories/data/model/story_model.dart';
import 'package:muzhiki_stories/domain/entity/story_action_entity.dart';
import 'package:muzhiki_stories/presentation/service/story_cache_manager.dart';
import 'package:muzhiki_stories/presentation/service/story_controller.dart';
import 'package:muzhiki_stories/presentation/state/stories_view_model.dart';
import 'package:muzhiki_stories/presentation/widgets/story/home_redisign_story_header.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_detail_overlay.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_geometry.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

class StoryViewer extends StatefulWidget {
  final StoriesViewModel viewModel;
  final ValueNotifier<List<StoryModel>> stories;
  final int initialStoryIndex;
  final int initialItemIndex;
  final bool lockToSingleStory;
  final FutureOr<void> Function(StoryActionEntity action)? onAction;

  const StoryViewer({
    super.key,
    required this.viewModel,
    required this.stories,
    this.initialStoryIndex = 0,
    this.initialItemIndex = 0,
    this.lockToSingleStory = false,
    this.onAction,
  });

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  StoryController? storyController;
  PageController? pageController;

  bool _syncingPage = false;
  bool _closing = false;
  bool _pausedForLeave = false;
  bool _leftAppForAction = false;

  final edgeDragDx = ValueNotifier<double>(0);
  final edgeDragging = ValueNotifier<bool>(false);
  double _edgeDragVelocity = 0;

  static const _edgeDismissDistance = 0.18;
  static const _edgeDismissVelocity = 450.0;

  int? _edgePointer;
  Offset? _edgePointerStart;
  double _edgePointerDx = 0;
  double _edgeLastDx = 0;
  Duration? _edgeLastTime;

  List<StoryModel> get _stories => widget.stories.value;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_stories.isEmpty) return;

    pageController = PageController(
      initialPage: widget.lockToSingleStory ? 0 : widget.initialStoryIndex,
    );
    final controller =
        StoryController(
            vsync: this,
            storiesListenable: widget.stories,
            closeStoryView: handleClosePressed,
            initialStoryIndex: widget.initialStoryIndex,
            initialItemIndex: widget.initialItemIndex,
            lockToSingleStory: widget.lockToSingleStory,
          )
          ..currentStoryIndex.addListener(_onStoryIndexFromController)
          ..currentStoryIndex.addListener(_precacheFromController)
          ..currentItemIndex.addListener(_precacheFromController);
    storyController = controller;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _precacheAround(
        controller.currentStoryIndex.value,
        controller.currentItemIndex.value,
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final controller = storyController;
    if (controller != null) {
      controller.currentStoryIndex.removeListener(_onStoryIndexFromController);
      controller.currentStoryIndex.removeListener(_precacheFromController);
      controller.currentItemIndex.removeListener(_precacheFromController);
      controller.dispose();
    }
    pageController?.dispose();
    edgeDragDx.dispose();
    edgeDragging.dispose();
    super.dispose();
  }

  void _precacheFromController() {
    final controller = storyController;
    if (controller == null) return;
    _precacheAround(
      controller.currentStoryIndex.value,
      controller.currentItemIndex.value,
    );
  }

  void _onStoryIndexFromController() {
    final controller = storyController;
    final pages = pageController;
    if (controller == null || pages == null) return;
    if (widget.lockToSingleStory || _syncingPage || !pages.hasClients) {
      return;
    }
    final index = controller.currentStoryIndex.value;
    final current = pages.page?.round() ?? pages.initialPage;
    if (current == index) return;

    _syncingPage = true;
    pages.jumpToPage(index);
    _syncingPage = false;
  }

  void handleClosePressed() {
    if (!mounted || _closing) return;
    final controller = storyController;
    if (controller != null && controller.isDetailOpen.value) {
      controller.closeDetail();
    } else {
      _closing = true;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _precacheAround(int storyIndex, int itemIndex) {
    if (!mounted) return;

    void precacheUrl(String url, {required StoryFirstScreenMode mode}) {
      if (url.isEmpty) return;
      final provider = widget.viewModel.storyCacheManager.provider(
        url,
        mode: mode,
      );
      precacheImage(provider, context, onError: (_, _) {});
    }

    for (final precacheStoryIndex in [
      storyIndex - 1,
      storyIndex,
      storyIndex + 1,
    ]) {
      if (precacheStoryIndex < 0 || precacheStoryIndex >= _stories.length) {
        continue;
      }
      final story = _stories[precacheStoryIndex];
      final items = story.items;
      if (items.isEmpty) continue;
      final mode = story.firstScreenMode;
      if (precacheStoryIndex == storyIndex) {
        for (final precacheItemIndex in [
          itemIndex - 1,
          itemIndex,
          itemIndex + 1,
        ]) {
          if (precacheItemIndex < 0 || precacheItemIndex >= items.length) {
            continue;
          }
          precacheUrl(items[precacheItemIndex].imageUrl, mode: mode);
        }
      } else {
        precacheUrl(items.first.imageUrl, mode: mode);
      }
    }
  }

  void _onPageChanged(int index) {
    if (_syncingPage || widget.lockToSingleStory) return;
    _syncingPage = true;
    storyController?.applyStoryPage(index);
    edgeDragDx.value = 0;
    _edgePointerDx = 0;
    _syncingPage = false;
  }

  bool get _pageSettledAtCurrent {
    final pages = pageController;
    final controller = storyController;
    if (pages == null || controller == null) return true;
    if (!pages.hasClients) return true;
    final page = pages.page;
    if (page == null) return true;
    final index = widget.lockToSingleStory
        ? 0
        : controller.currentStoryIndex.value;
    return (page - index).abs() < 0.05;
  }

  void _onEdgePointerDown(PointerDownEvent event) {
    final controller = storyController;
    if (controller == null || controller.isDetailOpen.value || _closing) {
      return;
    }
    _edgePointer = event.pointer;
    _edgePointerStart = event.localPosition;
    _edgePointerDx = 0;
    _edgeLastDx = 0;
    _edgeLastTime = event.timeStamp;
    _edgeDragVelocity = 0;
  }

  void _onEdgePointerMove(PointerMoveEvent event) {
    final controller = storyController;
    if (controller == null) return;
    if (event.pointer != _edgePointer || _edgePointerStart == null) return;
    if (controller.isDetailOpen.value || _closing) return;
    if (!_pageSettledAtCurrent) return;

    final index = widget.lockToSingleStory
        ? 0
        : controller.currentStoryIndex.value;
    final last = (widget.lockToSingleStory ? 1 : _stories.length) - 1;
    final width = MediaQuery.sizeOf(context).width;
    final totalDx = event.localPosition.dx - _edgePointerStart!.dx;

    final dt =
        (_edgeLastTime != null
                ? event.timeStamp - _edgeLastTime!
                : Duration.zero)
            .inMicroseconds /
        1e6;
    if (dt > 0) {
      _edgeDragVelocity = (totalDx - _edgeLastDx) / dt;
    }
    _edgeLastDx = totalDx;
    _edgeLastTime = event.timeStamp;

    if (index == 0 && (totalDx > 0 || edgeDragDx.value > 0)) {
      controller.pausePlay();
      _edgePointerDx = totalDx.clamp(0.0, width);
      edgeDragDx.value = _edgePointerDx;
      if (!edgeDragging.value) edgeDragging.value = true;
      return;
    }

    if (index == last && (totalDx < 0 || edgeDragDx.value < 0)) {
      controller.pausePlay();
      _edgePointerDx = totalDx.clamp(-width, 0.0);
      edgeDragDx.value = _edgePointerDx;
      if (!edgeDragging.value) edgeDragging.value = true;
    }
  }

  void _onEdgePointerEnd(PointerEvent event) {
    if (event.pointer != _edgePointer) return;
    _edgePointer = null;
    _edgePointerStart = null;
    final wasDragging = edgeDragging.value;
    edgeDragging.value = false;

    final controller = storyController;
    if (controller == null || _closing || _pausedForLeave) return;

    final width = MediaQuery.sizeOf(context).width;
    final dx = edgeDragDx.value;
    if (dx == 0) {
      if (wasDragging) controller.resumePlay();
      return;
    }

    final shouldClose =
        dx.abs() > width * _edgeDismissDistance ||
        (dx > 0 && _edgeDragVelocity > _edgeDismissVelocity) ||
        (dx < 0 && _edgeDragVelocity < -_edgeDismissVelocity);

    if (shouldClose) {
      handleClosePressed();
    } else {
      edgeDragDx.value = 0;
      _edgePointerDx = 0;
      controller.resumePlay();
    }
    _edgeDragVelocity = 0;
  }

  bool _onStoryScroll(ScrollNotification notification) {
    final controller = storyController;
    if (controller == null ||
        controller.isDetailOpen.value ||
        _closing ||
        _pausedForLeave) {
      return false;
    }
    if (notification.metrics.axis != Axis.horizontal) return false;

    if (notification is ScrollUpdateNotification &&
        notification.dragDetails != null &&
        edgeDragDx.value == 0) {
      controller.pausePlay();
    }

    if (notification is ScrollEndNotification && edgeDragDx.value == 0) {
      controller.resumePlay();
    }

    return false;
  }

  void openFullscreenAction() {
    final controller = storyController;
    if (controller == null) return;
    final story = controller.stories[controller.currentStoryIndex.value];
    if (story.fullscreenActionType == StoryActionType.none) return;
    if (story.fullscreenActionType == StoryActionType.markdown) {
      controller.openDetail();
      return;
    }
    _handleStoryAction(
      story: story,
      source: StoryActionSource.fullscreen,
      type: story.fullscreenActionType,
      link: story.fullscreenActionLink,
      label: story.fullscreenActionText,
    );
  }

  void openMarkdownAction() {
    final controller = storyController;
    if (controller == null) return;
    final story = controller.stories[controller.currentStoryIndex.value];
    if (story.markdownActionType == StoryActionType.none) return;
    _handleStoryAction(
      story: story,
      source: StoryActionSource.markdown,
      type: story.markdownActionType,
      link: story.markdownActionLink,
      label: story.markdownActionText,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_pausedForLeave) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _leftAppForAction = true;
      return;
    }

    if (state != AppLifecycleState.resumed || !_leftAppForAction) return;

    _pausedForLeave = false;
    _leftAppForAction = false;
    if (!mounted || _closing) return;
    final controller = storyController;
    if (controller == null || controller.isDetailOpen.value) return;
    controller.resumePlay();
  }

  Future<void> _handleStoryAction({
    required StoryModel story,
    required StoryActionSource source,
    required StoryActionType type,
    required String? link,
    required String? label,
  }) async {
    final leavesApp =
        type == StoryActionType.browser || type == StoryActionType.deeplink;
    final awaitRoute = type == StoryActionType.webview;

    if (leavesApp || awaitRoute) {
      storyController?.pausePlay();
    }
    if (leavesApp) {
      _pausedForLeave = true;
      _leftAppForAction = false;
    }

    try {
      await widget.onAction?.call(
        StoryActionEntity(
          story: story,
          source: source,
          type: type,
          link: link,
          label: label,
        ),
      );
    } finally {
      if (awaitRoute && mounted && !_closing) {
        final controller = storyController;
        if (controller != null && !controller.isDetailOpen.value) {
          controller.resumePlay();
        }
      }
    }
  }

  void _onActiveImageLoaded(bool imageLoaded) {
    final controller = storyController;
    if (controller == null || _closing || _pausedForLeave) return;
    if (controller.isDetailOpen.value) return;

    if (!imageLoaded) {
      if (controller.storyController.value <= 0) {
        controller.resetPlay();
      } else {
        controller.pausePlay();
      }
      return;
    }
    if (controller.storyController.isAnimating) return;

    final value = controller.storyController.value;
    final completed =
        controller.storyController.status == AnimationStatus.completed;
    if (value > 0 && !completed) {
      controller.resumePlay();
    } else {
      controller.startPlay();
    }
  }

  String _imageUrlForPage(int page) {
    final controller = storyController;
    if (controller == null) return '';
    final storyIndex = widget.lockToSingleStory
        ? controller.currentStoryIndex.value
        : page;
    final story = _stories[storyIndex];
    final items = story.items;
    if (items.isEmpty) return '';

    if (storyIndex == controller.currentStoryIndex.value) {
      return items[controller.currentItemIndex.value].imageUrl;
    }
    return items.first.imageUrl;
  }

  StoryFirstScreenMode _modeForPage(int page) {
    final controller = storyController;
    if (controller == null || _stories.isEmpty) {
      return StoryFirstScreenMode.disabled;
    }
    final storyIndex = widget.lockToSingleStory
        ? controller.currentStoryIndex.value
        : page;
    if (storyIndex < 0 || storyIndex >= _stories.length) {
      return StoryFirstScreenMode.disabled;
    }
    return _stories[storyIndex].firstScreenMode;
  }

  @override
  Widget build(BuildContext context) {
    if (_stories.isEmpty || storyController == null || pageController == null) {
      return Scaffold(
        backgroundColor: MuzhikiColors.black17,
        body: Stack(
          children: [
            Positioned(
              top: MediaQuery.paddingOf(context).top,
              left: 22.w,
              right: 22.w,
              height: 40.h,
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: handleClosePressed,
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
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  'Список сторисов пуст',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: MuzhikiColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final padding = MediaQuery.paddingOf(context);
          final appBarHeight = padding.top + 40.h;
          final storyGeometry = StoryGeometry(
            screenHeight: constraints.maxHeight,
            appBarHeight: appBarHeight,
            cornerRadius: 25.r,
            cornerStraightenDistance: 60.h,
          );

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragEnd: (details) {
              if ((details.primaryVelocity ?? 0) < 200) return;
              handleClosePressed();
            },
            child: ValueListenableBuilder<double>(
              valueListenable: edgeDragDx,
              builder: (context, dragDx, child) {
                final dismissProgress = (dragDx.abs() / constraints.maxWidth)
                    .clamp(0.0, 1.0);
                return AnimatedContainer(
                  duration: dragDx == 0
                      ? const Duration(milliseconds: 180)
                      : Duration.zero,
                  curve: Curves.easeOutCubic,
                  transform: Matrix4.translationValues(dragDx, 0, 0),
                  child: Opacity(
                    opacity: 1 - dismissProgress * 0.35,
                    child: child,
                  ),
                );
              },
              child: ColoredBox(
                color: MuzhikiColors.appBackgroud,
                child: Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerDown: _onEdgePointerDown,
                  onPointerMove: _onEdgePointerMove,
                  onPointerUp: _onEdgePointerEnd,
                  onPointerCancel: _onEdgePointerEnd,
                  child: ValueListenableBuilder<List<StoryModel>>(
                    valueListenable: widget.stories,
                    builder: (context, stories, _) {
                      return Stack(
                        children: [
                          NotificationListener<ScrollNotification>(
                            onNotification: _onStoryScroll,
                            child: ValueListenableBuilder<bool>(
                              valueListenable: edgeDragging,
                              builder: (context, dragging, _) {
                                return ValueListenableBuilder<bool>(
                                  valueListenable:
                                      storyController!.isDetailOpen,
                                  builder: (context, detailOpen, _) {
                                    final lockPages = detailOpen || dragging;
                                    return PageView.builder(
                                      controller: pageController,
                                      allowImplicitScrolling: true,
                                      physics: lockPages
                                          ? const NeverScrollableScrollPhysics()
                                          : const ClampingScrollPhysics(
                                              parent: PageScrollPhysics(),
                                            ),
                                      onPageChanged: _onPageChanged,
                                      itemCount: widget.lockToSingleStory
                                          ? 1
                                          : stories.length,
                                      itemBuilder: (context, page) {
                                        return ValueListenableBuilder<int>(
                                          valueListenable: storyController!
                                              .currentStoryIndex,
                                          builder: (context, storyIndex, _) {
                                            return ValueListenableBuilder<int>(
                                              valueListenable: storyController!
                                                  .currentItemIndex,
                                              builder: (context, itemIndex, _) {
                                                return _StoryImagePage(
                                                  key: ValueKey(
                                                    '${page}_${_imageUrlForPage(page)}',
                                                  ),
                                                  imageUrl: _imageUrlForPage(
                                                    page,
                                                  ),
                                                  mode: _modeForPage(page),
                                                  cacheManager: widget
                                                      .viewModel
                                                      .storyCacheManager,
                                                  isActive:
                                                      widget
                                                          .lockToSingleStory ||
                                                      page == storyIndex,
                                                  storyController:
                                                      storyController!,
                                                  storyGeometry: storyGeometry,
                                                  appBarHeight: appBarHeight,
                                                  onImageLoaded:
                                                      _onActiveImageLoaded,
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: storyController!.currentStoryIndex,
                            builder: (context, index, _) {
                              return StoryDetailOverlay(
                                storyController: storyController!,
                                storyGeometry: storyGeometry,
                                story: _stories[index],
                              );
                            },
                          ),
                          HomeRedisignStoryHeader(
                            storyController: storyController!,
                            onClose: handleClosePressed,
                          ),
                          Positioned(
                            left: 16.w,
                            right: 16.w,
                            bottom: padding.bottom + 16.h,
                            child: ValueListenableBuilder<int>(
                              valueListenable:
                                  storyController!.currentStoryIndex,
                              builder: (context, index, _) {
                                final story = _stories[index];
                                return ValueListenableBuilder<bool>(
                                  valueListenable:
                                      storyController!.isDetailOpen,
                                  builder: (context, isOpen, child) {
                                    final hasMarkdownAction =
                                        story.markdownActionText != null &&
                                        story.markdownActionText!.isNotEmpty &&
                                        story.markdownActionType !=
                                            StoryActionType.none;

                                    final hasFullscreenAction =
                                        story.fullscreenActionText != null &&
                                        story
                                            .fullscreenActionText!
                                            .isNotEmpty &&
                                        story.fullscreenActionType !=
                                            StoryActionType.none;

                                    return Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        FadeTransition(
                                          opacity: storyController!.textOpacity,
                                          child: IgnorePointer(
                                            ignoring: !isOpen,
                                            child: hasMarkdownAction
                                                ? MuzhikiUi.buttons.dark(
                                                    label: story
                                                        .markdownActionText!,
                                                    borderRadius: 41,
                                                    onPressed:
                                                        openMarkdownAction,
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                        ),
                                        FadeTransition(
                                          opacity:
                                              storyController!.detailFadeOut,
                                          child: IgnorePointer(
                                            ignoring: isOpen,
                                            child: hasFullscreenAction
                                                ? MuzhikiUi.buttons.primary(
                                                    label: story
                                                        .fullscreenActionText!,
                                                    backgroundColor:
                                                        MuzhikiColors.greyLight,
                                                    borderRadius: 41,
                                                    onPressed:
                                                        openFullscreenAction,
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StoryImagePage extends StatefulWidget {
  const _StoryImagePage({
    super.key,
    required this.imageUrl,
    required this.mode,
    required this.cacheManager,
    required this.isActive,
    required this.storyController,
    required this.storyGeometry,
    required this.appBarHeight,
    required this.onImageLoaded,
  });

  final String imageUrl;
  final StoryFirstScreenMode mode;
  final StoryCacheManager cacheManager;
  final bool isActive;
  final StoryController storyController;
  final StoryGeometry storyGeometry;
  final double appBarHeight;
  final ValueChanged<bool> onImageLoaded;

  @override
  State<_StoryImagePage> createState() => _StoryImagePageState();
}

class _StoryImagePageState extends State<_StoryImagePage> {
  bool? _imageLoaded;

  void _setImageLoaded(bool imageLoaded) {
    if (_imageLoaded == imageLoaded) return;
    setState(() => _imageLoaded = imageLoaded);
    if (widget.isActive) widget.onImageLoaded(imageLoaded);
  }

  @override
  void didUpdateWidget(covariant _StoryImagePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive && _imageLoaded != null) {
      widget.onImageLoaded(_imageLoaded!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showLoader = !(_imageLoaded ?? false);

    return RepaintBoundary(
      child: ValueListenableBuilder<double>(
        valueListenable: widget.storyController.sheetSize,
        child: Image(
          image: widget.cacheManager.provider(
            widget.imageUrl,
            mode: widget.mode,
          ),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          gaplessPlayback: false,
          errorBuilder: (context, error, stackTrace) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _setImageLoaded(true);
            });
            return ColoredBox(
              color: MuzhikiColors.black17,
              child: Center(
                child: Icon(Icons.image, color: MuzhikiColors.white),
              ),
            );
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            final imageLoaded = wasSynchronouslyLoaded || frame != null;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _setImageLoaded(imageLoaded);
            });

            return ColoredBox(
              color: MuzhikiColors.black17,
              child: AnimatedOpacity(
                opacity: imageLoaded ? 1 : 0,
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOut,
                child: child,
              ),
            );
          },
        ),
        builder: (context, size, child) {
          final blur = widget.storyGeometry.appBarBlurAt(size);
          final photoHeight = widget.storyGeometry.photoHeightAt(size);
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
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  clipper: StoryPhotoClipper(
                    size: size,
                    geometry: widget.storyGeometry,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: double.infinity,
                      height: photoHeight,
                      child: child,
                    ),
                  ),
                ),
                if (showLoader)
                  ColoredBox(
                    color: MuzhikiColors.black17,
                    child: Center(
                      child: Transform.scale(
                        scale: Platform.isIOS ? 1.25 : 1.0,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2.5,
                          backgroundColor: Platform.isIOS
                              ? MuzhikiColors.white
                              : null,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            MuzhikiColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
