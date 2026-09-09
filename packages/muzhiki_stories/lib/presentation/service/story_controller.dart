import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:muzhiki_stories/data/model/story_model.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_geometry.dart';

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

    final open = size > 0.001;
    if (isDetailOpen.value == open) return;

    isDetailOpen.value = open;
    if (open) {
      storyController.stop();
    } else {
      if (_detailScroll?.hasClients ?? false) _detailScroll!.jumpTo(0);
      resumePlay();
    }
  }

  void updateCanExpand(double maxScrollExtent) {
    if ((sheetSize.value - StoryGeometry.defaultMidSize).abs() > 0.001) return;
    canExpand.value = maxScrollExtent > 0;
  }

  void startPlay() {
    _syncDuration();
    storyController.forward(from: 0);
  }

  void resetPlay() {
    _syncDuration();
    storyController
      ..stop()
      ..value = 0;
  }

  void resumePlay() {
    if (storyController.isAnimating) return;
    if (storyController.status == AnimationStatus.completed) return;
    storyController.forward();
  }

  void pausePlay() => storyController.stop();

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
  }

  void applyStoryPage(int storyIndex) {
    if (currentStoryIndex.value == storyIndex) {
      resumePlay();
      return;
    }
    resetDetail();
    currentStoryIndex.value = storyIndex;
    currentItemIndex.value = 0;
    canExpand.value = true;
    resetPlay();
    startPlay();
  }

  void showNext() {
    final items = stories[currentStoryIndex.value].items;
    if (items.isNotEmpty && currentItemIndex.value < items.length - 1) {
      resetDetail();
      currentItemIndex.value += 1;
      canExpand.value = true;
      resetPlay();
      startPlay();
      return;
    }

    if (lockToSingleStory) {
      closeStoryView();
      return;
    }

    if (currentStoryIndex.value >= stories.length - 1) {
      closeStoryView();
      return;
    }

    resetDetail();
    currentStoryIndex.value += 1;
    currentItemIndex.value = 0;
    canExpand.value = true;
    resetPlay();
    startPlay();
  }

  void showPrevious() {
    if (currentItemIndex.value > 0) {
      resetDetail();
      currentItemIndex.value -= 1;
      canExpand.value = true;
      resetPlay();
      startPlay();
      return;
    }

    if (lockToSingleStory || currentStoryIndex.value <= 0) {
      canExpand.value = true;
      startPlay();
      return;
    }

    resetDetail();
    currentStoryIndex.value -= 1;
    final prevItems = stories[currentStoryIndex.value].items;
    currentItemIndex.value = prevItems.isEmpty ? 0 : prevItems.length - 1;
    canExpand.value = true;
    resetPlay();
    startPlay();
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
