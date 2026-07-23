import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/url_launch/url_launch.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/socket_connection.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/state/chat/chat_cubit.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/chat_attachment.dart';
import 'package:shimmer/shimmer.dart';

class ChatMessageBubble extends StatefulWidget {
  final AppWebsocketChat websocketChat;
  final ChatCubit chatCubit;
  final Directory directory;
  final MessageModel mess;
  final bool isMe;
  final String messageDate;
  final FocusNode? fucusNode;
  final String? avatar;
  final List<AttachmentsModel>? attachments;

  const ChatMessageBubble({
    required this.websocketChat,
    this.avatar,
    super.key,
    required this.mess,
    this.fucusNode,
    this.attachments,
    required this.isMe,
    required this.messageDate,
    required this.chatCubit,
    required this.directory,
  });

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrained) {
        return Row(
          spacing: 6.w,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: widget.isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!widget.isMe)
              CircleAvatar(
                radius: 22.r,
                child: widget.avatar == null || widget.avatar!.isEmpty
                    ? Icon(Icons.person, size: 20.r, color: Colors.grey)
                    : ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: widget.avatar!,
                          width: 44.r,
                          height: 44.r,
                          memCacheHeight: 44,
                          memCacheWidth: 44,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              width: 44.r,
                              height: 44.r,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          errorWidget: (_, __, ___) => Icon(
                            Icons.person,
                            size: 20.r,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),
            Container(
              constraints: BoxConstraints(
                maxWidth: constrained.maxWidth * 0.75,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: widget.isMe ? SupportColors.light : SupportColors.white,
              ),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 11.w,
                        right: 11.w,
                        top: 5.h,
                        bottom: 5.h,
                      ),
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        widget.isMe ? 'Вы' : (widget.mess.name ?? ''),
                        style: TextStyle(
                          height: 1.h,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: SupportColors.blood,
                        ).copyWith(fontFamily: 'Inter'),
                      ),
                    ),
                    if (widget.mess.text.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          left: 11.w,
                          right: 11.w,
                          bottom: 5.h,
                        ),
                        child: _MessageWidgetState(text: widget.mess.text),
                      ),
                    if (widget.attachments != null &&
                        widget.attachments!.isNotEmpty)
                      _BubbleAttachment(
                        directory: widget.directory,
                        chatCubit: widget.chatCubit,
                        websocketChat: widget.websocketChat,
                        attachments: widget.attachments!,
                        width: constrained.maxWidth,
                      ),
                    if (widget.messageDate.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 11.w, right: 11.w),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            spacing: 5.w,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.messageDate,
                                style: TextStyle(
                                  height: 2.h,
                                  color: SupportColors.grey,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              if (widget.mess.status != null)
                                switch (widget.mess.status) {
                                  (MessageStatus.sending) =>
                                    Icon(
                                          Icons.schedule_rounded,
                                          size: 16.r,
                                          color: SupportColors.grey,
                                        )
                                        .animate(
                                          onPlay: (controller) =>
                                              controller.repeat(),
                                        )
                                        .rotate(
                                          duration: 1.seconds,
                                          curve: Curves.linear,
                                        ),
                                  (MessageStatus.failed) => Icon(
                                    Icons.close,
                                    size: 16.r,
                                    color: SupportColors.blood,
                                  ),
                                  MessageStatus.sent ||
                                  null => const SizedBox.shrink(),
                                },
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MessageWidgetState extends StatefulWidget {
  final String text;
  const _MessageWidgetState({required this.text});

  @override
  State<_MessageWidgetState> createState() => __MessageWidgetStateState();
}

class __MessageWidgetStateState extends State<_MessageWidgetState> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
    super.dispose();
  }

  Widget buildMessage(String text) {
    final urlRegExp = RegExp(r'(https?:\/\/[^\s]+)');

    final spans = <TextSpan>[];

    text.splitMapJoin(
      urlRegExp,
      onMatch: (m) {
        final url = m.group(0)!;

        spans.add(
          TextSpan(
            text: url,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                MuzhikiUrlLaunch.I.openURL(url: url);
              },
          ),
        );

        return '';
      },
      onNonMatch: (t) {
        spans.add(
          TextSpan(
            text: t,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        );

        return '';
      },
    );

    return SelectableText.rich(TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    return buildMessage(widget.text);
  }
}

class _BubbleAttachment extends StatelessWidget {
  final List<AttachmentsModel> attachments;
  final AppWebsocketChat websocketChat;
  final Directory directory;
  final ChatCubit chatCubit;
  final double width;
  const _BubbleAttachment({
    required this.attachments,
    required this.width,
    required this.websocketChat,
    required this.chatCubit,
    required this.directory,
  });

  int get count => attachments.length;

  @override
  Widget build(BuildContext context) {
    switch (count) {
      case 1:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          child: ChatAttachment(
            attachment: attachments.first,
            websocketChat: websocketChat,
            chatCubit: chatCubit,
            directory: directory,
          ),
        );
      default:
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width * 0.75, maxHeight: 77.w),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 5.w,
              children: List.generate(attachments.length, (index) {
                return SizedBox(
                  width: 77.w,
                  height: 77.w,
                  child: ChatAttachment(
                    attachment: attachments[index],
                    websocketChat: websocketChat,
                    chatCubit: chatCubit,
                    directory: directory,
                  ),
                );
              }),
            ),
          ),
        );
    }
  }
}
