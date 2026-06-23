import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/attachments/upload_data.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/socket_connection.dart';

part 'local_attachments.freezed.dart';

@freezed
abstract class LocalAttachmentsModel with _$LocalAttachmentsModel {
  const LocalAttachmentsModel._();

  const factory LocalAttachmentsModel.local({
    required String id,
    required ChatAttachmentType type,
    required String path,
    @Default(true) bool isLoading,
  }) = _LocalAttachmentViewItem;

  const factory LocalAttachmentsModel.remote({
    required String id,
    required ChatAttachmentType type,
    required UploadDataModel data,
  }) = _RemoteAttachmentViewItem;

  bool get isLocal =>
      maybeWhen(local: (_, __, ___, ____) => true, orElse: () => false);

  bool get isRemote =>
      maybeWhen(remote: (_, __, ___) => true, orElse: () => false);
}
