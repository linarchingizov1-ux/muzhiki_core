import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_assets.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_route_constant.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/attachments/local_attachments.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/attachments/upload_data.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/socket_connection.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/view_image_item_model.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/state/attachments/attachments_cubit.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/photo_view_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UploadDataWidgets extends StatefulWidget {
  final Directory directory;
  final AttachmentsCubit attachmentsCubit;
  final LocalAttachmentsModel item;

  const UploadDataWidgets({
    super.key,
    required this.item,
    required this.directory,
    required this.attachmentsCubit,
  });

  @override
  State<UploadDataWidgets> createState() => _UploadDataWidgetsState();
}

class _UploadDataWidgetsState extends State<UploadDataWidgets> {
  Future<String?>? fileName;

  ChatAttachmentType get type => widget.item.when(
    local: (_, type, _, _) => type,
    remote: (_, type, _) => type,
  );

  String? get localPath =>
      widget.item.maybeWhen(local: (_, _, path, _) => path, orElse: () => null);

  UploadDataModel? get remoteData =>
      widget.item.maybeWhen(remote: (_, _, data) => data, orElse: () => null);

  bool get isLoading => widget.item.maybeWhen(
    local: (_, _, _, isLoading) => isLoading,
    orElse: () => false,
  );

  @override
  void initState() {
    super.initState();

    if (type == ChatAttachmentType.video) {
      getFirstFrameVideo();
    }
  }

  @override
  void didUpdateWidget(covariant UploadDataWidgets oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldType = oldWidget.item.when(
      local: (_, type, _, _) => type,
      remote: (_, type, _) => type,
    );

    if (type == ChatAttachmentType.video &&
        (oldWidget.item != widget.item || oldType != type)) {
      getFirstFrameVideo();
    }
  }

  void getFirstFrameVideo() {
    try {
      final videoPath = widget.item.when(
        local: (_, _, path, _) => path,
        remote: (_, _, data) => data.url,
      );

      fileName = VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: widget.directory.path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );

      setState(() {});
    } catch (e, st) {
      final error = AppErrorMapper.I.map(e, st);
      BannerController.I.show(message: error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.w,
      width: 65.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r)),
      child: AnimatedSwitcher(
        key: ValueKey(widget.item),
        duration: const Duration(milliseconds: 500),
        child: Stack(
          children: [
            Positioned.fill(child: _buildContent(context)),
            Positioned(
              right: 0,
              top: 0,
              child: InkWell(
                onTap: () => context.read<AttachmentsCubit>().removeById(
                  widget.item.when(
                    local: (id, _, _, _) => id,
                    remote: (id, _, _) => id,
                  ),
                ),
                child: Icon(
                  Icons.close,
                  size: 16.r,
                  color: SupportColors.black1,
                ),
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: const CircularProgressIndicator(strokeWidth: 1.8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ).animate().fade(duration: 350.ms);
  }

  Widget _buildContent(BuildContext context) {
    switch (type) {
      case ChatAttachmentType.document:
        return Center(
          child: SvgPicture.asset(
            width: 25.w,
            height: 25.w,
            SupportAssets.I.svg.file,
            colorFilter: ColorFilter.mode(SupportColors.grey, BlendMode.srcIn),
          ),
        );

      case ChatAttachmentType.video:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: FutureBuilder<String?>(
            future: fileName,
            builder: (context, asyncSnapshot) {
              if (!asyncSnapshot.hasData) {
                return Shimmer.fromColors(
                  baseColor: SupportColors.light,
                  highlightColor: SupportColors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 231, 231, 231),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
              }

              final remote = remoteData;

              return InkWell(
                onTap: remote == null
                    ? null
                    : () {
                        context.pushNamed(
                          SupportRouteConstant.I.videoView,
                          queryParameters: {'url': remote.url},
                          extra: asyncSnapshot.data,
                        );
                      },
                child: Image.file(File(asyncSnapshot.data!), fit: BoxFit.cover),
              );
            },
          ),
        );

      case ChatAttachmentType.photo:
        final path = localPath;
        final remote = remoteData;

        final tag = remote?.url ?? path;

        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: path != null
              ? Image.file(File(path), fit: BoxFit.cover)
              : InkWell(
                  onTap: remote == null
                      ? null
                      : () {
                          final image = ViewerImageItem.network(remote.url);

                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: true,
                              transitionDuration: const Duration(
                                milliseconds: 300,
                              ),
                              reverseTransitionDuration: const Duration(
                                milliseconds: 300,
                              ),
                              pageBuilder: (_, _, _) {
                                return PhotoViewerPage(
                                  heroTagPrefix: tag,
                                  images: [image],
                                  initialIndex: 0,
                                );
                              },
                            ),
                          );
                        },
                  child: Hero(
                    tag: tag ?? '',
                    child: Image.network(
                      remote!.url,
                      filterQuality: FilterQuality.medium,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        );
    }
  }
}
