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

  ImageProvider provider(
    String url, {
    required StoryFirstScreenMode mode,
  }) {
    final ImageProvider base = mode == StoryFirstScreenMode.always
        ? CachedNetworkImageProvider(url, cacheManager: _disk)
        : NetworkImage(url);
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return base;
    return ResizeImage(base, height: views.first.physicalSize.height.round());
  }

  Future<void> clear() async {
    await _disk.emptyCache();
    final cache = PaintingBinding.instance.imageCache;
    cache.clear();
    cache.clearLiveImages();
  }
}
