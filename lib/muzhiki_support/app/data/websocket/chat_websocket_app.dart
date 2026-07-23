import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_exception.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/chat_websocket_state.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/message/new_message.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/message/pending_message.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/socket_connection.dart';
import 'package:muzhiki_core/muzhiki_support/app/domain/usecase/chat_usecase.dart';
import 'package:talker/talker.dart';
import 'package:uuid/v4.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class WebSocketChat {
  Future<void> connect();

  Future<void> disconnect();

  Future<void> dispose();

  Future<void> sendMessage({required String text, List<String> attachments});

  Future<void> reopenWebChat({required int sessionId});

  Future<void> reviewChat({required int sessionId, required int score});

  Future<void> readMessage({required int sessionId});
}

class AppWebsocketChat extends WebSocketChat {
  AppWebsocketChat({
    required this.sessionChatId,
    required this.chatUsecase,
    required this.session,
    this.channelId,
  }) {
    _listener = AppLifecycleListener(
      onShow: () async {
        await _resumeWS();
      },
      onHide: () async {
        await _pauseWS();
      },
    );
  }

  int? sessionChatId;
  final int? channelId;
  final ChatUseCase chatUsecase;
  final SessionApp session;

  late final AppLifecycleListener _listener;

  final StreamController<WebSocketChatState> _controller =
      StreamController.broadcast();

  WebSocketChatState _state = const WebSocketChatState();

  Stream<WebSocketChatState> get stream => _controller.stream;

  WebSocketChatState get state => _state;

  WebSocketChannel? _channel;

  StreamSubscription? _subscription;

  DateTime? _lastBannerTime;

  bool _isConnecting = false;

  final UuidV4 uuidService = UuidV4();

  bool get isDraft => sessionChatId == null;

  bool get isConnected => _channel != null;
  bool _isCreating = false;
  final List<PendingMessage> _pendingMessages = [];

  void _emit(WebSocketChatState Function(WebSocketChatState state) updater) {
    if (_controller.isClosed) return;

    _state = updater(_state);

    _controller.add(_state);
  }

  void openDraftChat() => _emit(
    (s) => s.copyWith(
      messages: [],
      didSendInitialMessage: true,
      socket: SocketConnectionModel(
        id: 0,
        chatId: 0,
        channelId: 0,
        type: ChatType.session,
        status: SocketConnectionChatStatus.inital,
        canWrite: true,
        title: 'Черновик',
      ),
    ),
  );

  Future<int?> createSessionAndConnect() async {
    talker.debug(
      'createSessionAndConnect: '
      'sessionChatId=$sessionChatId '
      'isDraft=$isDraft '
      'channelId=$channelId',
    );
    if (_isCreating) return null;
    _isCreating = true;
    try {
      if (isDraft) {
        if (channelId == null) return null;
        try {
          sessionChatId = await chatUsecase.createSession(
            channelId: channelId!,
          );
        } catch (e, st) {
          _handleError(e, st, showBanner: true);
          return null;
        }
      }
      if (_channel == null) {
        await connect();
      }
      return _channel != null ? sessionChatId : null;
    } finally {
      _isCreating = false;
    }
  }

  @override
  Future<void> connect() async {
    if (sessionChatId == null || _isConnecting || _channel != null) return;

    _isConnecting = true;

    try {
      final socketConnection = await chatUsecase.getMessageChat(
        sessionId: sessionChatId!,
      );
      final messages = List<MessageModel>.from(
        (socketConnection.messages).reversed,
      );
      talker.debug(
        "После подключения получили модель списка сообщений $messages",
      );
      _emit((s) {
        final pendingLocal = s.messages
            .where((m) => m.status == MessageStatus.sending)
            .toList();

        return s.copyWith(
          socket: socketConnection,
          messages: [...pendingLocal, ...messages],
        );
      });

      final token = await session.fresh.token;
      if (token?.accessToken == null) {
        return;
      }

      final uri = Uri.parse('wss://api.webchat.muzhiki.pro/ws').replace(
        queryParameters: {
          'chat_id': '${socketConnection.chatId}',
          'token': token!.accessToken,
          'is_client': 'true',
        },
      );

      final channel = WebSocketChannel.connect(uri);

      await channel.ready;

      _isConnecting = false;
      _channel = channel;

      _subscription?.cancel();
      _subscription = channel.stream.listen(
        _onSocketData,
        onError: _onSocketError,
        onDone: () {},
      );

      await _sendPendingMessages();
      await _sendInitialMessageIfNeeded();
      await readMessage(sessionId: sessionChatId!);
    } catch (e, st) {
      _handleError(e, st, showBanner: true);
    } finally {
      _isConnecting = false;
    }
  }

