import 'package:freezed_annotation/freezed_annotation.dart';

part 'socket_connection.g.dart';
part 'socket_connection.freezed.dart';

enum ChatType {
  @JsonValue('ticket')
  ticket,
  @JsonValue('session')
  session,
}

enum MessageStatus { sending, sent, failed }

enum SocketConnectionChatStatus {
  @JsonValue('Закрыт')
  close,
  @JsonValue('В работе')
  work,
  @JsonValue('Открыт')
  open,
  @JsonValue('waiting')
  wait,
  activeTicket,
  inital,
}

@freezed
abstract class OperatorModel with _$OperatorModel {
  const factory OperatorModel({
    required int id,
    required String name,
    String? avatar,
  }) = _OperatorModel;

  factory OperatorModel.fromJson(Map<String, dynamic> json) =>
      _$OperatorModelFromJson(json);
}

@freezed
abstract class SocketConnectionModel with _$SocketConnectionModel {
  const factory SocketConnectionModel({
    required int id,
    required ChatType type,

    @JsonKey(name: 'chat_id') required int chatId,

    @JsonKey(name: 'operator') @Default([]) List<OperatorModel> operators,

    DateTime? deadline,

    @Default([]) List<MessageModel> messages,

    required SocketConnectionChatStatus status,

    @JsonKey(name: 'can_write') required bool canWrite,

    @JsonKey(name: 'created_at', fromJson: fromJsonDate) DateTime? createdAt,

    required String title,

    @JsonKey(name: 'channel_id') required int channelId,

    @JsonKey(name: 'rated') @Default(false) bool isRated,
  }) = _SocketConnectionModel;

  factory SocketConnectionModel.fromJson(Map<String, dynamic> json) =>
      _$SocketConnectionModelFromJson(json);
}

DateTime fromJsonDate(String value) {
  return DateTime.parse(value).toLocal();
}

enum MessageType {
  @JsonValue(2)
  operator,
  @JsonValue(1)
  client,
}

@freezed
abstract class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,

    @JsonKey(name: 'created_at', fromJson: _fromJsonDate) DateTime? createdAt,

    MessageStatus? status,

    required String text,

    @Default(MessageType.client) MessageType type,

    @JsonKey(name: 'operator_name') String? name,

    @Default([]) List<AttachmentsModel> attachments,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

DateTime _fromJsonDate(String value) {
  return DateTime.parse(value).toLocal();
}

@JsonSerializable()
class AttachmentsModel {
  final ChatAttachmentType type;
  final String url;
  final String? name;

  const AttachmentsModel({required this.type, required this.url, this.name});

  factory AttachmentsModel.fromJson(Map<String, dynamic> json) =>
      _$AttachmentsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentsModelToJson(this);
}

enum ChatAttachmentType {
  @JsonValue('photo')
  photo,
  @JsonValue('video')
  video,
  @JsonValue('document')
  document,
}
