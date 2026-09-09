import 'package:muzhiki_stories/data/model/story_model.dart';

class StoriesState {
  final List<StoryModel>? stories;
  final List<StoryModel> firstScreenStories;
  final bool isLoading;
  final String? error;
  final bool notFound;

  const StoriesState({
    this.stories,
    this.firstScreenStories = const [],
    this.isLoading = true,
    this.error,
    this.notFound = false,
  });

  StoriesState copyWith({
    List<StoryModel>? stories,
    List<StoryModel>? firstScreenStories,
    bool? isLoading,
    String? error,
    bool? notFound,
    bool clearError = false,
  }) {
    return StoriesState(
      stories: stories ?? this.stories,
      firstScreenStories: firstScreenStories ?? this.firstScreenStories,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      notFound: notFound ?? this.notFound,
    );
  }
}
