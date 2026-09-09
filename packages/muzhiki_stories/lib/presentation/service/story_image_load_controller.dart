import 'package:flutter/foundation.dart';
import 'package:muzhiki_stories/data/model/story_enums.dart';
import 'package:muzhiki_stories/presentation/service/story_cache_manager.dart';

class StoryImageLoadController extends ChangeNotifier {
  final loadedImages = <String>{};
  final failedImages = <String>{};
  final rebuildKeys = <String, int>{};

  bool isImageLoaded(String url) => loadedImages.contains(url);

  bool isImageFailed(String url) => failedImages.contains(url);

  void setImageLoaded(String url) {
    final addedToLoaded = loadedImages.add(url);
    final removedFromFailed = failedImages.remove(url);
    if (!addedToLoaded && !removedFromFailed) return;
    notifyListeners();
  }

  void setImageFailed(String url) {
    final addedToFailed = failedImages.add(url);
    final removedFromLoaded = loadedImages.remove(url);
    if (!addedToFailed && !removedFromLoaded) return;
    notifyListeners();
  }

  void setImageLoading(String url) {
    final removedFromLoaded = loadedImages.remove(url);
    final removedFromFailed = failedImages.remove(url);
    if (!removedFromLoaded && !removedFromFailed) return;
    notifyListeners();
  }

  Future<void> reloadImage({
    required String url,
    required StoryCacheManager cacheManager,
    required StoryFirstScreenMode mode,
    bool keepFailedUntilLoaded = false,
  }) async {
    await cacheManager.provider(url, mode: mode).evict();
    if (!keepFailedUntilLoaded) failedImages.remove(url);
    loadedImages.remove(url);
    rebuildKeys[url] = (rebuildKeys[url] ?? 0) + 1;
    notifyListeners();
  }

  void removeImage(String url) {
    final removedFromLoaded = loadedImages.remove(url);
    final removedFromFailed = failedImages.remove(url);
    final removedRebuildKey = rebuildKeys.remove(url) != null;
    if (!removedFromLoaded && !removedFromFailed && !removedRebuildKey) {
      return;
    }
    notifyListeners();
  }
}
