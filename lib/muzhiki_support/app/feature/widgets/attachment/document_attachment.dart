import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_assets.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

class DocumentAttachment extends StatefulWidget {
  const DocumentAttachment({
    super.key,
    required this.url,
    required this.directory,
    required this.fileName,
  });

  final Directory directory;
  final String url;
  final String fileName;

  @override
  State<DocumentAttachment> createState() => _DocumentAttachmentState();
}

class _DocumentAttachmentState extends State<DocumentAttachment> {
  int totalFileSize = 0;

  bool isCheckingFile = true;
  bool isDownloading = false;
  bool isDownloadsFile = false;
  bool isOpenFile = false;

  final downloadsClient = Dio();

  String get localFileId {
    final uri = Uri.parse(widget.url);

    return sha256.convert(utf8.encode(uri.path)).toString();
  }

  String get path {
    final extension = p.extension(widget.fileName);

    return p.join(widget.directory.path, '$localFileId$extension');
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final file = File(path);

    try {
      final exists = await file.exists();

      if (exists) {
        final size = await file.length();

        totalFileSize = size;
        isDownloadsFile = true;
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          isCheckingFile = false;
        });
      }
    }
  }

  String get fileExtension {
    return p.extension(widget.fileName).toLowerCase().replaceFirst('.', '');
  }

  String get fileIcon {
    switch (fileExtension) {
      case 'pdf':
        return SupportAssets.I.png.pdf;

      case 'doc':
      case 'docx':
        return SupportAssets.I.png.doc;

      case 'xls':
      case 'xlsx':
        return SupportAssets.I.png.xls;

      case 'ppt':
      case 'pptx':
        return SupportAssets.I.png.ppt;

      case 'zip':
      case 'rar':
      case '7z':
        return SupportAssets.I.png.zip;

      case 'txt':
        return SupportAssets.I.png.txt;

      default:
        return SupportAssets.I.png.file;
    }
  }

  Future<void> downloads() async {
    if (isDownloadsFile || isDownloading) {
      return;
    }

    if (mounted) {
      setState(() {
        isDownloading = true;
        totalFileSize = 0;
      });
    }

    try {
      await downloadsClient.download(
        widget.url,
        path,
        onReceiveProgress: (received, total) {
          if (!mounted) return;

          setState(() {
            totalFileSize = received;
          });
        },
      );

      final file = File(path);
      final exists = await file.exists();

      if (!exists) {
        throw FileSystemException('После скачивания файл не найден', path);
      }

      final size = await file.length();

      if (!mounted) return;

      setState(() {
        isDownloadsFile = true;
        totalFileSize = size;
      });
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
        });
      }
    }
  }

  Future<void> openReadFile() async {
    if (isOpenFile || isDownloading || isCheckingFile) {
      return;
    }

    if (!isDownloadsFile) {
      await downloads();

      if (!isDownloadsFile) {
        return;
      }
    }

    if (!mounted) return;

    setState(() {
      isOpenFile = true;
    });

    try {
      final result = await OpenFilex.open(path);

      if (!mounted) return;

      if (result.type == ResultType.noAppToOpen) {
        BannerController.I.show(
          message: 'На устройстве нет приложения для открытия этого файла',
        );
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          isOpenFile = false;
        });
      }
    }
  }

  String get fileSizeText {
    if (totalFileSize <= 0) {
      return '';
    }

    if (totalFileSize < 1024) {
      return '$totalFileSize Б';
    }

    if (totalFileSize < 1024 * 1024) {
      return '${(totalFileSize / 1024).toStringAsFixed(1)} КБ';
    }

    return '${(totalFileSize / 1024 / 1024).toStringAsFixed(1)} МБ';
  }

  String get fileStatusText {
    if (isCheckingFile) {
      return 'Проверяем...';
    }

    if (isDownloading) {
      return fileSizeText.isEmpty ? 'Скачивание...' : 'Скачано $fileSizeText';
    }

    if (!isDownloadsFile) {
      return 'Скачать';
    }

    return fileSizeText;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openReadFile,
      child: Row(
        spacing: 5.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 35.r),
            child: Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: SupportColors.white,
              ),
              child: Image.asset(width: 25.r, height: 25.r, fileIcon),
              // SvgPicture.asset(
              //   SupportAssets.I.svg.file,
              //   width: 25.r,
              //   height: 25.r,
              //   colorFilter: ColorFilter.mode(
              //     SupportColors.grey,
              //     BlendMode.srcIn,
              //   ),
              // ),
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Text(
                  fileStatusText,
                  style: TextStyle(
                    fontWeight: isDownloadsFile
                        ? FontWeight.w600
                        : FontWeight.w800,
                    color: isDownloadsFile ? SupportColors.black1 : Colors.blue,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
