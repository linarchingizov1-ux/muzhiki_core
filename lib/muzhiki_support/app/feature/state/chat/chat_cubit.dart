import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_exception.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/my_chat.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/socket_connection.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/extension/chat_extension.dart';
import 'package:muzhiki_core/muzhiki_support/app/domain/usecase/chat_usecase.dart';

part 'chat_state.dart';
part 'chat_cubit.freezed.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatUseCase chatUseCase;
  ChatCubit({required this.chatUseCase}) : super(const ChatState());

  void silenceRefresh() async {
    print("Тихо обновили чат");
    final myChat = await chatUseCase.getMyChats(page: state.chatPage);
    int channelId;
    if (state.channelId != null) {
      channelId = state.channelId!;
    } else if (myChat.channels.isNotEmpty) {
      channelId = myChat.channels.first.id;
    } else {
      channelId = 0;
    }
    final chats = myChat.chatsChannel(channelId: channelId);
    emit(state.copyWith(myChat: myChat, chats: chats, channelId: channelId));
  }

  Future<void> getMyChats() async {
    emit(state.copyWith(chatStatus: StateStatus.loading));
    try {
      final myChat = await chatUseCase.getMyChats(page: state.chatPage);

      int channelId;
      if (state.channelId != null) {
        channelId = state.channelId!;
      } else if (myChat.channels.isNotEmpty) {
        channelId = myChat.channels.first.id;
      } else {
        channelId = 0;
      }

      final chats = myChat.chatsChannel(channelId: channelId);

      emit(
        state.copyWith(
          chatStatus: StateStatus.success,
          myChat: myChat,
          chats: chats,
          channelId: channelId,
        ),
      );
    } catch (e, st) {
      if (e is SupportedUserNotFoundExceptionMap) {
        emit(state.copyWith(chatStatus: StateStatus.userNotFound));
        addError(e, st);
      }
      if (e is SupportedIsFakeUser) {
        emit(state.copyWith(chatStatus: StateStatus.isFakeUser));
        addError(e, st);
      } else {
        emit(
          state.copyWith(
            chatStatus: StateStatus.fail,
            error: e as AppException,
          ),
        );
        addError(e, st);
      }
    }
  }

  Future<void> onPopScopeResultForChat() async {
    try {
      final myChat = await chatUseCase.getMyChats(page: state.chatPage);

      int channelId;
      if (state.channelId != null) {
        channelId = state.channelId!;
      } else if (myChat.channels.isNotEmpty) {
        channelId = myChat.channels.first.id;
      } else {
        channelId = 0;
      }

      final chats = myChat.chatsChannel(channelId: channelId);

      emit(state.copyWith(myChat: myChat, chats: chats, channelId: channelId));
    } catch (e, st) {
      addError(AppErrorMapper.I.map(e, st), st);
    }
  }

  Future<void> getMessageChat({required int id}) async {
    try {
      emit(state.copyWith(chatStatus: StateStatus.loading));

      final message = await chatUseCase.getMessageChat(sessionId: id);

      emit(
        state.copyWith(
          chatStatus: StateStatus.success,
          messageChat: message.messages,
        ),
      );
    } catch (e, st) {
      addError(AppErrorMapper.I.map(e, st), st);

      emit(state.copyWith(chatStatus: StateStatus.success));
    }
  }

  Future<void> createSession({Function(int sessionId)? action}) async {
    if (state.chatStatus != StateStatus.success) {
      return;
    }
    if (state.channelId == null) return;

    try {
      emit(state.copyWith(chatStatus: StateStatus.loading));

      final sessionId = await chatUseCase.createSession(
        channelId: state.channelId!,
      );

      final socketConnection = await chatUseCase.getMessageChat(
        sessionId: sessionId,
      );

      action?.call(sessionId);

      final myChats = await chatUseCase.getMyChats(page: state.chatPage);

      int channelId;
      if (state.channelId != null) {
        channelId = state.channelId!;
      } else if (myChats.channels.isNotEmpty) {
        channelId = myChats.channels.first.id;
      } else {
        channelId = 0;
      }

      final chats = myChats.chatsChannel(channelId: channelId);

      emit(
        state.copyWith(
          chatStatus: StateStatus.success,
          socketConnection: socketConnection,
          chats: chats,
        ),
      );
    } catch (e, st) {
      addError(AppErrorMapper.I.map(e, st), st);

      emit(state.copyWith(chatStatus: StateStatus.success));
    }
  }

  Future<void> selecteChannel({
    required int index,
    required int channelId,
  }) async {
    if (index == state.selectedChannels) return;
    if (state.myChat == null) return;

    final chats = state.myChat!.chatsChannel(channelId: channelId);

    emit(
      state.copyWith(
        channelId: channelId,
        selectedChannels: index,
        chats: chats,
      ),
    );
  }

  void sendProblems({required AppException? error}) async {
    final error = state.error;

    final validError =
        error?.message ??
        error?.originalError ??
        error?.debugMessage ??
        error?.stackTrace?.toString() ??
        'No details';
    await chatUseCase.sendProblems(
      error: error ?? AppException(message: validError.toString()),
      source: 'Список чатов поддержки (mp_master)',
    );
  }
}
