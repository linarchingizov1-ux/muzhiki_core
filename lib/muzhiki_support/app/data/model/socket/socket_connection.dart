import 'package:freezed_annotation/freezed_annotation.dart';

part 'socket_connection.g.dart';
part 'socket_connection.freezed.dart';

enum ChatType {
  @JsonValue('ticket')
  ticket,
  @JsonValue('session')
  session,
}

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
}

@freezed
abstract class SocketConnectionModel with _$SocketConnectionModel {
  const factory SocketConnectionModel({
    required int id,
    required ChatType type,

    @JsonKey(name: 'chat_id')
    required int chatId,

    @JsonKey(readValue: readAvatar)
    String? avatar,

    // @JsonKey(name: 'deadline', fromJson: fromJsonDate)
    DateTime? deadline,

    @Default([])
    List<MessageModel> messages,

    required SocketConnectionChatStatus status,

    @JsonKey(name: 'can_write')
    required bool canWrite,

    @JsonKey(name: 'created_at', fromJson: fromJsonDate)
    required DateTime createdAt,

    required String title,

    @JsonKey(name: 'channel_id')
    required int channelId,

    @JsonKey(name: 'rated')
    @Default(false)
    bool isRated,
  }) = _SocketConnectionModel;

  factory SocketConnectionModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SocketConnectionModelFromJson(json);
}

Object? readAvatar(Map json, String key) {
  final operators = json['operator'];

  if (operators is List && operators.isNotEmpty) {
    final first = operators.first;

    if (first is Map<String, dynamic>) {
      return first['avatar'];
    }

    if (first is Map) {
      return first['avatar'];
    }
  }

  return null;
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

@JsonSerializable()
class MessageModel {
  final String id;
  @JsonKey(name: 'created_at', fromJson: _fromJsonDate)
  final DateTime? createdAt;
  final String text;
  final MessageType type;
  final String? avatar;
  @JsonKey(name: 'operator_name')
  final String? name;
  final List<AttachmentsModel> attachments;
  const MessageModel({
    this.avatar,
    required this.name,
    required this.id,
    this.createdAt,
    required this.text,
    required this.type,
    this.attachments = const [],
  });

  static DateTime _fromJsonDate(String value) {
    return DateTime.parse(value).toLocal();
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
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
