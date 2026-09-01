// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadDataModel _$UploadDataModelFromJson(Map<String, dynamic> json) =>
    UploadDataModel(
      uuid: json['uuid'] as String,
      url: json['url'] as String,
      fileName: json['fileName'] as String,
      type: $enumDecode(_$ChatAttachmentTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$UploadDataModelToJson(UploadDataModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'url': instance.url,
      'fileName': instance.fileName,
      'type': _$ChatAttachmentTypeEnumMap[instance.type]!,
    };

const _$ChatAttachmentTypeEnumMap = {
  ChatAttachmentType.photo: 'photo',
  ChatAttachmentType.video: 'video',
  ChatAttachmentType.document: 'document',
};
