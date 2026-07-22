part of 'chat_cubit.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default(null) MyChatModel? myChat,
    @Default(1) int chatPage,
    @Default([]) List<MessageModel> messageChat,
    @Default(0) int selectedChannels,
    int? channelId,
    @Default([]) List<ChatModel> chats,
    @Default(StateStatus.loading) StateStatus chatStatus,
    AppException? error,
  }) = _ChatState;
}

enum StateStatus { loading, success, fail, userNotFound, isFakeUser }
