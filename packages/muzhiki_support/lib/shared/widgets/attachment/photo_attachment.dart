import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_support/data/models/socket/socket_connection.dart';
import 'package:muzhiki_support/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_support/shared/extensions/chat_media_extension.dart';
import 'package:muzhiki_ui/media/media_viewer.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';
import 'package:shimmer/shimmer.dart';

class PhotoAttachment extends StatelessWidget {
  final AppWebsocketChat websocketChat;
  final AttachmentsModel attachment;

  const PhotoAttachment({
    super.key,
    required this.attachment,
    required this.websocketChat,
  });

  AppWebsocketChat get webChat => websocketChat;

  List<MediaItem> get media => webChat.buildMedia();

  int get index {
    final i = media.indexWhere((e) => e.identity == attachment.url);
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Hero(
        tag: attachment.url,
        child: CachedNetworkImage(
          maxHeightDiskCache: 200,
          memCacheHeight: 200,
          memCacheWidth: 200,
          maxWidthDiskCache: 200,
          placeholderFadeInDuration: Duration.zero,
          useOldImageOnUrlChange: true,
          imageUrl: attachment.url,
          imageBuilder: (context, imageProvider) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 280.w,
                maxHeight: 280.w,
                minWidth: 77.w,
                minHeight: 77.w,
              ),
              child: InkWell(
                onTap: () {
                  MediaViewer.open(context, items: media, initialIndex: index);
                },
                child: Image(image: imageProvider, fit: BoxFit.cover),
              ),
            );
          },
          errorWidget: (context, url, error) {
            return SizedBox(
              height: 77.w,
              width: 77.h,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(87, 231, 231, 231),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.broken_image_outlined,
                  color: MuzhikiColors.grey,
                  size: 24.r,
                ),
              ),
            );
          },
          placeholder: (context, url) {
            return Shimmer.fromColors(
              baseColor: MuzhikiColors.light,
              highlightColor: MuzhikiColors.white,
              child: Container(
                width: 120.w,
                height: 120.w,
                color: MuzhikiColors.light,
              ),
            );
          },
        ),
      ),
    );
  }
}
