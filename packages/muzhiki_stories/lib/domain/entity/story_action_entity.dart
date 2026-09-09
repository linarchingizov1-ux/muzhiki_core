import 'package:muzhiki_stories/data/model/story_enums.dart';
import 'package:muzhiki_stories/data/model/story_model.dart';

enum StoryActionSource {
  fullscreen,
  markdown,
}

class StoryActionEntity {
  final StoryModel story;
  final StoryActionSource source;
  final StoryActionType type;
  final String? link;
  final String? label;

  const StoryActionEntity({
    required this.story,
    required this.source,
    required this.type,
    required this.link,
    required this.label,
  });
}
