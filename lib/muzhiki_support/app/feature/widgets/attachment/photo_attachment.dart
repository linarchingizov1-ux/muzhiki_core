import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/socket_connection.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/view_image_item_model.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/muzhiki_support/app/extension/websocket_extension.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/photo_view_widget.dart';
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

  List<ViewerImageItem> get media => webChat.buildImages();

  int get index => media.indexWhere((e) => e.url == attachment.url);

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
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      transitionDuration: const Duration(milliseconds: 300),
                      reverseTransitionDuration: const Duration(
                        milliseconds: 300,
                      ),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return PhotoViewerPage(
                          heroTagPrefix: attachment.url,
                          images: media,
                          initialIndex: index,
                        );
                      },
                    ),
                  );
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
                child: Icon(Icons.image_not_supported_sharp, size: 50.r),
              ),
            );
          },
          placeholder: (context, url) {
            return Shimmer.fromColors(
              baseColor: SupportColors.light,
              highlightColor: SupportColors.white,
              child: SizedBox(
                height: 77.w,
                width: 77.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(87, 231, 231, 231),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.image, size: 50.r),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
