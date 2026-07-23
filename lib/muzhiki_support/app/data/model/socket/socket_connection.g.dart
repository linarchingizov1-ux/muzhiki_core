// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentsModel _$AttachmentsModelFromJson(Map<String, dynamic> json) =>
    AttachmentsModel(
      type: $enumDecode(_$ChatAttachmentTypeEnumMap, json['type']),
      url: json['url'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$AttachmentsModelToJson(AttachmentsModel instance) =>
    <String, dynamic>{
      'type': _$ChatAttachmentTypeEnumMap[instance.type]!,
      'url': instance.url,
      'name': instance.name,
    };

const _$ChatAttachmentTypeEnumMap = {
  ChatAttachmentType.photo: 'photo',
  ChatAttachmentType.video: 'video',
  ChatAttachmentType.document: 'document',
};

_OperatorModel _$OperatorModelFromJson(Map<String, dynamic> json) =>
    _OperatorModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$OperatorModelToJson(_OperatorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
    };

_SocketConnectionModel _$SocketConnectionModelFromJson(
  Map<String, dynamic> json,
) => _SocketConnectionModel(
  id: (json['id'] as num).toInt(),
  type: $enumDecode(_$ChatTypeEnumMap, json['type']),
  chatId: (json['chat_id'] as num).toInt(),
  operators:
      (json['operator'] as List<dynamic>?)
          ?.map((e) => OperatorModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  messages:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  status: $enumDecode(_$SocketConnectionChatStatusEnumMap, json['status']),
  canWrite: json['can_write'] as bool,
  createdAt: fromJsonDate(json['created_at'] as String),
  title: json['title'] as String,
  channelId: (json['channel_id'] as num).toInt(),
  isRated: json['rated'] as bool? ?? false,
);

Map<String, dynamic> _$SocketConnectionModelToJson(
  _SocketConnectionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$ChatTypeEnumMap[instance.type]!,
  'chat_id': instance.chatId,
  'operator': instance.operators,
  'deadline': instance.deadline?.toIso8601String(),
  'messages': instance.messages,
  'status': _$SocketConnectionChatStatusEnumMap[instance.status]!,
  'can_write': instance.canWrite,
  'created_at': instance.createdAt?.toIso8601String(),
  'title': instance.title,
  'channel_id': instance.channelId,
  'rated': instance.isRated,
};

const _$ChatTypeEnumMap = {
  ChatType.ticket: 'ticket',
  ChatType.session: 'session',
};

const _$SocketConnectionChatStatusEnumMap = {
  SocketConnectionChatStatus.close: 'Закрыт',
  SocketConnectionChatStatus.work: 'В работе',
  SocketConnectionChatStatus.open: 'Открыт',
  SocketConnectionChatStatus.wait: 'waiting',
  SocketConnectionChatStatus.activeTicket: 'activeTicket',
  SocketConnectionChatStatus.inital: 'inital',
};

_MessageModel _$MessageModelFromJson(Map<String, dynamic> json) =>
    _MessageModel(
      id: json['id'] as String,
      createdAt: _fromJsonDate(json['created_at'] as String),
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']),
      text: json['text'] as String,
      type:
          $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.client,
      avatar: json['avatar'] as String?,
      name: json['operator_name'] as String?,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => AttachmentsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MessageModelToJson(_MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'status': _$MessageStatusEnumMap[instance.status],
      'text': instance.text,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'avatar': instance.avatar,
      'operator_name': instance.name,
      'attachments': instance.attachments,
    };

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.failed: 'failed',
};

const _$MessageTypeEnumMap = {MessageType.operator: 2, MessageType.client: 1};
