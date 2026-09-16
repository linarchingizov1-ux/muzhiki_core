import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:muzhiki_stories/data/model/story_model.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_geometry.dart';

enum StoryPauseReason {
  imageLoading,
  details,
  scroll,
  edgeDrag,
  action,
  leaveApp,
  closingViewer,
}

class StoryController {
  StoryController({
    required TickerProvider vsync,
    required this.storiesListenable,
    required this.closeStoryView,
    required int initialStoryIndex,
    required int initialItemIndex,
    required this.lockToSingleStory,
  }) : storyController = AnimationController(
         vsync: vsync,
         duration: const Duration(seconds: 5),
       ),
       _openPhase = AnimationController(vsync: vsync) {
    currentStoryIndex.value = initialStoryIndex;
    final items = stories[initialStoryIndex].items;
    currentItemIndex.value = items.isEmpty ? 0 : initialItemIndex;
    _syncDuration();
    storyController.addStatusListener(_handlePlayEnd);
    sheet.addListener(_handleSheetChanged);
  }

  final VoidCallback closeStoryView;
  final ValueNotifier<List<StoryModel>> storiesListenable;
  final bool lockToSingleStory;

  List<StoryModel> get stories => storiesListenable.value;

  final AnimationController storyController;
  final sheet = DraggableScrollableController();
  final sheetSize = ValueNotifier<double>(0);
  final isDetailOpen = ValueNotifier<bool>(false);
  final canExpand = ValueNotifier<bool>(true);
  final currentStoryIndex = ValueNotifier<int>(0);
  final currentItemIndex = ValueNotifier<int>(0);

  final Set<StoryPauseReason> _pauseReasons = {StoryPauseReason.imageLoading};
  final Set<String> viewedStoryIds = <String>{};
  final Set<String> _failedImageUrls = <String>{};

  final AnimationController _openPhase;

  late final Animation<double> detailProgress = _openPhase.view;
  late final Animation<double> detailFadeOut = detailProgress.drive(
    Tween<double>(begin: 1, end: 0),
  );
  late final Animation<double> textOpacity = _openPhase.drive(
    CurveTween(curve: const Interval(0.64, 1, curve: Curves.easeOutBack)),
  );
  late final Animation<double> textScale = textOpacity.drive(
    Tween<double>(begin: 0.92, end: 1),
  );

  ScrollController? _detailScroll;

  set detailScroll(ScrollController scrollController) =>
      _detailScroll = scrollController;

  bool isPausedFor(StoryPauseReason reason) => _pauseReasons.contains(reason);

  void setPaused({required StoryPauseReason reason, required bool isPaused}) {
    final isPauseReasonsChanged = isPaused
        ? _pauseReasons.add(reason)
        : _pauseReasons.remove(reason);
    if (isPauseReasonsChanged) _syncPlayback();
  }

  void setCurrentImageLoaded(bool isLoaded) {
    setPaused(
      reason: StoryPauseReason.imageLoading,
      isPaused: !isLoaded,
    );
  }

  bool isImageLoadFailed(String imageUrl) =>
      imageUrl.isNotEmpty && _failedImageUrls.contains(imageUrl);

  void markImageLoadFailed(String imageUrl) {
    if (imageUrl.isEmpty) return;
    _failedImageUrls.add(imageUrl);
  }

  void clearImageLoadFailed(String imageUrl) {
    _failedImageUrls.remove(imageUrl);
  }

  void _syncPlayback() {
    if (stories.isEmpty) return;
    final items = stories[currentStoryIndex.value].items;
    if (_pauseReasons.isNotEmpty || items.isEmpty) {
      storyController.stop();
    } else if (!storyController.isAnimating &&
        storyController.status != AnimationStatus.completed) {
      storyController.forward();
    }
  }

  void _syncDuration() {
    final items = stories[currentStoryIndex.value].items;
    final item = items.isEmpty ? null : items[currentItemIndex.value];
    storyController.duration = Duration(seconds: item?.durationSeconds ?? 5);
  }