  @override
  Future<void> disconnect() async {
    await _subscription?.cancel();

    _subscription = null;

    await _channel?.sink.close();

    _channel = null;

    _isConnecting = false;
  }

  @override
  Future<void> dispose() async {
    await disconnect();

    await _controller.close();

    _listener.dispose();
  }

  Talker get talker => Talker();

  @override
  Future<void> sendMessage({
    required String text,
    List<String> attachments = const [],
  }) async {
    if (!_state.canWrite) return;

    final trimmed = text.trim();

    if (trimmed.isEmpty && attachments.isEmpty) {
      return;
    }

    final uuid = uuidService.generate();

    _pendingMessages.add(
      PendingMessage(uuid: uuid, text: trimmed, attachments: attachments),
    );

    final local = MessageModel(
      id: uuid,
      text: trimmed,
      status: MessageStatus.sending,
      createdAt: DateTime.now(),
      attachments: const [],
    );

    _emit((s) => s.copyWith(messages: [local, ...s.messages]));
    if (!isConnected) {
      await createSessionAndConnect();

      if (!isConnected) {
        return;
      }
    }

    await _sendPendingMessages();
  }

  Future<void> _sendPendingMessages() async {
    if (_channel == null) return;

    while (_pendingMessages.isNotEmpty) {
      final pending = _pendingMessages.removeAt(0);

      _channel!.sink.add(
        jsonEncode({
          'Event': 'NewMessage',
          'Payload': {
            'MessageUUID': pending.uuid,
            'SenderId': 2,
            'SessionId': sessionChatId,
            'Text': pending.text,
            'Attachments': pending.attachments,
          },
        }),
      );
    }
  }

  @override
  Future<void> readMessage({required int sessionId}) async {
    try {
      _channel?.sink.add(
        jsonEncode({
          'Event': 'ReadMessage',
          'Payload': {'SessionId': sessionId},
        }),
      );
    } catch (e, st) {
      _handleError(e, st, showBanner: false);
    }
  }

  Future<void> _resumeWS() async {
    if (isDraft) return;
    if (_channel == null && !_isConnecting) {
      await connect();
    }
  }

  Future<void> _pauseWS() async {
    if (_channel != null) {
      await disconnect();
    }
  }

