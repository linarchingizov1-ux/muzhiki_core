import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/socket_connection.dart';
part 'upload_data.g.dart';

@JsonSerializable()
class UploadDataModel {
  final String uuid, url, fileName;
  final ChatAttachmentType type;
  const UploadDataModel({
    required this.uuid,
    required this.url,
    required this.fileName,
    required this.type,
  });

  factory UploadDataModel.fromJson(Map<String, dynamic> json) =>
      _$UploadDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadDataModelToJson(this);
}
