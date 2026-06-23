import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:camera/camera.dart';

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
