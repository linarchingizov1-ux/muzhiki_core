import 'dart:ui';

import 'package:muzhiki_ui/theme/muzhiki_colors.dart';
import 'package:muzhiki_support/data/models/socket/socket_connection.dart';
import 'package:muzhiki_support/shared/extensions/date_format.dart';

enum ChatFooterState {
  chat,
  closedNeedRating,
  closedRated,
  ticketActive,
  initial,
}

class WebSocketChatState {
  final List<MessageModel> messages;

  final SocketConnectionModel? socket;

  final bool didSendInitialMessage;

  final bool hasError;

  final String? errorMessage;

  final bool isConnecting;

  const WebSocketChatState({
    this.messages = const [],
    this.socket,
    this.didSendInitialMessage = false,
    this.hasError = false,
    this.errorMessage,
    this.isConnecting = true,
  });

  bool get showMessageSkeleton => isConnecting && messages.isEmpty;

  bool get showHeaderSkeleton => isConnecting && socket == null;

  bool get canWrite =>
      socket?.canWrite == true &&
      socket?.status != SocketConnectionChatStatus.close;

  bool get showTicketInfo {
    if (socket == null) return false;

    return socket!.type == ChatType.ticket &&
        socket!.status != SocketConnectionChatStatus.close;
  }

  SocketConnectionChatStatus? get status => socket?.status;

  String? get title => socket?.title;

  String? get operatorAvatar => socket?.operators.firstOrNull?.avatar;

  String? get createdAt => socket?.createdAt?.formatDate;

  String get stringStatus {
    if (status == SocketConnectionChatStatus.close) {
      return 'Закрыто';
    }

    if (status == SocketConnectionChatStatus.work ||
        status == SocketConnectionChatStatus.open) {
      return 'В работе';
    }

    if (status == SocketConnectionChatStatus.inital) {
      return "";
    }

    return 'Ожидает вашего ответа';
  }

  Color get statusColor {
    return status == SocketConnectionChatStatus.close
        ? MuzhikiColors.blood
        : MuzhikiColors.orange;
  }

  WebSocketChatState copyWith({
    List<MessageModel>? messages,
    SocketConnectionModel? socket,
    bool? didSendInitialMessage,
    bool? hasError,
    String? errorMessage,
    bool? isConnecting,
  }) {
    return WebSocketChatState(
      messages: messages ?? this.messages,
      socket: socket ?? this.socket,
      didSendInitialMessage:
          didSendInitialMessage ?? this.didSendInitialMessage,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      isConnecting: isConnecting ?? this.isConnecting,
    );
  }
}
