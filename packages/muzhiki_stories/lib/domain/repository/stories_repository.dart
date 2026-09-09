import 'package:muzhiki_stories/data/model/story_model.dart';

abstract class StoriesRepository {
  Future<List<StoryModel>> getStories();
}
