import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:muzhiki_dependencies/muzhiki_dependencies.dart';
import 'package:muzhiki_stories/data/model/story_enums.dart';
import 'package:muzhiki_stories/data/model/story_model.dart';
import 'package:muzhiki_stories/domain/repository/stories_repository.dart';
import 'package:muzhiki_stories/presentation/service/story_cache_manager.dart';
import 'package:muzhiki_stories/presentation/state/stories_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoriesViewModel extends ChangeNotifier {
  StoriesViewModel({
    required this.repository,
    required this.placeId,
    required this.sharedPreferences,
    required this.storyCacheManager,
  });

  static const _onceKeyPrefix = 'stories_once';

  final StoriesRepository repository;
  final int placeId;
  final SharedPreferences sharedPreferences;
  final StoryCacheManager storyCacheManager;

  final viewerStories = ValueNotifier<List<StoryModel>>(const []);

  StoriesState _state = const StoriesState();
  StoriesState get state => _state;

  int _storiesRequestId = 0;
  int _firstScreenPreloadRequestId = 0;

  Future<List<StoryModel>>? _firstScreenPreload;

  Future<void> init({bool isRefresh = false}) async {
    if (_state.stories != null && !isRefresh) return;
    await getStories(isRefresh: isRefresh);
  }

  Future<void> getStories({
    bool isRefresh = false,
    bool showFirstScreen = true,
  }) async {
    final requestId = ++_storiesRequestId;
    _resetFirstScreenPreload();

    _state = _state.copyWith(
      isLoading: !isRefresh,
      clearError: true,
      notFound: false,
    );
    notifyListeners();

    try {
      final stories = await repository.getStories();
      if (requestId != _storiesRequestId) return;

      if (!showFirstScreen) {
        _state = _state.copyWith(isLoading: false, stories: stories);
        return;
      }

      final storiesForFirstScreen = _filterFirstScreenStories(stories);
      final storiesWithoutPreload = [
        for (final story in storiesForFirstScreen)
          if (!story.firstScreenPreload) story,
      ];
      final storiesWithPreload = [
        for (final story in storiesForFirstScreen)
          if (story.firstScreenPreload) story,
      ];

      _state = _state.copyWith(
        isLoading: false,
        stories: stories,
        firstScreenStories: storiesWithoutPreload,
      );
      setViewerStories(storiesWithoutPreload);

      if (storiesWithPreload.isNotEmpty) {
        final preloadRequestId = ++_firstScreenPreloadRequestId;
        _firstScreenPreload = _loadFirstScreenPreload(
          preloadRequestId,
          storiesWithPreload,
        );
      }
    } on AppException catch (e) {
      if (requestId != _storiesRequestId) return;
      _resetFirstScreenPreload();
      _state = _state.copyWith(
        isLoading: false,
        error: e.message,
        firstScreenStories: const [],
      );
      setViewerStories(const []);
    } finally {
      notifyListeners();
    }
  }

  Future<bool> consumeNextFirstScreen() async {
    if (_state.firstScreenStories.isNotEmpty) {
      setViewerStories(_state.firstScreenStories);
      return true;
    }

    final preload = _firstScreenPreload;
    if (preload == null) return false;

    final stories = await preload;
    if (identical(_firstScreenPreload, preload)) {
      _firstScreenPreload = null;
    }

    if (_state.firstScreenStories.isNotEmpty) {
      setViewerStories(_state.firstScreenStories);
      return true;
    }
    if (stories.isEmpty) return false;

    _state = _state.copyWith(firstScreenStories: stories);
    setViewerStories(stories);
    notifyListeners();
    return true;
  }

  Future<void> openStoryById(String storyId) async {
    _resetFirstScreenPreload();
    _state = _state.copyWith(notFound: false, firstScreenStories: const []);
    setViewerStories(const []);
    notifyListeners();

    if (_state.stories == null) {
      await getStories(showFirstScreen: false);
    }

    final list = _state.stories ?? const [];
    final index = list.indexWhere((story) => story.id == storyId);
    if (index < 0) {
      _state = _state.copyWith(notFound: true);
      notifyListeners();
      return;
    }

    final story = list[index];
    _state = _state.copyWith(notFound: false, firstScreenStories: [story]);
    setViewerStories([story]);
    notifyListeners();
  }

  Future<void> markFirstScreenShown() async {
    for (final story in _state.firstScreenStories) {
      if (story.firstScreenMode == StoryFirstScreenMode.once) {
        await sharedPreferences.setBool(
          '${_onceKeyPrefix}_${placeId}_${story.id}',
          true,
        );
      }
    }

    _state = _state.copyWith(firstScreenStories: const []);
    setViewerStories(const []);
    notifyListeners();
  }

  void setViewerStories(List<StoryModel> stories) {
    viewerStories.value = List.of(stories);
  }

  void clearViewerStories() {
    if (viewerStories.value.isEmpty) return;
    setViewerStories(const []);
  }

  void clearNotFound() {
    if (!_state.notFound) return;
    _state = _state.copyWith(notFound: false);
    notifyListeners();
  }

  void _resetFirstScreenPreload() {
    _firstScreenPreloadRequestId++;
    _firstScreenPreload = null;
  }

  Future<List<StoryModel>> _loadFirstScreenPreload(
    int preloadRequestId,
    List<StoryModel> stories,
  ) async {
    try {
      await _precacheStories(stories);
    } catch (_) {}
    if (preloadRequestId != _firstScreenPreloadRequestId) {
      return const [];
    }

    if (_state.firstScreenStories.isNotEmpty) {
      final merged = [..._state.firstScreenStories, ...stories];
      _state = _state.copyWith(firstScreenStories: merged);
      setViewerStories(merged);
      notifyListeners();
      return const [];
    }

    return stories;
  }

  List<StoryModel> _filterFirstScreenStories(List<StoryModel> stories) {
    return stories.where((story) {
      if (!story.isActive) return false;
      switch (story.firstScreenMode) {
        case StoryFirstScreenMode.always:
          return true;
        case StoryFirstScreenMode.once:
          return !(sharedPreferences.getBool(
                '${_onceKeyPrefix}_${placeId}_${story.id}',
              ) ??
              false);
        case StoryFirstScreenMode.disabled:
          return false;
      }
    }).toList();
  }

  Future<void> _precacheStories(Iterable<StoryModel> stories) async {
    final jobs = <Future<void>>[
      for (final story in stories)
        for (final item in story.items)
          if (item.imageUrl.isNotEmpty)
            _precacheUrl(item.imageUrl, mode: story.firstScreenMode),
    ];
    if (jobs.isEmpty) return;
    await Future.wait(jobs);
  }

  Future<void> _precacheUrl(
    String url, {
    required StoryFirstScreenMode mode,
  }) async {
    final provider = storyCacheManager.provider(url, mode: mode);
    final stream = provider.resolve(const ImageConfiguration());
    final completer = Completer<void>();
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (image, synchronousCall) {
        stream.removeListener(listener);
        if (!completer.isCompleted) completer.complete();
      },
      onError: (exception, stackTrace) {
        stream.removeListener(listener);
        if (!completer.isCompleted) {
          completer.completeError(exception, stackTrace);
        }
      },
    );
    stream.addListener(listener);

    await completer.future;
  }

  @override
  void dispose() {
    viewerStories.dispose();
    super.dispose();
  }
}
