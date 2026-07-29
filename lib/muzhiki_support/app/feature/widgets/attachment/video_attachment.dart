import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_route_constant.dart';
import 'package:shimmer/shimmer.dart';

class VideoAttachment extends StatefulWidget {
  final String url;

  const VideoAttachment({super.key, required this.url});

  @override
  State<VideoAttachment> createState() => _VideoAttachmentState();
}

class _VideoAttachmentState extends State<VideoAttachment> {
  late Future<Uint8List?> thumbnail;

  @override
  void initState() {
    super.initState();
    thumbnail = VideoThumbnail.thumbnailData(
      video: widget.url,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
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
        future: thumbnail,
        builder: (context, value) {
          if (value.hasData) {
            return InkWell(
              onTap: () {
                context.pushNamed(
                  SupportRouteConstant.I.videoView,
                  queryParameters: {'url': widget.url},
                  extra: value.data,
                );
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(12.r),
                      child: Image.memory(value.data!, fit: BoxFit.cover),
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
                              color: SupportColors.black17.withValues(
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