  void _handleSheetChanged() {
    if (!sheet.isAttached) return;

    final size = sheet.size;
    if (sheetSize.value == size) return;

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => _handleSheetChanged(),
      );
      return;
    }

    sheetSize.value = size;
    _openPhase.value = (size / StoryGeometry.defaultMidSize).clamp(0.0, 1.0);

    final isDetailSheetOpen = size > 0.001;
    if (isDetailOpen.value == isDetailSheetOpen) return;

    isDetailOpen.value = isDetailSheetOpen;
    if (!isDetailSheetOpen && (_detailScroll?.hasClients ?? false)) {
      _detailScroll!.jumpTo(0);
    }
    setPaused(reason: StoryPauseReason.details, isPaused: isDetailSheetOpen);
  }

  void updateCanExpand(double maxScrollExtent) {
    if ((sheetSize.value - StoryGeometry.defaultMidSize).abs() > 0.001) return;
    canExpand.value = maxScrollExtent > 0;
  }

  void _restartProgress() {
    _syncDuration();
    storyController
      ..stop()
      ..value = 0;
    _syncPlayback();
  }

  void _handlePlayEnd(AnimationStatus status) {
    if (status == AnimationStatus.completed) showNext();
  }

  void resetDetail() {
    if (!sheet.isAttached) return;
    if (sheet.size <= 0.001) return;
    sheet.jumpTo(0);
    if (_detailScroll?.hasClients ?? false) _detailScroll!.jumpTo(0);
    isDetailOpen.value = false;
    sheetSize.value = 0;
    _openPhase.value = 0;
    setPaused(reason: StoryPauseReason.details, isPaused: false);
  }

  void markCurrentStoryViewed() {
    if (stories.isEmpty) return;

    final index = currentStoryIndex.value;
    if (index < 0 || index >= stories.length) return;

    final storyId = stories[index].id;
    if (storyId.isEmpty) return;

    viewedStoryIds.add(storyId);
  }

  void _setStoryItem({required int storyIndex, required int itemIndex}) {
    resetDetail();
    setCurrentImageLoaded(false);
    currentStoryIndex.value = storyIndex;
    currentItemIndex.value = itemIndex;
    markCurrentStoryViewed();
    canExpand.value = true;
    _restartProgress();
  }

  void setStoryPage(int storyIndex) {
    if (currentStoryIndex.value == storyIndex) {
      _syncPlayback();
      return;
    }
    _setStoryItem(storyIndex: storyIndex, itemIndex: 0);
  }

  void showNext() {
    final items = stories[currentStoryIndex.value].items;
    if (items.isNotEmpty && currentItemIndex.value < items.length - 1) {
      _setStoryItem(
        storyIndex: currentStoryIndex.value,
        itemIndex: currentItemIndex.value + 1,
      );
      return;
    }

    if (lockToSingleStory || currentStoryIndex.value >= stories.length - 1) {
      closeStoryView();
      return;
    }

    _setStoryItem(storyIndex: currentStoryIndex.value + 1, itemIndex: 0);
  }

  void showPrevious() {
    if (currentItemIndex.value > 0) {
      _setStoryItem(
        storyIndex: currentStoryIndex.value,
        itemIndex: currentItemIndex.value - 1,
      );
      return;
    }

    if (lockToSingleStory || currentStoryIndex.value <= 0) {
      canExpand.value = true;
      _restartProgress();
      return;
    }

    final prevIndex = currentStoryIndex.value - 1;
    final prevItems = stories[prevIndex].items;
    _setStoryItem(
      storyIndex: prevIndex,
      itemIndex: prevItems.isEmpty ? 0 : prevItems.length - 1,
    );
  }

  Future<void> openDetail() async {
    if (!sheet.isAttached || isDetailOpen.value) return;
    await sheet.animateTo(
      StoryGeometry.defaultMidSize,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> closeDetail() async {
    if (!sheet.isAttached || !isDetailOpen.value) return;
    await sheet.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  void dispose() {
    viewedStoryIds.clear();
    _failedImageUrls.clear();
    sheet.removeListener(_handleSheetChanged);
    sheet.dispose();
    storyController.dispose();
    _openPhase.dispose();
    sheetSize.dispose();
    currentStoryIndex.dispose();
    currentItemIndex.dispose();
    isDetailOpen.dispose();
    canExpand.dispose();
  }
}
