import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/socket_connection.dart';

part 'new_message.g.dart';

@JsonSerializable()
class NewMessageModel {
  final String event;
  final PayloadModel payload;
  const NewMessageModel({required this.event, required this.payload});

  factory NewMessageModel.fromJson(Map<String, dynamic> json) =>
      _$NewMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewMessageModelToJson(this);
}

@JsonSerializable()
class PayloadModel {
  final String id;
  @JsonKey(name: 'created_at', fromJson: _fromJsonDate)
  final DateTime createdAu;
  final String text;
  final MessageType type;
  @JsonKey(name: 'operator_name')
  final String? operatorName;
  final List<AttachmentsModel> attachments;

  const PayloadModel({
    required this.id,
    required this.createdAu,
    required this.text,
    required this.type,
    required this.operatorName,
    required this.attachments,
  });

  static DateTime _fromJsonDate(String value) {
    return DateTime.parse(value).toLocal();
  }

  factory PayloadModel.fromJson(Map<String, dynamic> json) =>
      _$PayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadModelToJson(this);
}
