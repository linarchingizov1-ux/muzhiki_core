import 'package:json_annotation/json_annotation.dart';

part 'notification_channel_model.g.dart';

@JsonSerializable()
class NotificationChannelModel {
  final String key;
  final String name;

  const NotificationChannelModel({required this.key, required this.name});

  factory NotificationChannelModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationChannelModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationChannelModelToJson(this);
}