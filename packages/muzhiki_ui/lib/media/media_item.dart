import 'dart:io';

import 'package:flutter/material.dart';

enum MediaKind { photo, video }

class MediaItem {
  final MediaKind kind;
  final String? url;
  final String? filePath;
  final String? remarks;
  final String? previewPath;
  final String? heroTag;

  const MediaItem._({
    required this.kind,
    this.url,
    this.filePath,
    this.remarks,
    this.previewPath,
    this.heroTag,
  });

  factory MediaItem.photoNetwork(
    String url, {
    String? remarks,
    String? heroTag,
  }) {
    return MediaItem._(
      kind: MediaKind.photo,
      url: url,
      remarks: remarks,
      heroTag: heroTag ?? url,
    );
  }

  factory MediaItem.photoFile(String path, {String? remarks, String? heroTag}) {
    return MediaItem._(
      kind: MediaKind.photo,
      filePath: path,
      remarks: remarks,
      heroTag: heroTag ?? path,
    );
  }

  factory MediaItem.videoNetwork(
    String url, {
    String? previewPath,
    String? heroTag,
  }) {
    return MediaItem._(
      kind: MediaKind.video,
      url: url,
      previewPath: previewPath,
      heroTag: heroTag ?? url,
    );
  }

  factory MediaItem.videoFile(
    String path, {
    String? previewPath,
    String? heroTag,
  }) {
    return MediaItem._(
      kind: MediaKind.video,
      filePath: path,
      previewPath: previewPath,
      heroTag: heroTag ?? path,
    );
  }

  bool get isPhoto => kind == MediaKind.photo;
  bool get isVideo => kind == MediaKind.video;
  bool get isNetwork => url != null && url!.isNotEmpty;
  bool get hasRemarks => remarks != null && remarks!.trim().isNotEmpty;

  String get identity => url ?? filePath ?? heroTag ?? '';

  ImageProvider get imageProvider {
    if (!isPhoto) {
      throw StateError('imageProvider доступен только для фото');
    }
    if (url != null) return NetworkImage(url!);
    if (filePath != null) return FileImage(File(filePath!));
    throw StateError('Пустой MediaItem: нет данных для фото');
  }

  ImageProvider? get previewProvider {
    final path = previewPath;
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }
    return FileImage(File(path));
  }
}