  void _onSocketData(dynamic raw) {
    if (raw is! String) return;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      talker.debug("ПОЛУЧИЛИ В СОКЕТЕ $raw");
      final event = map['event'];
      switch (event) {
        case 'NewMessage':
          _handleNewMessage(map);
          return;

        case 'SessionClosed':
          _handleSessionClosed(map);
          return;

        case 'ErrorSessionWasClosed':
          _markClosed(map);
          return;
      }
    } catch (e, st) {
      _handleError(e, st, showBanner: false);
    }
  }

  void _onSocketError(Object error, StackTrace st) {
    _handleError(error, st, showBanner: true);
  }

  void _handleNewMessage(Map<String, dynamic> json) {
    if (sessionChatId == null) return;

    final socketMessage = NewMessageModel.fromJson(json);

    final message = MessageModel(
      name: socketMessage.payload.operatorName,
      id: socketMessage.payload.id,
      createdAt: socketMessage.payload.createdAu,
      text: socketMessage.payload.text,
      type: socketMessage.payload.type,
      attachments: socketMessage.payload.attachments,
    );

    final index = _state.messages.indexWhere((e) => e.id == message.id);

    if (index != -1) {
      final list = [..._state.messages];

      list[index] = message.copyWith(status: MessageStatus.sent);

      _emit((s) => s.copyWith(messages: list));
    } else {
      _emit((s) => s.copyWith(messages: [message, ...s.messages]));
    }

    unawaited(readMessage(sessionId: sessionChatId!));
  }

  Future<void> _handleSessionClosed(dynamic map) async {
    if (sessionChatId == null) return;
    await readMessage(sessionId: sessionChatId!);

    _markClosed(map);

    await disconnect();
  }

  SocketConnectionChatStatus _mapTicketStatus(String? status) {
    switch (status) {
      case 'active':
        return SocketConnectionChatStatus.work;

      default:
        return SocketConnectionChatStatus.close;
    }
  }

  void _markClosed(dynamic map) {
    final socket = _state.socket;

    if (socket == null) return;

    final payload = map['payload'] as Map<String, dynamic>?;
    if (payload == null) return;

    final ticket = payload['ticket'] as Map<String, dynamic>?;
    final isRated = payload['rated'] ?? false;

    ChatType type = socket.type;

    SocketConnectionChatStatus status = SocketConnectionChatStatus.close;

    String title = socket.title;
    DateTime? deadline;

    int id = socket.id;

    if (ticket != null) {
      type = ChatType.ticket;
      final dateDeadline = ticket['deadline'] as String?;
      if (dateDeadline != null) {
        final formatIsoDate = DateTime.parse(dateDeadline);
        deadline = formatIsoDate;
      }
      title = ticket['title'] ?? socket.title;
      id = ticket['id'] ?? socket.id;
      status = _mapTicketStatus(ticket['status']);
    }

    final updated = socket.copyWith(
      deadline: deadline,
      isRated: isRated,
      id: id,
      type: type,
      title: title,
      status: status,
      canWrite: false,
    );
    _emit((s) => s.copyWith(socket: updated));
  }

  Future<void> _sendInitialMessageIfNeeded() async {
    if (_state.messages.isNotEmpty) {
      return;
    }

    if (_state.didSendInitialMessage) {
      return;
    }

    if (!_state.canWrite) {
      return;
    }

    _emit((s) => s.copyWith(didSendInitialMessage: true));
  }

  void _handleError(Object e, StackTrace st, {required bool showBanner}) {
    final mapped = AppErrorMapper.I.map(e, st);
    if (!showBanner) return;

    final now = DateTime.now();

    if (_lastBannerTime != null &&
        now.difference(_lastBannerTime!).inSeconds < 2) {
      return;
    }

    _lastBannerTime = now;
    BannerController.I.showError(error: mapped, message: mapped.message);
  }

  @override
  Future<void> reopenWebChat({required int sessionId}) async {
    try {
      final result = await chatUsecase.reopenWebChat(sessionId: sessionId);

      if (result == true && _state.socket != null) {
        final update = _state.socket!.copyWith(
          canWrite: true,
          status: SocketConnectionChatStatus.open,
        );
        _emit((s) => s.copyWith(socket: update));
        await connect();
      }
    } catch (e, st) {
      if (e is AppException) {
        BannerController.I.showError(error: e, message: e.message);
      } else {
        final error = AppErrorMapper.I.map(e, st);
        BannerController.I.showError(error: error, message: error.message);
      }
    }
  }

  @override
  Future<void> reviewChat({required int sessionId, required int score}) async {
    try {
      final resutl = await chatUsecase.postScoreWebChat(
        sessionId: sessionId,
        score: score,
      );
      if (resutl == true) {
        final update = _state.socket!.copyWith(isRated: true);
        _emit((s) => s.copyWith(socket: update));
      }
    } catch (e, st) {
      if (e is AppException) {
        BannerController.I.showError(error: e, message: e.message);
      } else {
        final error = AppErrorMapper.I.map(e, st);
        BannerController.I.showError(error: error, message: error.message);
      }
    }
  }
}
