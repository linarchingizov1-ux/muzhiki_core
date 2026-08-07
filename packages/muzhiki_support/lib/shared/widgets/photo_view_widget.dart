import 'package:flutter/material.dart';
import 'package:muzhiki_support/data/models/view_image_item_model.dart';
import 'package:muzhiki_ui/media/media_viewer.dart';

/// Совместимый алиас. Предпочтительно вызывайте [MediaViewer.open].
@Deprecated('Use MediaViewer from package:muzhiki_ui')
class PhotoViewerPage extends StatelessWidget {
  final List<ViewerImageItem> images;
  final int initialIndex;
  final String? heroTagPrefix;

  const PhotoViewerPage({
    this.heroTagPrefix,
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return MediaViewer(
      items: images.map((e) => e.toMediaItem()).toList(),
      initialIndex: initialIndex,
    );
  }
}
