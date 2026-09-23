import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muzhiki_dependencies/network/exception/network_map_error.dart';
import 'package:muzhiki_dependencies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_support/data/services/attachment_uuid_service.dart';
import 'package:muzhiki_support/config/support_path.dart';
import 'package:muzhiki_support/data/models/socket/attachments/local_attachments.dart';
import 'package:muzhiki_support/data/models/socket/attachments/upload_data.dart';
import 'package:muzhiki_support/data/models/socket/socket_connection.dart';
import 'package:path/path.dart' as p;
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

  Future<List<XFile>> _addImage() async {
    final images = await ImagePicker().pickMultiImage();

    return images;
  }

  Future<List<XFile>> _addDoc() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'pdf', 'xlsx'],
    );

    return result.map((file) => file.xFile).toList();
  }

  Future<List<XFile>> _addVideo() async {
    final videos = await ImagePicker().pickMultiVideo();

    return videos;
  }

  void clear() {
    emit(const AttachmentsState());
  }

  Future<void> addAttachment({required ChatAttachmentType type}) async {
    try {
      emit(state.copyWith(stage: AttachmentProcessStage.picking));

      final files = await switch (type) {
        ChatAttachmentType.photo => _addImage(),
        ChatAttachmentType.document => _addDoc(),
        ChatAttachmentType.video => _addVideo(),
      };

      if (files.isEmpty) {
        emit(state.copyWith(stage: AttachmentProcessStage.idle));
        return;
      }

      final localItems = files.map((file) {
        return LocalAttachmentsModel.local(
          fileName: file.name,
          id: _uuid.v4(),
          type: type,
          path: file.path,
          isLoading: true,
        );
      }).toList();

      emit(
        state.copyWith(
          items: [...state.items, ...localItems],
          stage: AttachmentProcessStage.compressing,
        ),
      );

      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final localItem = localItems[i];

        try {
          _setLocalLoading(localItem.id, true);

          final preparedFile = await prepareFileForUpload(
            file: file,
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

          BannerController.I.showError(
            error: error,
            message: '${error.message}\nФайл: ${file.name}',
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
    if (!await file.exists()) {
      throw FileSystemException('Не удается найти указанный файл', file.path);
    }

    final targetPath = p.join(
      directory.path,
      'img_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 80,
      format: CompressFormat.jpeg,
    );

    return result == null ? null : File(result.path);
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

  Future<File> prepareFileForUpload({
    required XFile file,
    required ChatAttachmentType type,
  }) async {
    final original = File(file.path);

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
