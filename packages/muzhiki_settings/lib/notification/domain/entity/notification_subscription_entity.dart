import 'package:muzhiki_settings/notification/domain/entity/notification_channel_entity.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_entity.dart';

class NotificationSubscriptionEntity {
  final String notificationKey;
  final String name;
  final String? description;
  final bool isEnabled;
  final bool isEditable;
  final List<NotificationChannelEntity> availableChannels;
  final List<String>? channels;
  final Map<String, dynamic> filters;
  final Map<String, NotificationParameterEntity> parameters;

  const NotificationSubscriptionEntity({
    required this.notificationKey,
    required this.name,
    required this.description,
    required this.isEnabled,
    required this.isEditable,
    required this.availableChannels,
    required this.channels,
    required this.filters,
    required this.parameters,
  });

  NotificationSubscriptionEntity copyWith({
    bool? isEnabled,
    List<String>? channels,
    Map<String, dynamic>? filters,
  }) => NotificationSubscriptionEntity(
    notificationKey: notificationKey,
    name: name,
    description: description,
    isEnabled: isEnabled ?? this.isEnabled,
    isEditable: isEditable,
    availableChannels: availableChannels,
    channels: channels ?? this.channels,
    filters: filters ?? this.filters,
    parameters: parameters,
  );
}
