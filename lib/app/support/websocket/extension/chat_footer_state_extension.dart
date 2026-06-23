import 'package:muzhiki_core/app/support/websocket/data/model/chat_websocket_state.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/socket_connection.dart';

extension SocketConnectionUiX on SocketConnectionModel {
  ChatFooterState get footerState {
    final isActiveStatus =
        status == SocketConnectionChatStatus.work ||
        status == SocketConnectionChatStatus.open ||
        status == SocketConnectionChatStatus.wait;

    if (type == ChatType.ticket && canWrite == false && isActiveStatus) {
      return ChatFooterState.ticketActive;
    }

    if (isActiveStatus) {
      return ChatFooterState.chat;
    }

    if (isRated) {
      return ChatFooterState.closedRated;
    }

    return ChatFooterState.closedNeedRating;
  }
}
