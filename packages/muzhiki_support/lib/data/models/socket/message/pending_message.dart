import 'package:muzhiki_support/data/models/socket/socket_connection.dart';

class PendingMessage {
  final String uuid;
  final String text;
  final List<String> attachments;
  final DateTime createdAt;

  const PendingMessage({
    required this.uuid,
    required this.text,
    required this.attachments,
    required this.createdAt,
  });

  MessageModel toMessage() {
    return MessageModel(
      id: uuid,
      text: text,
      status: MessageStatus.sending,
      createdAt: createdAt,
      attachments: const [],
    );
  }

  factory PendingMessage.fromJson(Map<String, dynamic> json) {
    return PendingMessage(
      uuid: json['uuid'] as String,
      text: json['text'] as String? ?? '',
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String).toLocal()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'text': text,
    'attachments': attachments,
    'created_at': createdAt.toIso8601String(),
  };
}
