import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muzhiki_stories/data/model/story_enums.dart';
import 'package:muzhiki_stories/data/model/story_model.dart';
import 'package:muzhiki_stories/domain/entity/story_action_entity.dart';
import 'package:muzhiki_stories/presentation/service/story_controller.dart';
import 'package:muzhiki_stories/presentation/state/stories_view_model.dart';
import 'package:muzhiki_stories/presentation/widgets/story/home_redisign_story_header.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_action_buttons.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_detail_overlay.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_geometry.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_page.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

class StoryViewer extends StatefulWidget {
  final StoriesViewModel viewModel;
  final int initialStoryIndex;
  final int initialItemIndex;
  final bool lockToSingleStory;
  final FutureOr<void> Function(StoryActionEntity action)? onAction;

  const StoryViewer({
    super.key,
    required this.viewModel,
    this.initialStoryIndex = 0,
    this.initialItemIndex = 0,
    this.lockToSingleStory = false,
    this.onAction,
  });

  static Future<Set<String>> show(
    BuildContext context, {
    required StoriesViewModel viewModel,
    int initialStoryIndex = 0,
    int initialItemIndex = 0,
    bool lockToSingleStory = false,
    FutureOr<void> Function(StoryActionEntity action)? onAction,
  }) async {
    final viewedIds = await Navigator.of(context, rootNavigator: true)
        .push<Set<String>>(
          PageRouteBuilder<Set<String>>(
            opaque: false,
            transitionDuration: const Duration(milliseconds: 280),
            reverseTransitionDuration: const Duration(milliseconds: 220),
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: StoryViewer(
                  viewModel: viewModel,
                  initialStoryIndex: initialStoryIndex,
                  initialItemIndex: initialItemIndex,
                  lockToSingleStory: lockToSingleStory,
                  onAction: onAction,
                ),
              );
            },
          ),
        );
    return viewedIds ?? const <String>{};
  }

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  StoryController? storyController;
  PageController? pageController;

  bool _syncingPage = false;
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

  ValueNotifier<List<StoryModel>> get _storiesListenable =>
      widget.viewModel.viewerStories;

  List<StoryModel> get _stories => _storiesListenable.value;

  bool get _isClosingViewer =>
      storyController?.isPausedFor(StoryPauseReason.closingViewer) ?? false;

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
            storiesListenable: _storiesListenable,
            closeStoryView: handleClosePressed,
            initialStoryIndex: widget.initialStoryIndex,
            initialItemIndex: widget.initialItemIndex,
            lockToSingleStory: widget.lockToSingleStory,
          )
          ..currentStoryIndex.addListener(_onStoryIndexFromController)
          ..currentStoryIndex.addListener(_precacheFromController)
          ..currentItemIndex.addListener(_precacheFromController)
          ..setCurrentStoryViewed();
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
    widget.viewModel.clearNotFound();
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
    if (!mounted || _isClosingViewer) return;
    widget.viewModel.clearNotFound();
    final controller = storyController;
    if (controller != null && controller.isDetailOpen.value) {
      controller.closeDetail();
    } else {
      controller?.setPaused(
        reason: StoryPauseReason.closingViewer,
        isPaused: true,
      );

      Navigator.of(
        context,
        rootNavigator: true,
      ).pop(Set<String>.of(controller?.viewedStoryIds ?? {}));
    }
  }

  void _precacheAround(int storyIndex, int itemIndex) {
    if (!mounted) return;

    void precacheUrl({
      required String imageUrl,
      required StoryFirstScreenMode mode,
    }) {
      if (imageUrl.isEmpty) return;
      final provider = widget.viewModel.storyCacheManager.imageProvider(
        imageUrl: imageUrl,
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
          precacheUrl(imageUrl: items[precacheItemIndex].imageUrl, mode: mode);
        }
      } else {
        precacheUrl(imageUrl: items.first.imageUrl, mode: mode);
      }
    }
  }

  void _onPageChanged(int index) {
    if (_syncingPage || widget.lockToSingleStory) return;
    _syncingPage = true;
    storyController?.setStoryPage(index);
    edgeDragDx.value = 0;
    _edgePointerDx = 0;
    _syncingPage = false;
  }

  void _onEdgePointerDown(PointerDownEvent event) {
    final controller = storyController;
    if (controller == null ||
        controller.isDetailOpen.value ||
        _isClosingViewer) {
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
    if (controller.isDetailOpen.value || _isClosingViewer) return;

    final pages = pageController;
    if (pages != null && pages.hasClients) {
      final page = pages.page;
      if (page != null) {
        final index = widget.lockToSingleStory
            ? 0
            : controller.currentStoryIndex.value;
        if ((page - index).abs() >= 0.05) return;
      }
    }

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
      controller.setPaused(reason: StoryPauseReason.edgeDrag, isPaused: true);
      _edgePointerDx = totalDx.clamp(0.0, width);
      edgeDragDx.value = _edgePointerDx;
      if (!edgeDragging.value) edgeDragging.value = true;
      return;
    }

    if (index == last && (totalDx < 0 || edgeDragDx.value < 0)) {
      controller.setPaused(reason: StoryPauseReason.edgeDrag, isPaused: true);
      _edgePointerDx = totalDx.clamp(-width, 0.0);
      edgeDragDx.value = _edgePointerDx;
      if (!edgeDragging.value) edgeDragging.value = true;
    }
  }

  void _onEdgePointerEnd(PointerEvent event) {
    if (event.pointer != _edgePointer) return;
    _edgePointer = null;
    _edgePointerStart = null;
    edgeDragging.value = false;

    final controller = storyController;
    if (controller == null || _isClosingViewer) return;

    void clearEdgeAndScrollPause() {
      controller
        ..setPaused(reason: StoryPauseReason.edgeDrag, isPaused: false)
        ..setPaused(reason: StoryPauseReason.scroll, isPaused: false);
    }

    final width = MediaQuery.sizeOf(context).width;
    final dx = edgeDragDx.value;
    if (dx == 0) {
      clearEdgeAndScrollPause();
      return;
    }

    final shouldClose =
        dx.abs() > width * _edgeDismissDistance ||
        (dx > 0 && _edgeDragVelocity > _edgeDismissVelocity) ||
        (dx < 0 && _edgeDragVelocity < -_edgeDismissVelocity);

    if (shouldClose) {
      clearEdgeAndScrollPause();
      handleClosePressed();
    } else {
      edgeDragDx.value = 0;
      _edgePointerDx = 0;
      clearEdgeAndScrollPause();
    }
    _edgeDragVelocity = 0;
  }

  bool _onStoryScroll(ScrollNotification notification) {
    final controller = storyController;
    if (controller == null ||
        controller.isDetailOpen.value ||
        _isClosingViewer) {
      return false;
    }
    if (notification.metrics.axis != Axis.horizontal) return false;

    if (notification is ScrollUpdateNotification &&
        notification.dragDetails != null &&
        edgeDragDx.value == 0) {
      controller.setPaused(reason: StoryPauseReason.scroll, isPaused: true);
    }

    if (notification is ScrollEndNotification && edgeDragDx.value == 0) {
      controller.setPaused(reason: StoryPauseReason.scroll, isPaused: false);
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
    final controller = storyController;
    if (controller == null ||
        !controller.isPausedFor(StoryPauseReason.leaveApp)) {
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _leftAppForAction = true;
      return;
    }

    if (state != AppLifecycleState.resumed || !_leftAppForAction) return;

    _leftAppForAction = false;
    controller.setPaused(reason: StoryPauseReason.leaveApp, isPaused: false);
  }

  Future<void> _handleStoryAction({
    required StoryModel story,
    required StoryActionSource source,
    required StoryActionType type,
    required String? link,
    required String? label,
  }) async {
    final isLeaveApp =
        type == StoryActionType.browser || type == StoryActionType.deeplink;
    final isWebViewOpen = type == StoryActionType.webview;

    if (isLeaveApp) {
      _leftAppForAction = false;
      storyController?.setPaused(
        reason: StoryPauseReason.leaveApp,
        isPaused: true,
      );
    } else if (isWebViewOpen) {
      storyController?.setPaused(
        reason: StoryPauseReason.action,
        isPaused: true,
      );
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
      if (isWebViewOpen) {
        storyController?.setPaused(
          reason: StoryPauseReason.action,
          isPaused: false,
        );
      } else if (isLeaveApp && !_leftAppForAction) {
        storyController?.setPaused(
          reason: StoryPauseReason.leaveApp,
          isPaused: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        handleClosePressed();
      },
      child: ListenableBuilder(
        listenable: Listenable.merge([widget.viewModel, _storiesListenable]),
        builder: (context, _) {
          if (_stories.isEmpty ||
              storyController == null ||
              pageController == null) {
            final state = widget.viewModel.state;
            final message = state.notFound
                ? 'Сторис не найден'
                : state.isLoading
                ? null
                : 'Список сторисов пуст';

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
                    child: message == null
                        ? Transform.scale(
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
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Text(
                              message,
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
                      final dismissProgress =
                          (dragDx.abs() / constraints.maxWidth).clamp(0.0, 1.0);
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
                          valueListenable: _storiesListenable,
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
                                          final lockPages =
                                              detailOpen || dragging;
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
                                              return StoryPage(
                                                page: page,
                                                lockToSingleStory:
                                                    widget.lockToSingleStory,
                                                viewModel: widget.viewModel,
                                                storyController:
                                                    storyController!,
                                                storyGeometry: storyGeometry,
                                                appBarHeight: appBarHeight,
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                ValueListenableBuilder<int>(
                                  valueListenable:
                                      storyController!.currentStoryIndex,
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
                                      return ValueListenableBuilder<bool>(
                                        valueListenable:
                                            storyController!.isDetailOpen,
                                        builder: (context, isOpen, child) {
                                          return StoryActionButtons(
                                            story: _stories[index],
                                            storyController: storyController!,
                                            isDetailOpen: isOpen,
                                            onMarkdownAction:
                                                openMarkdownAction,
                                            onFullscreenAction:
                                                openFullscreenAction,
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
        },
      ),
    );
  }
}
