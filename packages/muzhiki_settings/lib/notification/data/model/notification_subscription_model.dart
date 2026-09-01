import 'package:json_annotation/json_annotation.dart';
import 'package:muzhiki_settings/notification/data/model/notification_channel_model.dart';
import 'package:muzhiki_settings/notification/data/model/notification_parameter_model.dart';

part 'notification_subscription_model.g.dart';

@JsonSerializable()
class NotificationSubscriptionModel {
  @JsonKey(name: 'notification_key')
  final String notificationKey;
  final String name;
  final String? description;
  @JsonKey(name: 'is_enabled')
  final bool isEnabled;
  @JsonKey(name: 'is_editable')
  final bool isEditable;
  @JsonKey(name: 'available_channels')
  final List<NotificationChannelModel> availableChannels;
  final List<String>? channels;
  final Map<String, dynamic> filters;
  final Map<String, NotificationParameterModel> parameters;

  const NotificationSubscriptionModel({
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

  factory NotificationSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSubscriptionModelToJson(this);

  NotificationSubscriptionModel copyWith({
    bool? isEnabled,
    List<String>? channels,
    Map<String, dynamic>? filters,
  }) => NotificationSubscriptionModel(
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
