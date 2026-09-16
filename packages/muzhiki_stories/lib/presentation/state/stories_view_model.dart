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

  final _onceStoriesKeyPrefix = 'stories_once';

  final StoriesRepository repository;
  final int placeId;
  final SharedPreferences sharedPreferences;
  final StoryCacheManager storyCacheManager;

  final viewerStories = ValueNotifier<List<StoryModel>>(const []);

  List<StoryModel> _firstScreenStories = const [];

  StoriesState _state = const StoriesState();
  StoriesState get state => _state;

  int _storiesRequestId = 0;
  int _firstScreenPreloadRequestId = 0;

  Future<List<StoryModel>>? _firstScreenPreloadStories;

  Future<void> getStories({
    bool isRefresh = false,
    bool showFirstScreen = true,
  }) async {
    if (_state.stories != null && !isRefresh) return;

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
      final List<StoryModel> storiesWithoutPreload = [];
      final List<StoryModel> storiesWithPreload = [];
      for (final story in storiesForFirstScreen) {
        (story.firstScreenPreload ? storiesWithPreload : storiesWithoutPreload)
            .add(story);
      }

      _state = _state.copyWith(isLoading: false, stories: stories);
      _firstScreenStories = List.of(storiesWithoutPreload);

      if (storiesWithPreload.isNotEmpty) {
        final preloadRequestId = ++_firstScreenPreloadRequestId;
        _firstScreenPreloadStories = _precacheFirstScreenStories(
          preloadRequestId,
          storiesWithPreload,
        );
      }
    } on AppException catch (e) {
      if (requestId != _storiesRequestId) return;
      _resetFirstScreenPreload();
      _state = _state.copyWith(isLoading: false, error: e.message);
      clearViewerStories();
    } finally {
      notifyListeners();
    }
  }

  Future<bool> openFirstScreenStories() async {
    if (_firstScreenStories.isEmpty) {
      final preloadStoriesFuture = _firstScreenPreloadStories;
      if (preloadStoriesFuture == null) return false;

      final stories = await preloadStoriesFuture;
      if (identical(_firstScreenPreloadStories, preloadStoriesFuture)) {
        _firstScreenPreloadStories = null;
      }

      if (_firstScreenStories.isEmpty) {
        if (stories.isEmpty) return false;
        _firstScreenStories = List.of(stories);
      }
    }

    final stories = _firstScreenStories;
    if (stories.isEmpty) return false;

    await _precacheFirstImage(stories.first);
    setViewerStories(stories);
    return true;
  }

  Future<void> openStoryById(String storyId) async {
    _resetFirstScreenPreload();
    _state = _state.copyWith(notFound: false);
    clearViewerStories();
    notifyListeners();

    if (_state.stories == null) {
      await getStories(showFirstScreen: false);
    }

    final stories = _state.stories ?? const [];
    final storyIndex = stories.indexWhere((story) => story.id == storyId);
    if (storyIndex < 0) {
      _state = _state.copyWith(notFound: true);
      notifyListeners();
      return;
    }

    final story = stories[storyIndex];
    _state = _state.copyWith(notFound: false);
    setViewerStories([story]);
    notifyListeners();
  }

  void clearNotFound() {
    if (!_state.notFound) return;
    _state = _state.copyWith(notFound: false);
    notifyListeners();
  }

  Future<void> markFirstScreenStoriesViewed(Iterable<String> viewedIds) async {
    final ids = viewedIds.toSet();

    for (final story in _firstScreenStories) {
      if (story.firstScreenMode != StoryFirstScreenMode.once) continue;
      if (!ids.contains(story.id)) continue;

      await sharedPreferences.setBool(_onceStoriesKey(story.id), true);
    }

    _firstScreenStories = const [];
    notifyListeners();
  }

  void setViewerStories(List<StoryModel> stories) {
    viewerStories.value = List.of(stories);
  }

  void clearViewerStories() {
    if (viewerStories.value.isEmpty) return;
    setViewerStories(const []);
  }

  void _resetFirstScreenPreload() {
    _firstScreenPreloadRequestId++;
    _firstScreenPreloadStories = null;
    _firstScreenStories = const [];
  }

  Future<List<StoryModel>> _precacheFirstScreenStories(
    int preloadRequestId,
    List<StoryModel> stories,
  ) async {
    try {
      await _precacheStories(stories);
    } catch (_) {}
    if (preloadRequestId != _firstScreenPreloadRequestId) {
      return const [];
    }

    if (_firstScreenStories.isNotEmpty) {
      _firstScreenStories = [..._firstScreenStories, ...stories];
      setViewerStories(_firstScreenStories);
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
          return !(sharedPreferences.getBool(_onceStoriesKey(story.id)) ??
              false);
        case StoryFirstScreenMode.disabled:
          return false;
      }
    }).toList();
  }

  String _onceStoriesKey(String storyId) =>
      '${_onceStoriesKeyPrefix}_${placeId}_$storyId';

  Future<void> _precacheFirstImage(StoryModel story) async {
    if (story.items.isEmpty) return;
    final imageUrl = story.items.first.imageUrl;
    if (imageUrl.isEmpty) return;
    try {
      if (!await storyCacheManager.isImageCached(
        imageUrl: imageUrl,
        mode: story.firstScreenMode,
      )) {
        return;
      }
      await _precacheUrl(imageUrl: imageUrl, mode: story.firstScreenMode);
    } catch (_) {}
  }

  Future<void> _precacheStories(Iterable<StoryModel> stories) async {
    for (final story in stories) {
      await Future.wait([
        for (final item in story.items)
          if (item.imageUrl.isNotEmpty)
            _precacheUrl(imageUrl: item.imageUrl, mode: story.firstScreenMode),
      ]);
    }
  }

  Future<void> _precacheUrl({
    required String imageUrl,
    required StoryFirstScreenMode mode,
  }) async {
    final imageProvider = storyCacheManager.imageProvider(
      imageUrl: imageUrl,
      mode: mode,
    );
    final stream = imageProvider.resolve(const ImageConfiguration());
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
