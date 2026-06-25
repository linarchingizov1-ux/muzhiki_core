import 'package:freezed_annotation/freezed_annotation.dart';
part 'my_chat.g.dart';

@JsonSerializable()
class MyChatModel {
  final List<ChannelsModel> channels;
  final List<ChatModel> chats;
  final PaginationModel pagination;
  const MyChatModel({
    required this.channels,
    required this.chats,
    required this.pagination,
  });

  factory MyChatModel.fromJson(Map<String, dynamic> json) =>
      _$MyChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyChatModelToJson(this);
}

@JsonSerializable()
class ChannelsModel {
  final int id;
  final String name;
  const ChannelsModel({required this.id, required this.name});
  factory ChannelsModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelsModelToJson(this);
}

@JsonSerializable()
class ChatModel {
  final int id;
  @JsonKey(name: 'chat_id')
  final int chatId;
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  final String title, status;
  @JsonKey(name: 'status_color')
  final String statusColor;
  @JsonKey(name: 'created_at', fromJson: _fromJsonDate)
  final DateTime? createdAt;
  @JsonKey(name: 'channel_id')
  final int channelId;
  const ChatModel({
    required this.id,
    required this.chatId,
    required this.unreadCount,
    required this.title,
    required this.status,
    required this.statusColor,
    this.createdAt,
    required this.channelId,
  });
  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  static DateTime? _fromJsonDate(String? value) {
    if (value == null) {
      return null;
    }
    return DateTime.parse(value).toLocal();
  }

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}

@JsonSerializable()
class PaginationModel {
  @JsonKey(name: 'has_more')
  final bool hasMore;
  final int page, total;
  @JsonKey(name: 'total_pages')
  final int totalPage;
  @JsonKey(name: 'page_size')
  final int pageSize;
  const PaginationModel({
    required this.hasMore,
    required this.page,
    required this.total,
    required this.totalPage,
    required this.pageSize,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}
