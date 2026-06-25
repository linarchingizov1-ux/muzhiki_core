import 'package:muzhiki_core/muzhiki_support/app/data/model/my_chat.dart';

extension ChatExtension on MyChatModel {
  List<ChatModel> chatsChannel({required int channelId}) {
    final chats = this.chats;
    final newChats = chats.where((m) => m.channelId == channelId).toList();
    return newChats;
  }
}

extension ChatUnreadX on List<ChatModel> {
  int unreadByChannel(int channelId) {
    return where(
      (chat) => chat.channelId == channelId,
    ).fold(0, (sum, chat) => sum + (chat.unreadCount));
  }
}
