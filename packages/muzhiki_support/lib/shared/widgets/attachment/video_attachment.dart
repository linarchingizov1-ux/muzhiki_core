import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_support/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_support/shared/extensions/chat_media_extension.dart';
import 'package:muzhiki_ui/media/media_viewer.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoAttachment extends StatefulWidget {
  final Directory directory;
  final String url;
  final AppWebsocketChat websocketChat;

  const VideoAttachment({
    super.key,
    required this.url,
    required this.directory,
    required this.websocketChat,
  });

  @override
  State<VideoAttachment> createState() => _VideoAttachmentState();
}

class _VideoAttachmentState extends State<VideoAttachment> {
  late Future<String?> fileName;

  @override
  void initState() {
    fileName = VideoThumbnail.thumbnailFile(
      video: widget.url,
      thumbnailPath: widget.directory.path,
      imageFormat: ImageFormat.JPEG,
      quality: 75,
    );
    super.initState();
  }

  List<MediaItem> get media => widget.websocketChat.buildMedia();

  int get index {
    final i = media.indexWhere((e) => e.identity == widget.url);
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 280.w,
        maxHeight: 280.w,
        minHeight: 77.w,
        minWidth: 77.w,
      ),
      child: FutureBuilder(
        future: fileName,
        builder: (context, value) {
          if (value.hasData) {
            return InkWell(
              onTap: () {
                final preview = value.data;
                final items = media.map((item) {
                  if (item.identity == widget.url && item.isVideo) {
                    return MediaItem.videoNetwork(
                      item.url!,
                      previewPath: preview,
                      heroTag: item.heroTag,
                    );
                  }
                  return item;
                }).toList();

                MediaViewer.open(context, items: items, initialIndex: index);
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(fit: BoxFit.cover, File(value.data!)),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final size = constraints.biggest.shortestSide;
                          final iconSize = size * 0.25;
                          final containerSize = size * 0.35;

                          return Container(
                            width: containerSize,
                            height: containerSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MuzhikiColors.black17.withValues(
                                alpha: 0.2,
                              ),
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              size: iconSize,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Shimmer.fromColors(
              baseColor: MuzhikiColors.light,
              highlightColor: MuzhikiColors.white,
              child: SizedBox(
                height: 77.w,
                width: 77.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(87, 231, 231, 231),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.video_collection_outlined, size: 50.r),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
