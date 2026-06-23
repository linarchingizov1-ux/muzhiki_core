import 'package:json_annotation/json_annotation.dart';
part 'mobile_widget.g.dart';

@JsonSerializable()
class MobileWidgetModel {
  final num id;
  @JsonKey(name: 'channel_name')
  final String channelName;
  final String title;
  @JsonKey(name: 'last_message')
  final String? lastMessage;
  @JsonKey(name: 'count_unread')
  final int countUnread;
  final String status;
  final String type;
  const MobileWidgetModel({
    required this.id,
    required this.channelName,
    required this.title,
    this.lastMessage,
    required this.countUnread,
    required this.status,
    required this.type,
  });

  factory MobileWidgetModel.fromJson(Map<String, dynamic> json) =>
      _$MobileWidgetModelFromJson(json);
  Map<String, dynamic> toJson() => _$MobileWidgetModelToJson(this);
}
