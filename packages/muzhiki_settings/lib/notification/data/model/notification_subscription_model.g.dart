// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSubscriptionModel _$NotificationSubscriptionModelFromJson(
  Map<String, dynamic> json,
) => NotificationSubscriptionModel(
  notificationKey: json['notification_key'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  isEnabled: json['is_enabled'] as bool,
  isEditable: json['is_editable'] as bool,
  availableChannels: (json['available_channels'] as List<dynamic>)
      .map((e) => NotificationChannelModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  channels: (json['channels'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  filters: json['filters'] as Map<String, dynamic>,
  parameters: (json['parameters'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      NotificationParameterModel.fromJson(e as Map<String, dynamic>),
    ),
  ),
);

Map<String, dynamic> _$NotificationSubscriptionModelToJson(
  NotificationSubscriptionModel instance,
) => <String, dynamic>{
  'notification_key': instance.notificationKey,
  'name': instance.name,
  'description': instance.description,
  'is_enabled': instance.isEnabled,
  'is_editable': instance.isEditable,
  'available_channels': instance.availableChannels,
  'channels': instance.channels,
  'filters': instance.filters,
  'parameters': instance.parameters,
};
