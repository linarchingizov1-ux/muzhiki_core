import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:muzhiki_ui/media/media_item.dart';

/// Совместимая обёртка над [MediaItem] для фото.
@Deprecated('Use MediaItem from package:muzhiki_ui/media/media_viewer.dart')
class ViewerImageItem {
  final String? url;
  final String? filePath;
  final XFile? xfile;
  final String? remarks;

  const ViewerImageItem._({this.url, this.filePath, this.xfile, this.remarks});

  factory ViewerImageItem.network(String url, {String? remarks}) {
    return ViewerImageItem._(url: url, remarks: remarks);
  }

  factory ViewerImageItem.filePath(String path, {String? remarks}) {
    return ViewerImageItem._(filePath: path, remarks: remarks);
  }

  factory ViewerImageItem.xFile(XFile file, {String? remarks}) {
    return ViewerImageItem._(xfile: file, remarks: remarks);
  }

  MediaItem toMediaItem() {
    if (url != null) {
      return MediaItem.photoNetwork(url!, remarks: remarks, heroTag: url);
    }
    if (xfile != null) {
      return MediaItem.photoFile(
        xfile!.path,
        remarks: remarks,
        heroTag: xfile!.path,
      );
    }
    if (filePath != null) {
      return MediaItem.photoFile(
        filePath!,
        remarks: remarks,
        heroTag: filePath,
      );
    }
    throw Exception('Пустой ViewerImageItem');
  }

  ImageProvider get imageProvider {
    if (url != null) return NetworkImage(url!);
    if (xfile != null) return FileImage(File(xfile!.path));
    if (filePath != null) return FileImage(File(filePath!));

    throw Exception(
      'Пустой ViewerImageItem: нет данных для отображения изображения',
    );
  }

  bool get hasRemarks => remarks != null && remarks!.trim().isNotEmpty;

  ImageProvider? get remarksProvider {
    if (!hasRemarks) return null;
    return NetworkImage(remarks!);
  }
}

@Deprecated('Use MediaItem directly')
class ViewerParser {
  static ViewerImageItem parse(dynamic item) {
    if (item is ViewerImageItem) return item;

    if (item is XFile) {
      return ViewerImageItem.xFile(item);
    }

    if (item is String) {
      final isNetwork =
          item.startsWith('http://') || item.startsWith('https://');

      return isNetwork
          ? ViewerImageItem.network(item)
          : ViewerImageItem.filePath(item);
    }

    throw Exception('Unsupported image type: ${item.runtimeType}');
  }

  static List<ViewerImageItem> parseList(List items) {
    return items.map(parse).toList();
  }
}
