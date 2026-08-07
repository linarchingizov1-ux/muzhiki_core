import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_dependencies/network/exception/network_map_error.dart';
import 'package:muzhiki_dependencies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';
import 'package:muzhiki_support/data/models/socket/attachments/local_attachments.dart';
import 'package:muzhiki_support/data/models/socket/attachments/upload_data.dart';
import 'package:muzhiki_support/data/models/socket/socket_connection.dart';
import 'package:muzhiki_support/features/chat/state/attachments_cubit.dart';
import 'package:muzhiki_support/shared/utils/file_icon_mapper.dart';
import 'package:muzhiki_ui/media/media_viewer.dart';
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
  String? _videoThumbnail;

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

    if (oldWidget.item != widget.item) {
      _videoThumbnail = null;

      if (type == ChatAttachmentType.video) {
        _getVideoThumbnail();
      }
    }
  }

  Future<void> _getVideoThumbnail() async {
    final videoPath = widget.item.when(
      local: (_, _, path, _, _) => path,
      remote: (_, _, data) => data.url,
    );

    try {
      final result = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: widget.directory.path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );

      if (!mounted) return;

      setState(() {
        _videoThumbnail = result;
      });
    } catch (e, st) {
      final error = AppErrorMapper.I.map(e, st);

      BannerController.I.showError(error: error, message: error.message);
    }
  }

  String get documentIcon => FileIconMapper.forFileName(attachmentFileName);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.w,
      width: 65.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11.r)),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: MuzhikiColors.light.withValues(alpha: 0.6),
            ),
          ),
          Positioned.fill(child: _buildContent(context)),

          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: () {
                context.read<AttachmentsCubit>().removeById(id);
              },
              child: Icon(Icons.close, size: 16.r, color: MuzhikiColors.black1),
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
    );
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
          color: MuzhikiColors.white,
        ),
        child: Image.asset(documentIcon, width: 25.r, height: 25.r),
      ),
    );
  }

  Widget _buildVideo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeOutCubic,
        child: _videoThumbnail == null
            ? Shimmer.fromColors(
                key: const ValueKey('loading'),
                baseColor: MuzhikiColors.light,
                highlightColor: MuzhikiColors.white,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 231, 231, 231),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              )
            : _buildVideoThumbnail(key: const ValueKey('thumbnail')),
      ),
    );
  }

  Widget _buildVideoThumbnail({required Key key}) {
    final remote = remoteData;

    return InkWell(
      key: key,
      onTap: remote == null
          ? null
          : () {
              MediaViewer.open(
                context,
                items: [
                  MediaItem.videoNetwork(
                    remote.url,
                    previewPath: _videoThumbnail,
                    heroTag: remote.url,
                  ),
                ],
              );
            },
      child: Image.file(
        File(_videoThumbnail!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Widget _buildPhoto() {
    final path = localPath;
    final remote = remoteData;

    if (path != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox.expand(
          child: Image.file(
            File(path),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
          ),
        ),
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
          MediaViewer.open(
            context,
            items: [MediaItem.photoNetwork(remote.url, heroTag: tag)],
          );
        },
        child: Hero(
          tag: tag,
          child: SizedBox.expand(
            child: Image.network(
              remote.url,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
      ),
    );
  }
}
