import 'package:muzhiki_stories/config/stories_config.dart';
import 'package:muzhiki_stories/data/repository/stories_repository_impl.dart';
import 'package:muzhiki_stories/presentation/state/stories_view_model.dart';
import 'package:muzhiki_stories/presentation/service/story_cache_manager.dart';

class StoriesModule {
  const StoriesModule._();

  static StoriesViewModel initConfig(StoriesConfig config) {
    return StoriesViewModel(
      repository: StoriesRepositoryImpl(
        dio: config.dio,
        placeId: config.placeId,
        creativesUrl: config.creativesUrl,
      ),
      placeId: config.placeId,
      sharedPreferences: config.sharedPreferences,
      storyCacheManager: StoryCacheManager(),
    );
  }
}
