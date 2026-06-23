import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/app/support/state/chat/chat_cubit.dart';
import 'package:muzhiki_core/app/support/ui/widgets/photo_view_widget.dart';
import 'package:muzhiki_core/app/support/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/socket_connection.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/viewer_image.dart';
import 'package:muzhiki_core/app/support/websocket/extension/websocket_extension.dart';
import 'package:muzhiki_core/dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/dependecies/service/app_banner/app_banner_controller.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:open_filex/open_filex.dart';

class ChatAttachment extends StatelessWidget {
  final Directory directory;
  final AppWebsocketChat websocketChat;
  final AttachmentsModel attachment;
  final ChatCubit chatCubit;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const ChatAttachment({
    required this.directory,
    required this.chatCubit,
    required this.websocketChat,
    super.key,
    required this.attachment,
    this.onTap,
    this.onRemove,
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
              baseColor: Color.fromARGB(255, 231, 231, 231),
              highlightColor: Colors.white,
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
  final String url;
  final Directory directory;

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
                  '/video-view',
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
                              color: Color.fromARGB(
                                255,
                                17,
                                17,
                                17,
                              ).withValues(alpha: 0.2),
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
              baseColor: Color.fromARGB(255, 231, 231, 231),
              highlightColor: Colors.white,
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
  final Directory directory;
  final String url;

  const _DocumentAttachment({required this.url, required this.directory});

  @override
  State<_DocumentAttachment> createState() => _DocumentAttachmentState();
}

class _DocumentAttachmentState extends State<_DocumentAttachment> {
  final ValueNotifier<double> progress = ValueNotifier<double>(0.0);

  bool isDownloading = false;
  bool isDownloaded = false;
  bool isOpening = false;

  @override
  void initState() {
    super.initState();
    _checkIfFileExists();
  }

  @override
  void dispose() {
    progress.dispose();
    super.dispose();
  }

  String get _fileName => widget.url.split('/').last.split('?').first;

  String get _path {
    return '${widget.directory.path}/$_fileName';
  }

  Future<void> _checkIfFileExists() async {
    final file = File(_path);
    final exists = await file.exists();

    if (!mounted) return;

    setState(() {
      isDownloaded = exists;
    });
  }

  Future<void> downloadFile() async {
    if (isDownloading || isOpening) return;

    final path = _path;
    final file = File(path);

    if (await file.exists()) {
      setState(() {
        isDownloaded = true;
      });
      await _openFile(path);
      return;
    }

    try {
      setState(() {
        isDownloading = true;
        isDownloaded = false;
      });

      progress.value = 0.0;

      final dio = Dio();

      await dio.download(
        widget.url,
        path,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            progress.value = received / total;
          }
        },
      );

      if (!mounted) return;

      setState(() {
        isDownloading = false;
        isDownloaded = true;
      });

      await _openFile(path);
    } catch (e, st) {
      if (!mounted) return;

      setState(() {
        isDownloading = false;
        isDownloaded = false;
      });

      progress.value = 0.0;

      final error = AppErrorMapper.I.map(e, st);
      BannerController.I.show(message: error.message);
    }
  }

  Future<void> _openFile(String path) async {
    if (isOpening) return;

    setState(() {
      isOpening = true;
    });

    final result = await OpenFilex.open(path);

    if (result.type == ResultType.noAppToOpen) {
      BannerController.I.show(
        message: 'На устройстве нет приложения для открытия этого файла',
      );
    }

    if (!mounted) return;

    setState(() {
      isOpening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = isDownloading || isOpening;

    return InkWell(
      onTap: isBusy ? null : downloadFile,
      child: Container(
        height: 77.w,
        width: 77.w,
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Color.fromARGB(255, 231, 231, 231),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: SvgPicture.asset(
                  width: 25.w,
                  height: 25.w,
                  "assets/svg/file.svg",
                  colorFilter: ColorFilter.mode(
                    Color.fromARGB(255, 123, 123, 123),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: ValueListenableBuilder<double>(
                valueListenable: progress,
                builder: (context, value, child) {
                  if (isDownloading) {
                    return Text(
                      '${(value * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Color.fromARGB(255, 123, 123, 123),
                      ),
                    );
                  }

                  if (isDownloaded || isOpening) {
                    return SizedBox.shrink();
                  }

                  return Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    child: Icon(
                      Icons.file_download_outlined,
                      size: 15.r,
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
