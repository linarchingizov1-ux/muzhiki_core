import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_support/data/models/socket/chat_websocket_state.dart';
import 'package:muzhiki_support/data/models/socket/socket_connection.dart';
import 'package:muzhiki_support/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_support/data/websocket/extensions/chat_footer_state_extension.dart';
import 'package:muzhiki_support/shared/extensions/date_format.dart';
import 'package:muzhiki_support/features/chat/widgets/chat_bottom_area_closed_and_rated_widgets.dart';
import 'package:muzhiki_support/features/chat/widgets/chat_bottom_area_rated_widgets.dart';
import 'package:muzhiki_support/features/chat/widgets/chat_bottom_area_ticket_widgets.dart';
import 'package:muzhiki_support/features/home/state/chat_cubit.dart';
import 'package:muzhiki_support/shared/widgets/bubble_chat.dart';
import 'package:muzhiki_ui/other/other.dart';

const _other = MuzhikiOther();

class ChatMessageWidgets extends StatefulWidget {
  final AppWebsocketChat websocket;
  final ChatCubit chatCubit;
  final Directory directory;
  final double topInset;
  final double bottomInset;
  final AsyncSnapshot<WebSocketChatState> snapshot;

  const ChatMessageWidgets({
    required this.snapshot,
    super.key,
    required this.websocket,
    required this.topInset,
    required this.bottomInset,
    required this.chatCubit,
    required this.directory,
  });

  static const _skeletonPlaceholders = [
    MessageModel(id: 'sk_1', text: 'Здравствуйте', type: MessageType.operator),
    MessageModel(id: 'sk_2', text: 'Добрый день', type: MessageType.client),
    MessageModel(
      id: 'sk_3',
      text: 'Чем могу помочь?',
      type: MessageType.operator,
    ),
    MessageModel(
      id: 'sk_4',
      text: 'Есть вопрос по обращению',
      type: MessageType.client,
    ),
  ];

  @override
  State<ChatMessageWidgets> createState() => _ChatMessageWidgetsState();
}

class _ChatMessageWidgetsState extends State<ChatMessageWidgets> {
  final Set<String> _knownIds = {};
  bool _armed = false;
  bool _hadSkeleton = false;
  String? _newestId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _captureCurrentIds();
      _armed = true;
    });
  }

  @override
  void didUpdateWidget(ChatMessageWidgets oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_armed) return;

    final messages = _visibleMessages;
    if (messages == null || messages.isEmpty) return;

    if (_knownIds.isEmpty && (_hadSkeleton || messages.length > 1)) {
      _captureCurrentIds();
      return;
    }

    final newest = messages.first.id;
    if (_newestId != null &&
        newest != _newestId &&
        !_knownIds.contains(newest) &&
        messages.every((m) => m.id != _newestId)) {
      _knownIds.add(newest);
    }
    _newestId = newest;
  }

  List<MessageModel>? get _visibleMessages {
    final data = widget.snapshot.data;
    if (data == null || data.showMessageSkeleton) return null;
    return data.messages;
  }

  void _captureCurrentIds() {
    final messages = _visibleMessages;
    if (messages == null) return;
    _knownIds.addAll(messages.map((m) => m.id));
    _newestId = messages.firstOrNull?.id;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.snapshot.data;
    final showSkeleton = data?.showMessageSkeleton ?? true;
    if (showSkeleton) {
      _hadSkeleton = true;
    }
    final messages = showSkeleton
        ? ChatMessageWidgets._skeletonPlaceholders
        : data!.messages;
    final hasFooter =
        data?.socket?.footerState == ChatFooterState.chat ||
        data?.socket?.footerState == ChatFooterState.initial;
    return InkWell(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              reverse: true,
              scrollCacheExtent: ScrollCacheExtent.pixels(300),
              physics: showSkeleton
                  ? const NeverScrollableScrollPhysics()
                  : null,
              padding: EdgeInsets.only(
                top: widget.topInset + 80.h,
                left: 17.w,
                right: 17.w,
                bottom: hasFooter
                    ? MediaQuery.paddingOf(context).bottom + 65.h + 16.h
                    : 16.h,
              ),
              itemCount: messages.length,
              separatorBuilder: (_, _) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final mess = messages[index];
                final isMe = mess.type == MessageType.client;
                final animateInsert =
                    !showSkeleton &&
                    index == 0 &&
                    _armed &&
                    !_knownIds.contains(mess.id);

                if (animateInsert) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _knownIds.add(mess.id);
                  });
                }

                return _other.skelet(
                  enable: showSkeleton,
                  child: ChatMessageBubble(
                    animateInsert: animateInsert,
                    chatCubit: widget.chatCubit,
                    directory: widget.directory,
                    websocketChat: widget.websocket,
                    key: ValueKey(mess.id),
                    avatar: data?.operatorAvatar,
                    mess: mess,
                    attachments: mess.attachments,
                    isMe: isMe,
                    messageDate:
                        mess.createdAt?.formatDateOnlyTime ??
                        DateTime.now().formatDateOnlyTime,
                  ),
                );
              },
            ),
          ),
          if (widget.snapshot.data != null && widget.snapshot.data!.socket != null)
            Builder(
              builder: (context) {
                switch (widget.snapshot.data!.socket!.footerState) {
                  case ChatFooterState.closedNeedRating:
                    return ChatBottomAreaRatedWidgets(
                      webSocketApp: widget.websocket,
                      state: widget.snapshot.data!,
                    );

                  case ChatFooterState.closedRated:
                    return ChatBottomAreaClosedAndRatedWidgets(
                      webSocketApp: widget.websocket,
                      state: widget.snapshot.data!,
                    );

                  case ChatFooterState.ticketActive:
                    return ChatBottomAreaTicketWidgets(
                      webSocketApp: widget.websocket,
                      state: widget.snapshot.data!,
                    );
                  case ChatFooterState.chat || ChatFooterState.initial:
                    return const SizedBox.shrink();
                }
              },
            ),
        ],
      ),
    );
  }
}
