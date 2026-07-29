import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/attachment_uuid_service.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_path.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/attachments/local_attachments.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/attachments/upload_data.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/socket_connection.dart';
import 'package:path/path.dart' as p;
import 'package:talker/talker.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

part 'attachments_cubit.freezed.dart';
part 'attachments_state.dart';

class AttachmentsCubit extends Cubit<AttachmentsState> {
  final Dio dio;
  final Directory directory;
  AttachmentsCubit({required this.dio, required this.directory})
    : super(const AttachmentsState());

  final _uuid = const Uuid();

  Future<List<PlatformFile>> _addImage() async {
    final picker = ImagePicker();

    final images = await picker.pickMultiImage();

    if (images.isEmpty) {
      return [];
    }

    return Future.wait(images.map(_copyPickedFile));
  }

  Future<List<PlatformFile>> _addDoc() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'pdf', 'xlsx'],
    );
    return result?.files ?? [];
  }

  Future<List<PlatformFile>> _addVideo() async {
    final picker = ImagePicker();

    final videos = await picker.pickMultiVideo();

    if (videos.isEmpty) {
      return [];
    }

    return Future.wait(videos.map(_copyPickedFile));
  }

  void clear() {
    emit(const AttachmentsState());
  }

  Future<void> addAttachment({required ChatAttachmentType type}) async {
    try {
      emit(state.copyWith(stage: AttachmentProcessStage.picking));

      final files = await (() async {
        if (type == ChatAttachmentType.photo) return _addImage();
        if (type == ChatAttachmentType.document) return _addDoc();
        if (type == ChatAttachmentType.video) return _addVideo();
        return <PlatformFile>[];
      })();

      if (files.isEmpty) {
        emit(state.copyWith(stage: AttachmentProcessStage.idle));
        return;
      }
      final selectedFiles = files.where((e) => e.path != null).toList();
      if (selectedFiles.isEmpty) {
        emit(state.copyWith(stage: AttachmentProcessStage.idle));
        return;
      }

      final localItems = selectedFiles.map((file) {
        return LocalAttachmentsModel.local(
          fileName: file.name,
          id: _uuid.v4(),
          type: type,
          path: file.path!,
          isLoading: true,
        );
      }).toList();

      emit(
        state.copyWith(
          items: [...state.items, ...localItems],
          stage: AttachmentProcessStage.compressing,
        ),
      );

      for (int i = 0; i < selectedFiles.length; i++) {
        final file = selectedFiles[i];
        final localItem = localItems[i];
        int fileSize = 0;
        try {
          _setLocalLoading(localItem.id, true);

          final preparedFile = await prepareFileForUpload(
            platformFile: file,
            type: type,
          );
          if (!await preparedFile.exists()) {
            throw FileSystemException(
              'Не удается найти указанный файл',
              preparedFile.path,
            );
          }
          emit(state.copyWith(stage: AttachmentProcessStage.uploading));

          final formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(
              preparedFile.path,
              filename: p.basename(preparedFile.path),
            ),
          });

          final response = await dio.post(
            SupportPath.uploadAttachments,
            data: formData,
            options: Options(contentType: 'multipart/form-data'),
          );

          final uploadFile = UploadDataModel.fromJson(response.data);

          AttachmentUuidService.I.save(
            uuid: uploadFile.uuid,
            fileName: uploadFile.fileName,
          );

          _replaceLocalWithRemote(
            localId: localItem.id,
            type: type,
            data: uploadFile,
          );
        } catch (e, st) {
          final error = AppErrorMapper.I.map(e, st);
          final fileSizeMb = (fileSize / 1024 / 1024).toStringAsFixed(2);
          BannerController.I.showError(
            error: error,
            message:
                '${error.message}\nФайл: ${file.name}\nРазмер файла: $fileSizeMb байт',
          );

          _removeLocalById(localItem.id);
          emit(state.copyWith(stage: AttachmentProcessStage.error));
        }
      }

      emit(state.copyWith(stage: AttachmentProcessStage.done));
      emit(state.copyWith(stage: AttachmentProcessStage.idle));
    } catch (e, st) {
      final error = AppErrorMapper.I.map(e, st);
      BannerController.I.showError(error: error, message: error.message);
      emit(state.copyWith(stage: AttachmentProcessStage.error));
      emit(state.copyWith(stage: AttachmentProcessStage.idle));
    }
  }

  void removeById(String id) {
    final updated = state.items.where((e) => e.id != id).toList();
    emit(state.copyWith(items: updated));
  }

  void removeRemote(UploadDataModel item) {
    final updated = state.items.where((e) {
      return e.maybeWhen(
        remote: (_, _, data) => data.uuid != item.uuid,
        orElse: () => true,
      );
    }).toList();

    emit(state.copyWith(items: updated));
  }

  void _setLocalLoading(String id, bool value) {
    final updated = state.items.map((item) {
      return item.maybeWhen(
        local: (itemId, type, path, fileName, isLoading) {
          if (itemId != id) return item;
          return LocalAttachmentsModel.local(
            fileName: fileName,
            id: itemId,
            type: type,
            path: path,
            isLoading: value,
          );
        },
        orElse: () => item,
      );
    }).toList();

    emit(state.copyWith(items: updated));
  }

  void _replaceLocalWithRemote({
    required String localId,
    required ChatAttachmentType type,
    required UploadDataModel data,
  }) {
    final updated = state.items.map((item) {
      return item.maybeWhen(
        local: (id, itemType, path, fileName, isLoading) {
          if (id != localId) return item;
          return LocalAttachmentsModel.remote(
            id: localId,
            type: type,
            data: data,
          );
        },
        orElse: () => item,
      );
    }).toList();

    emit(state.copyWith(items: updated));
  }

  void _removeLocalById(String id) {
    final updated = state.items.where((e) => e.id != id).toList();
    emit(state.copyWith(items: updated));
  }

  Future<File?> compressImageFile(File file) async {
    final talker = Talker();

    talker.debug('════════════════════════════════════════════');
    talker.debug('📸 НАЧАЛО ОБРАБОТКИ ФОТОГРАФИИ');
    talker.debug('════════════════════════════════════════════');

    // ─────────────────────────────────────────────
    // 1. Проверяем существование файла
    // ─────────────────────────────────────────────

    if (!await file.exists()) {
      talker.error(
        '❌ Исходный файл не существует',
        FileSystemException('Не удается найти указанный файл', file.path),
      );

      return null;
    }

    talker.debug('📁 Исходный файл:');
    talker.debug('   ${file.path}');

    // ─────────────────────────────────────────────
    // 2. Размер и разрешение ДО сжатия
    // ─────────────────────────────────────────────

    final beforeBytes = await file.readAsBytes();
    final beforeSize = beforeBytes.length;

    final beforeImage = img.decodeImage(beforeBytes);

    final beforeWidth = beforeImage?.width;
    final beforeHeight = beforeImage?.height;

    talker.debug('📐 ДО СЖАТИЯ:');

    if (beforeWidth != null && beforeHeight != null) {
      talker.debug('   Разрешение: ${beforeWidth} × $beforeHeight px');

      talker.debug(
        '   Соотношение сторон: '
        '${(beforeWidth / beforeHeight).toStringAsFixed(3)}',
      );
    } else {
      talker.warning('⚠️ Не удалось определить разрешение исходной фотографии');
    }

    talker.debug(
      '   Размер файла: '
      '${(beforeSize / 1024 / 1024).toStringAsFixed(3)} MB '
      '(${(beforeSize / 1024).toStringAsFixed(1)} KB)',
    );

    // ─────────────────────────────────────────────
    // 3. Путь нового файла
    // ─────────────────────────────────────────────

    final targetPath = p.join(
      directory.path,
      'img_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    talker.debug('📁 Файл после сжатия будет сохранён:');
    talker.debug('   $targetPath');

    // ─────────────────────────────────────────────
    // 4. Сжатие
    // ─────────────────────────────────────────────

    talker.debug('🔄 Начинаю сжатие...');
    talker.debug('   Качество JPEG: 80');
    talker.debug('   Формат: JPEG');
    talker.debug('   Ограничение разрешения: отсутствует');

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 80,
      format: CompressFormat.jpeg,
    );

    // ─────────────────────────────────────────────
    // 5. Проверяем результат
    // ─────────────────────────────────────────────

    if (result == null) {
      talker.error('❌ Сжатие не выполнено: результат = null');

      talker.debug('════════════════════════════════════════════');

      return null;
    }

    final compressedFile = File(result.path);

    if (!await compressedFile.exists()) {
      talker.error(
        '❌ FlutterImageCompress вернул путь, '
        'но файл по этому пути не существует',
      );

      talker.debug('   ${result.path}');
      talker.debug('════════════════════════════════════════════');

      return null;
    }

    // ─────────────────────────────────────────────
    // 6. Размер и разрешение ПОСЛЕ сжатия
    // ─────────────────────────────────────────────

    final afterBytes = await compressedFile.readAsBytes();
    final afterSize = afterBytes.length;

    final afterImage = img.decodeImage(afterBytes);

    final afterWidth = afterImage?.width;
    final afterHeight = afterImage?.height;

    talker.debug('✅ СЖАТИЕ УСПЕШНО');

    talker.debug('📐 ПОСЛЕ СЖАТИЯ:');

    if (afterWidth != null && afterHeight != null) {
      talker.debug('   Разрешение: ${afterWidth} × $afterHeight px');

      talker.debug(
        '   Соотношение сторон: '
        '${(afterWidth / afterHeight).toStringAsFixed(3)}',
      );
    } else {
      talker.warning('⚠️ Не удалось определить разрешение сжатой фотографии');
    }

    talker.debug(
      '   Размер файла: '
      '${(afterSize / 1024 / 1024).toStringAsFixed(3)} MB '
      '(${(afterSize / 1024).toStringAsFixed(1)} KB)',
    );

    // ─────────────────────────────────────────────
    // 7. Сравнение
    // ─────────────────────────────────────────────

    final savedPercent = beforeSize == 0
        ? 0
        : (1 - afterSize / beforeSize) * 100;

    talker.debug('📊 СРАВНЕНИЕ:');

    talker.debug(
      '   Размер: '
      '${(beforeSize / 1024 / 1024).toStringAsFixed(3)} MB → '
      '${(afterSize / 1024 / 1024).toStringAsFixed(3)} MB',
    );

    talker.debug(
      '   Изменение размера файла: '
      '${savedPercent.toStringAsFixed(1)}%',
    );

    if (beforeWidth != null &&
        beforeHeight != null &&
        afterWidth != null &&
        afterHeight != null) {
      talker.debug(
        '   Разрешение: '
        '${beforeWidth}×$beforeHeight → '
        '${afterWidth}×$afterHeight',
      );

      final beforeRatio = beforeWidth / beforeHeight;
      final afterRatio = afterWidth / afterHeight;

      final ratioChanged = (beforeRatio - afterRatio).abs() > 0.01;

      if (ratioChanged) {
        talker.warning('⚠️ ВНИМАНИЕ: изменилось соотношение сторон!');
      } else {
        talker.debug('   Соотношение сторон не изменилось ✅');
      }
    }

    talker.debug('📁 Итоговый файл:');
    talker.debug('   ${compressedFile.path}');

    talker.debug('════════════════════════════════════════════');
    talker.debug('🏁 ОБРАБОТКА ФОТОГРАФИИ ЗАВЕРШЕНА');
    talker.debug('════════════════════════════════════════════');

    return compressedFile;
  }

  Future<File?> compressVideoFile(File file) async {
    if (!await file.exists()) {
      throw FileSystemException('Не удается найти указанный файл', file.path);
    }

    final info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.Res1280x720Quality,
      includeAudio: true,
      deleteOrigin: false,
    );

    return info?.file;
  }

  Future<PlatformFile> _copyPickedFile(XFile x) async {
    final source = File(x.path);

    if (!await source.exists()) {
      throw FileSystemException('Не удается найти указанный файл', x.path);
    }

    final extension = p.extension(x.path);

    final targetPath = p.join(directory.path, '${const Uuid().v4()}$extension');

    final copied = await source.copy(targetPath);

    return PlatformFile(
      name: x.name,
      path: copied.path,
      size: await copied.length(),
    );
  }

  Future<File> prepareFileForUpload({
    required PlatformFile platformFile,
    required ChatAttachmentType type,
  }) async {
    final original = File(platformFile.path!);

    if (!await original.exists()) {
      throw FileSystemException(
        'Не удается найти указанный файл',
        original.path,
      );
    }

    switch (type) {
      case ChatAttachmentType.photo:
        final result = await compressImageFile(original);

        if (result == null) {
          return original;
        }

        if (!await result.exists()) {
          throw FileSystemException(
            'Не удается найти указанный файл',
            result.path,
          );
        }

        return result;

      case ChatAttachmentType.video:
        final result = await compressVideoFile(original);

        if (result == null) {
          return original;
        }

        if (!await result.exists()) {
          throw FileSystemException(
            'Не удается найти указанный файл',
            result.path,
          );
        }

        return result;

      case ChatAttachmentType.document:
        return original;
    }
  }
}
