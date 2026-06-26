// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileWidgetModel _$MobileWidgetModelFromJson(Map<String, dynamic> json) =>
    MobileWidgetModel(
      id: json['id'] as num,
      channelName: json['channel_name'] as String,
      title: json['title'] as String,
      lastMessage: json['last_message'] as String?,
      countUnread: (json['count_unread'] as num).toInt(),
      status: json['status'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$MobileWidgetModelToJson(MobileWidgetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channel_name': instance.channelName,
      'title': instance.title,
      'last_message': instance.lastMessage,
      'count_unread': instance.countUnread,
      'status': instance.status,
      'type': instance.type,
    };
