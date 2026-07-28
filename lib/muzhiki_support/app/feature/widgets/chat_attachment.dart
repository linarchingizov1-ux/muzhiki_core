import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_assets.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_route_constant.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/socket_connection.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/view_image_item_model.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/muzhiki_support/app/extension/websocket_extension.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/state/chat/chat_cubit.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/photo_view_widget.dart';
import 'package:open_filex/open_filex.dart';
import 'package:shimmer/shimmer.dart';
import 'package:talker/talker.dart';
import 'package:uuid/v4.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ChatAttachment extends StatelessWidget {
  final ChatCubit chatCubit;
  final Directory directory;
  final AppWebsocketChat websocketChat;
  final AttachmentsModel attachment;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const ChatAttachment({
    required this.chatCubit,
    required this.websocketChat,
    super.key,
    required this.attachment,
    this.onTap,
    this.onRemove,
    required this.directory,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: chatCubit,
      child: Builder(
        builder: (context) {
          switch (attachment.type) {
            case ChatAttachmentType.photo:
              return _PhotoAttachment(
                attachment: attachment,
                websocketChat: websocketChat,
              );
            case ChatAttachmentType.video:
              return _VideoAttachment(
                url: attachment.url,
                directory: directory,
              );
            case ChatAttachmentType.document:
              return _DocumentAttachment(
                fileName: attachment.name ?? "Файл",
                url: attachment.url,
                directory: directory,
              );
          }
        },
      ),
    );
  }
}

class _PhotoAttachment extends StatelessWidget {
  final AppWebsocketChat websocketChat;
  final AttachmentsModel attachment;

  const _PhotoAttachment({
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
                      opaque: true,
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

class _VideoAttachment extends StatefulWidget {
  final Directory directory;
  final String url;

  const _VideoAttachment({required this.url, required this.directory});

  @override
  State<_VideoAttachment> createState() => _VideoAttachmentState();
}

class _VideoAttachmentState extends State<_VideoAttachment> {
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

class _DocumentAttachment extends StatefulWidget {
  const _DocumentAttachment({
    required this.url,
    required this.directory,
    required this.fileName,
  });

  final Directory directory;
  final String url;
  final String fileName;

  @override
  State<_DocumentAttachment> createState() => _DocumentAttachmentState();
}

class _DocumentAttachmentState extends State<_DocumentAttachment> {
  String path = "";
  int totalFileSize = 0;
  bool isDownloadsFile = false;
  bool isOpenFile = false;
  final downloadsClient = Dio();
  final uuid = UuidV4();
  final talker = Talker();

  @override
  void initState() {
    super.initState();
    path = '${widget.directory.path}/${widget.fileName}';
    _init();
  }

  Future<void> _init() async {
    isDownloadsFile = await File(path).exists();

    if (isDownloadsFile) {
      totalFileSize = await File(path).length();
    }

    if (mounted) setState(() {});
  }

  Future<void> downloads() async {
    if (isDownloadsFile) return;

    try {
      await downloadsClient.download(
        widget.url,
        path,
        onReceiveProgress: (received, total) {
          if (total > 0 && totalFileSize != total) {
            setState(() => totalFileSize = total);
          }
        },
      );

      if (!mounted) return;

      setState(() => isDownloadsFile = true);
    } catch (e, st) {
      talker.error('Ошибка скачивания файла: $e, $st');
    }
  }

  Future<void> openReadFile() async {
    if (isOpenFile) return;

    if (!isDownloadsFile) {
      await downloads();
    }

    if (!mounted) return;

    setState(() => isOpenFile = true);

    final result = await OpenFilex.open(path);

    if (mounted && result.type == ResultType.done) {
      setState(() => isOpenFile = false);
    }

    talker.debug('Результат открытия файла: ${result.type}');
  }

  String get fileSizeText {
    if (totalFileSize <= 0) return '';

    if (totalFileSize < 1024) {
      return '$totalFileSize Б';
    }

    if (totalFileSize < 1024 * 1024) {
      return '${(totalFileSize / 1024).toStringAsFixed(1)} КБ';
    }

    return '${(totalFileSize / 1024 / 1024).toStringAsFixed(1)} МБ';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDownloadsFile ? openReadFile : downloads,
      child: Row(
        spacing: 5.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 35.r),
            child: SvgPicture.asset(
              SupportAssets.I.svg.file,
              width: 35.r,
              height: 35.r,
              colorFilter: ColorFilter.mode(
                SupportColors.grey,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Stack(
              children: [
                Text.rich(
                  TextSpan(
                    text: '${widget.fileName}\n',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: [
                          if (fileSizeText.isNotEmpty) fileSizeText,
                          if (isDownloadsFile) ' • Загружен',
                        ].join(),
                        style: TextStyle(
                          color: isDownloadsFile
                              ? SupportColors.green
                              : SupportColors.darkGrey,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isOpenFile)
                  Positioned.fill(
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
