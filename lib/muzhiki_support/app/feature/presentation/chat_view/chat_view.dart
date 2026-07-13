import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/support_chats_event_widgets.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/muzhiki_support/app/domain/usecase/chat_usecase.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/chat_view/chat_bottom_widgets.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/chat_view/chat_header_widgets.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/chat_view/chat_message_widgets.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/state/attachments/attachments_cubit.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/state/chat/chat_cubit.dart';

String _startNewSessionText = 'Здравствуйте 👋!';

class ChatView extends StatefulWidget {
  final ChatUseCase chatUseCase;
  final ChatCubit chatCubit;
  final Directory directory;
  final SessionApp session;
  final AttachmentsCubit attachmentsCubit;
  final int id;
  final Object? extra;

  const ChatView({
    super.key,
    required this.id,
    this.extra,
    required this.chatUseCase,
    required this.session,
    required this.attachmentsCubit,
    required this.chatCubit,
    required this.directory,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final AppWebsocketChat websocketApp;
  bool needUpdate = true;

  @override
  void initState() {
    super.initState();
    websocketApp = AppWebsocketChat(
      sessionChatId: widget.id,
      chatUsecase: widget.chatUseCase,
      session: widget.session,
    );
    websocketApp.connect();

    switch (widget.extra) {
      case SupportChatsEventWidgets event:
        if (event.type == SupportChatsEventWidgetsType.records) {
          _startNewSessionText = event.label;
        } else if (event.type == SupportChatsEventWidgetsType.mobileWidgets) {
          needUpdate = false;
        }
        break;
    }
  }

  @override
  void dispose() {
    websocketApp.dispose();
    widget.attachmentsCubit.clear();
    super.dispose();
  }

  EdgeInsets get mq => MediaQuery.paddingOf(context);

  double get topInset => mq.top;
  double get bottomInset => mq.bottom;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (needUpdate) {
            widget.chatCubit.silenceRefresh();
          }
        },
        child: Scaffold(
          body: StreamBuilder(
            initialData: websocketApp.state,
            stream: websocketApp.stream,
            builder: (context, snapshot) {
              return Stack(
                children: [
                  ChatMessageWidgets(
                    websocket: websocketApp,
                    topInset: topInset,
                    bottomInset: bottomInset,
                    snapshot: snapshot,
                    chatCubit: widget.chatCubit,
                    directory: widget.directory,
                  ),
                  Positioned(
                    left: 17.w,
                    right: 17.w,
                    top: topInset + 10.h,
                    child: ChatHeaderWidgets(snapshot: snapshot),
                  ),

                  Positioned(
                    left: 17.w,
                    right: 17.w,
                    bottom: bottomInset + 15.h,
                    child: ChatBottomWidgets(
                      snapshot: snapshot,
                      attachmentsCubit: widget.attachmentsCubit,
                      websocket: websocketApp,
                      sessionId: widget.id,
                      initMessage: _startNewSessionText,
                      directory: widget.directory,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
