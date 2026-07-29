import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
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
  Future<Uint8List?> thumbnail = Future.value(null);

  ChatAttachmentType get type => widget.item.when(
    local: (_, type, _, _, _) => type,
    remote: (_, type, _) => type,
  );

  String? get localPath => widget.item.maybeWhen(
    local: (_, _, path, _, _) => path,
    orElse: () => null,
  );

  UploadDataModel? get remoteData =>
      widget.item.maybeWhen(remote: (_, _, data) => data, orElse: () => null);

  String? get attachmentFileName => widget.item.maybeWhen(
    local: (_, _, _, fileName, _) => fileName,
    remote: (_, _, data) => data.fileName,
    orElse: () => null,
  );

  bool get isLoading => widget.item.maybeWhen(
    local: (_, _, _, _, isLoading) => isLoading,
    orElse: () => false,
  );

  String get id =>
      widget.item.when(local: (id, _, _, _, _) => id, remote: (id, _, _) => id);

  @override
  void initState() {
    super.initState();

    if (type == ChatAttachmentType.video) {
      _getVideoThumbnail();
    }
  }

  @override
  void didUpdateWidget(covariant UploadDataWidgets oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.item != widget.item && type == ChatAttachmentType.video) {
      _getVideoThumbnail();
    }
  }

  Future<void> _getVideoThumbnail() async {
    final videoPath = widget.item.when(
      local: (_, _, path, _, _) => path,
      remote: (_, _, data) => data.url,
    );

    try {
      final result = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
        maxWidth: 280,
      );

      if (!mounted) return;

      setState(() {
        thumbnail = Future.value(result);
      });
    } catch (e, st) {
      final error = AppErrorMapper.I.map(e, st);

      BannerController.I.showError(error: error, message: error.message);
    }
  }

  String get documentIcon {
    final extension = attachmentFileName?.split('.').last.toLowerCase();

    return switch (extension) {
      'pdf' => SupportAssets.I.png.pdf,
      'doc' || 'docx' => SupportAssets.I.png.doc,
      'xls' || 'xlsx' => SupportAssets.I.png.xls,
      'ppt' || 'pptx' => SupportAssets.I.png.ppt,
      'zip' || 'rar' || '7z' => SupportAssets.I.png.zip,
      'txt' => SupportAssets.I.png.txt,
      _ => SupportAssets.I.png.file,
    };
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
                onTap: () {
                  context.read<AttachmentsCubit>().removeById(id);
                },
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
        return _buildDocument();

      case ChatAttachmentType.video:
        return _buildVideo();

      case ChatAttachmentType.photo:
        return _buildPhoto();
    }
  }

  Widget _buildDocument() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(5.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: SupportColors.white,
        ),
        child: Image.asset(documentIcon, width: 25.r, height: 25.r),
      ),
    );
  }

  Widget _buildVideo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: FutureBuilder<Uint8List?>(
        future: thumbnail,
        builder: (context, snapshot) {
          final thumbnail = snapshot.data;

          if (thumbnail == null) {
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
                      extra: thumbnail,
                    );
                  },
            child: Image.memory(thumbnail, fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  Widget _buildPhoto() {
    final path = localPath;
    final remote = remoteData;

    if (path != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.file(File(path), fit: BoxFit.cover),
      );
    }

    if (remote == null) {
      return const SizedBox.shrink();
    }

    final tag = remote.url;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: () {
          final image = ViewerImageItem.network(remote.url);

          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              transitionDuration: const Duration(milliseconds: 300),
              reverseTransitionDuration: const Duration(milliseconds: 300),
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
          tag: tag,
          child: Image.network(
            remote.url,
            filterQuality: FilterQuality.medium,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
