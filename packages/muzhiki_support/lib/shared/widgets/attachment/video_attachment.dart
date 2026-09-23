import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_support/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_support/shared/extensions/chat_media_extension.dart';
import 'package:muzhiki_ui/media/media_viewer.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

class VideoAttachment extends StatelessWidget {
  final String url;
  final AppWebsocketChat websocketChat;

  const VideoAttachment({
    super.key,
    required this.url,
    required this.websocketChat,
  });

  List<MediaItem> get media => websocketChat.buildMedia();

  int get index {
    final i = media.indexWhere((e) => e.identity == url);
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
      child: InkWell(
        onTap: () {
          MediaViewer.open(context, items: media, initialIndex: index);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            color: MuzhikiColors.light,
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
                      color: MuzhikiColors.black17.withValues(alpha: 0.2),
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
        ),
      ),
    );
  }
}
