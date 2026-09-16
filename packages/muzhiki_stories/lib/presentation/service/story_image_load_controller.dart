import 'package:flutter/foundation.dart';
import 'package:muzhiki_stories/data/model/story_enums.dart';
import 'package:muzhiki_stories/presentation/service/story_cache_manager.dart';

class StoryImageLoadController extends ChangeNotifier {
  final _loadedImages = <String>{};
  final _failedImages = <String>{};
  final _imageRebuildKeys = <String, int>{};
  final _reloadingImages = <String>{};

  bool isImageLoaded(String imageUrl) => _loadedImages.contains(imageUrl);

  bool isImageFailed(String imageUrl) => _failedImages.contains(imageUrl);

  int imageRebuildKey(String imageUrl) => _imageRebuildKeys[imageUrl] ?? 0;

  void setImageLoaded(String imageUrl) {
    final addedToLoaded = _loadedImages.add(imageUrl);
    final removedFromFailed = _failedImages.remove(imageUrl);
    if (addedToLoaded || removedFromFailed) notifyListeners();
  }

  void setImageFailed(String imageUrl) {
    final addedToFailed = _failedImages.add(imageUrl);
    final removedFromLoaded = _loadedImages.remove(imageUrl);
    if (addedToFailed || removedFromLoaded) notifyListeners();
  }

  Future<void> reloadImage({
    required String imageUrl,
    required StoryCacheManager storyCacheManager,
    required StoryFirstScreenMode mode,
    bool keepFailedUntilLoaded = false,
  }) async {
    if (!_reloadingImages.add(imageUrl)) return;
    try {
      await storyCacheManager.imageProvider(imageUrl: imageUrl, mode: mode).evict();
    } finally {
      _reloadingImages.remove(imageUrl);
    }
    if (!keepFailedUntilLoaded) _failedImages.remove(imageUrl);
    _loadedImages.remove(imageUrl);
    _imageRebuildKeys[imageUrl] = (_imageRebuildKeys[imageUrl] ?? 0) + 1;
    notifyListeners();
  }

  void removeImage(String imageUrl) {
    final removedFromLoaded = _loadedImages.remove(imageUrl);
    final removedFromFailed = _failedImages.remove(imageUrl);
    final removedImageRebuildKey = _imageRebuildKeys.remove(imageUrl) != null;
    if (removedFromLoaded || removedFromFailed || removedImageRebuildKey) {
      notifyListeners();
    }
  }
}
