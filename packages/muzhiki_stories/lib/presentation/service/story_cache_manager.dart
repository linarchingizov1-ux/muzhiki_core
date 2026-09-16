import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:muzhiki_stories/data/model/story_enums.dart';

class StoryCacheManager {
  StoryCacheManager()
    : _disk = CacheManager(
        Config(
          'muzhiki_stories_images',
          stalePeriod: const Duration(days: 14),
          maxNrOfCacheObjects: 30,
        ),
      );

  final CacheManager _disk;

  ImageProvider imageProvider({
    required String imageUrl,
    required StoryFirstScreenMode mode,
  }) {
    final ImageProvider base = mode == StoryFirstScreenMode.always
        ? CachedNetworkImageProvider(imageUrl, cacheManager: _disk)
        : NetworkImage(imageUrl);
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return base;
    return ResizeImage(base, height: views.first.physicalSize.height.round());
  }

  Future<bool> isImageCached({
    required String imageUrl,
    required StoryFirstScreenMode mode,
  }) async {
    if (imageUrl.isEmpty) return false;

    if (PaintingBinding.instance.imageCache.containsKey(
      imageProvider(imageUrl: imageUrl, mode: mode),
    )) {
      return true;
    }

    if (mode != StoryFirstScreenMode.always) return false;

    final fileInfo = await _disk.getFileFromCache(imageUrl);
    return fileInfo != null;
  }

  Future<void> clear() async {
    await _disk.emptyCache();
    final cache = PaintingBinding.instance.imageCache;
    cache.clear();
    cache.clearLiveImages();
  }

  Future<void> evict({
    required String imageUrl,
    required StoryFirstScreenMode mode,
  }) async {
    if (imageUrl.isEmpty) return;

    try {
      await imageProvider(imageUrl: imageUrl, mode: mode).evict();
    } catch (_) {}

    if (mode != StoryFirstScreenMode.always) return;

    try {
      await _disk.removeFile(imageUrl);
    } catch (_) {}
  }
}
