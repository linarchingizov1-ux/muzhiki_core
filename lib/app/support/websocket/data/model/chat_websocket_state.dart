import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:muzhiki_core/app/support/websocket/extension/date_format.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/socket_connection.dart';

enum ChatFooterState { chat, closedNeedRating, closedRated, ticketActive }

class WebSocketChatState {
  final List<MessageModel> messages;

  final SocketConnectionModel? socket;

  final bool didSendInitialMessage;

  final bool hasError;

  final String? errorMessage;

  const WebSocketChatState({
    this.messages = const [
      MessageModel(
        id: 'mock_1',
        name: 'Оператор',
        text: 'Здравствуйте',
        type: MessageType.operator,
        attachments: [],
      ),
      MessageModel(
        id: 'mock_2',
        name: 'Вы',
        text: 'Добрый день',
        type: MessageType.client,
        attachments: [],
      ),
      MessageModel(
        id: 'mock_3',
        name: 'Оператор',
        text: 'Чем могу помочь?',
        type: MessageType.operator,
        attachments: [],
      ),
      MessageModel(
        id: 'mock_4',
        name: 'Вы',
        text: 'Есть вопрос по обращению',
        type: MessageType.client,
        attachments: [],
      ),
      MessageModel(
        id: 'mock_5',
        name: 'Оператор',
        text: 'Конечно, уточните пожалуйста детали',
        type: MessageType.operator,
        attachments: [],
      ),
      MessageModel(
        id: 'mock_6',
        name: 'Вы',
        text: 'Я отправлял фото, но не уверен что они загрузились',
        type: MessageType.client,
        attachments: [],
      ),
      MessageModel(
        id: 'mock_7',
        name: 'Оператор',
        text: 'Сейчас проверю информацию, одну минуту',
        type: MessageType.operator,
        attachments: [],
      ),
      MessageModel(
        id: 'mock_8',
        name: 'Оператор',
        text: 'Да, фотографии получены, всё в порядке',
        type: MessageType.operator,
        attachments: [],
      ),
      MessageModel(
        id: 'mock_9',
        name: 'Вы',
        text: 'Отлично, спасибо',
        type: MessageType.client,
        attachments: [],
      ),
      MessageModel(
        id: 'mock_10',
        name: 'Вы',
        text: 'А когда будет результат проверки?',
        type: MessageType.client,
        attachments: [],
      ),
      MessageModel(
        id: 'mock_11',
        name: 'Оператор',
        text: 'Обычно это занимает до 24 часов',
        type: MessageType.operator,
        attachments: [],
      ),
      MessageModel(
        id: 'mock_12',
        name: 'Оператор',
        text: 'Мы уведомим вас, как только всё будет готово',
        type: MessageType.operator,
        attachments: [],
      ),
      MessageModel(
        id: 'mock_13',
        name: 'Вы',
        text: 'Хорошо, буду ждать',
        type: MessageType.client,
        attachments: [],
      ),
      MessageModel(
        id: 'mock_14',
        name: 'Оператор',
        text: 'Спасибо за обращение 🙌',
        type: MessageType.operator,
        attachments: [],
      ),
    ],
    this.socket,
    this.didSendInitialMessage = false,
    this.hasError = false,
    this.errorMessage,
  });

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

  String? get operatorAvatar => socket?.avatar;

  String? get createdAt => socket?.createdAt.formatDate;

  String get stringStatus {
    if (status == SocketConnectionChatStatus.close) {
      return 'Закрыто';
    }

    if (status == SocketConnectionChatStatus.work ||
        status == SocketConnectionChatStatus.open) {
      return 'В работе';
    }

    return 'Ожидает вашего ответа';
  }

  Color get statusColor {
    return status == SocketConnectionChatStatus.close
        ? Color.fromARGB(255, 227, 0, 22)
        : Color.fromARGB(255, 239, 171, 45);
  }

  WebSocketChatState copyWith({
    List<MessageModel>? messages,
    SocketConnectionModel? socket,
    bool? didSendInitialMessage,
    bool? hasError,
    String? errorMessage,
  }) {
    return WebSocketChatState(
      messages: messages ?? this.messages,
      socket: socket ?? this.socket,
      didSendInitialMessage:
          didSendInitialMessage ?? this.didSendInitialMessage,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
    );
  }
}
