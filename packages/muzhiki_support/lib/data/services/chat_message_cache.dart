import 'dart:convert';
import 'dart:io';

import 'package:muzhiki_support/data/models/socket/message/pending_message.dart';
import 'package:muzhiki_support/data/models/socket/socket_connection.dart';
import 'package:path/path.dart' as p;

class CachedChat {
  final SocketConnectionModel? socket;
  final List<MessageModel> messages;
  final List<PendingMessage> pending;

  const CachedChat({
    this.socket,
    this.messages = const [],
    this.pending = const [],
  });

  bool get isEmpty => socket == null && messages.isEmpty && pending.isEmpty;
}

class ChatMessageCache {
  ChatMessageCache(this._root);

  final Directory _root;

  static const _maxMessages = 200;

  Directory get _dir {
    return Directory(p.join(_root.path, 'support_chat_cache'));
  }

  File _fileFor({required int? sessionId, int? channelId}) {
    final name = sessionId != null
        ? 'session_$sessionId.json'
        : 'draft_$channelId.json';
    return File(p.join(_dir.path, name));
  }

  Future<CachedChat> load({required int? sessionId, int? channelId}) async {
    if (sessionId == null && channelId == null) {
      return const CachedChat();
    }

    try {
      final file = _fileFor(sessionId: sessionId, channelId: channelId);
      if (!file.existsSync()) {
        return const CachedChat();
      }

      final map = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return CachedChat(
        socket: _socketFromCache(map['socket']),
        messages: _messagesFromCache(map['messages']),
        pending:
            (map['pending'] as List<dynamic>?)
                ?.whereType<Map<String, dynamic>>()
                .map(PendingMessage.fromJson)
                .toList() ??
            const [],
      );
    } catch (_) {
      return const CachedChat();
    }
  }

  Future<void> save({
    required int? sessionId,
    int? channelId,
    required SocketConnectionModel? socket,
    required List<MessageModel> messages,
    required List<PendingMessage> pending,
  }) async {
    if (sessionId == null && channelId == null) return;

    try {
      await _dir.create(recursive: true);
      final storedMessages = messages
          .where((m) => m.status != MessageStatus.sending)
          .take(_maxMessages)
          .toList();

      final payload = jsonEncode({
        'socket': socket == null ? null : _socketToCache(socket),
        'messages': storedMessages.map(_messageToCache).toList(),
        'pending': pending.map((e) => e.toJson()).toList(),
      });

      await _fileFor(
        sessionId: sessionId,
        channelId: channelId,
      ).writeAsString(payload);
    } catch (_) {}
  }

  Future<void> deleteDraft({required int channelId}) async {
    try {
      final file = _fileFor(sessionId: null, channelId: channelId);
      if (file.existsSync()) {
        await file.delete();
      }
    } catch (_) {}
  }

  List<MessageModel> _messagesFromCache(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(_messageFromCache)
        .toList();
  }

  MessageModel _messageFromCache(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      text: json['text'] as String? ?? '',
      createdAt: json['created_at'] is String
          ? DateTime.tryParse(json['created_at'] as String)?.toLocal()
          : null,
      status: _statusFromName(json['status'] as String),
      type: json['type'] == 2 ? MessageType.operator : MessageType.client,
      name: json['operator_name'] as String?,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(AttachmentsModel.fromJson)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> _messageToCache(MessageModel message) {
    return {
      'id': message.id,
      'created_at': message.createdAt?.toIso8601String(),
      'status': message.status.name,
      'text': message.text,
      'type': message.type == MessageType.operator ? 2 : 1,
      'operator_name': message.name,
      'attachments': message.attachments.map((e) => e.toJson()).toList(),
    };
  }

  SocketConnectionModel? _socketFromCache(dynamic raw) {
    if (raw is! Map<String, dynamic>) return null;
    try {
      final json = Map<String, dynamic>.from(raw);
      json['messages'] = const [];
      json['created_at'] ??= DateTime.now().toIso8601String();
      return SocketConnectionModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _socketToCache(SocketConnectionModel socket) {
    return {
      'id': socket.id,
      'type': socket.type == ChatType.ticket ? 'ticket' : 'session',
      'chat_id': socket.chatId,
      'operator': socket.operators
          .map((e) => {'id': e.id, 'name': e.name, 'avatar': e.avatar})
          .toList(),
      'deadline': socket.deadline?.toIso8601String(),
      'messages': const [],
      'status': _socketStatusToJson(socket.status),
      'can_write': socket.canWrite,
      'created_at': (socket.createdAt ?? DateTime.now()).toIso8601String(),
      'title': socket.title,
      'channel_id': socket.channelId,
      'rated': socket.isRated,
    };
  }

  MessageStatus _statusFromName(String name) {
    switch (name) {
      case 'sending':
        return MessageStatus.sending;
      case 'sent':
        return MessageStatus.sent;
      case 'failed':
        return MessageStatus.failed;
      default:
        return MessageStatus.init;
    }
  }

  String _socketStatusToJson(SocketConnectionChatStatus status) {
    switch (status) {
      case SocketConnectionChatStatus.close:
        return 'Закрыт';
      case SocketConnectionChatStatus.work:
        return 'В работе';
      case SocketConnectionChatStatus.open:
        return 'Открыт';
      case SocketConnectionChatStatus.wait:
        return 'waiting';
      case SocketConnectionChatStatus.activeTicket:
        return 'activeTicket';
      case SocketConnectionChatStatus.inital:
        return 'inital';
    }
  }
}
