// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyChatModel _$MyChatModelFromJson(Map<String, dynamic> json) => MyChatModel(
  channels: (json['channels'] as List<dynamic>)
      .map((e) => ChannelsModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  chats: (json['chats'] as List<dynamic>)
      .map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  pagination: PaginationModel.fromJson(
    json['pagination'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$MyChatModelToJson(MyChatModel instance) =>
    <String, dynamic>{
      'channels': instance.channels,
      'chats': instance.chats,
      'pagination': instance.pagination,
    };

ChannelsModel _$ChannelsModelFromJson(Map<String, dynamic> json) =>
    ChannelsModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ChannelsModelToJson(ChannelsModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
  id: (json['id'] as num).toInt(),
  chatId: (json['chat_id'] as num).toInt(),
  unreadCount: (json['unread_count'] as num).toInt(),
  title: json['title'] as String,
  status: json['status'] as String,
  statusColor: json['status_color'] as String,
  createdAt: ChatModel._fromJsonDate(json['created_at'] as String?),
  channelId: (json['channel_id'] as num).toInt(),
);

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
  'id': instance.id,
  'chat_id': instance.chatId,
  'unread_count': instance.unreadCount,
  'title': instance.title,
  'status': instance.status,
  'status_color': instance.statusColor,
  'created_at': instance.createdAt?.toIso8601String(),
  'channel_id': instance.channelId,
};

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      hasMore: json['has_more'] as bool,
      page: (json['page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPage: (json['total_pages'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'has_more': instance.hasMore,
      'page': instance.page,
      'total': instance.total,
      'total_pages': instance.totalPage,
      'page_size': instance.pageSize,
    };
