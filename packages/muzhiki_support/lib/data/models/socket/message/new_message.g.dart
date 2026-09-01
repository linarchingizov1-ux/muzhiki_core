// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewMessageModel _$NewMessageModelFromJson(Map<String, dynamic> json) =>
    NewMessageModel(
      event: json['event'] as String,
      payload: PayloadModel.fromJson(json['payload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewMessageModelToJson(NewMessageModel instance) =>
    <String, dynamic>{'event': instance.event, 'payload': instance.payload};

PayloadModel _$PayloadModelFromJson(Map<String, dynamic> json) => PayloadModel(
  id: json['id'] as String,
  createdAu: PayloadModel._fromJsonDate(json['created_at'] as String),
  text: json['text'] as String,
  type: $enumDecode(_$MessageTypeEnumMap, json['type']),
  operatorName: json['operator_name'] as String?,
  attachments: (json['attachments'] as List<dynamic>)
      .map((e) => AttachmentsModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PayloadModelToJson(PayloadModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAu.toIso8601String(),
      'text': instance.text,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'operator_name': instance.operatorName,
      'attachments': instance.attachments,
    };

const _$MessageTypeEnumMap = {MessageType.operator: 2, MessageType.client: 1};
