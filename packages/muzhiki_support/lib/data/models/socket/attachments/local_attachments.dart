import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:muzhiki_support/data/models/socket/attachments/upload_data.dart';
import 'package:muzhiki_support/data/models/socket/socket_connection.dart';

part 'local_attachments.freezed.dart';

@freezed
abstract class LocalAttachmentsModel with _$LocalAttachmentsModel {
  const LocalAttachmentsModel._();

  const factory LocalAttachmentsModel.local({
    required String id,
    required ChatAttachmentType type,
    required String path,
    required String fileName,
    @Default(true) bool isLoading,
  }) = _LocalAttachmentViewItem;

  const factory LocalAttachmentsModel.remote({
    required String id,
    required ChatAttachmentType type,
    required UploadDataModel data,
  }) = _RemoteAttachmentViewItem;

  bool get isLocal =>
      maybeWhen(local: (_, _, _, _, _) => true, orElse: () => false);

  bool get isRemote =>
      maybeWhen(remote: (_, _, _) => true, orElse: () => false);
}
