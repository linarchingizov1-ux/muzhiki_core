import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/attachments/local_attachments.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/chat_websocket_state.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/extension/chat_footer_state_extension.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/state/attachments/attachments_cubit.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/text_field.dart';

class ChatBottomWidgets extends StatefulWidget {
  final AttachmentsCubit attachmentsCubit;
  final Directory directory;
  final AppWebsocketChat websocket;
  final String initMessage;
  final AsyncSnapshot<WebSocketChatState> snapshot;
  const ChatBottomWidgets({
    super.key,
    required this.directory,
    required this.attachmentsCubit,
    required this.websocket,
    required this.snapshot,
    required this.initMessage,
  });

  @override
  State<ChatBottomWidgets> createState() => _ChatBottomWidgetsState();
}

class _ChatBottomWidgetsState extends State<ChatBottomWidgets> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.snapshot.connectionState != ConnectionState.active) {
      return const SizedBox.shrink();
    }

    if (widget.snapshot.data!.didSendInitialMessage &&
        textEditingController.text.isEmpty) {
      textEditingController.text = widget.initMessage;
    }
    final socket = widget.snapshot.data!.socket;

    if (socket == null) {
      return const SizedBox.shrink();
    }
    if (socket.footerState == ChatFooterState.chat) {
      return BlocProvider.value(
        value: widget.attachmentsCubit,
        child: BlocBuilder<AttachmentsCubit, AttachmentsState>(
          builder: (context, state) {
            return TextFieldWidgets(
              attachmentsCubit: widget.attachmentsCubit,
              directory: widget.directory,
              controller: textEditingController,
              send: () async {
                final text = textEditingController.text.trim();

                final uploadedFiles = state.items.where((e) => e.isRemote);

                final isUploading = state.items.any((e) => e.isLocal);

                final hasText = text.isNotEmpty;

                final hasFiles = uploadedFiles.isNotEmpty;

                if (isUploading) {
                  BannerController.I.show(message: 'Файлы ещё загружаются');

                  return;
                }

                if (!hasText && !hasFiles) {
                  return;
                }

                final uuidFile = uploadedFiles
                    .map(
                      (e) => e.when(
                        local: (_, _, _, _) => null,
                        remote: (_, _, data) => data.uuid,
                      ),
                    )
                    .whereType<String>()
                    .toSet()
                    .toList();

                int? sessionId = widget.websocket.sessionChatId;

                if (widget.websocket.isDraft || !widget.websocket.isConnected) {
                  sessionId = await widget.websocket.createSessionAndConnect();
                }

                if (sessionId == null) return;

                await widget.websocket.sendMessage(
                  sessionId: sessionId,
                  text: text,
                  attachments: uuidFile,
                );

                widget.attachmentsCubit.clear();

                textEditingController.clear();
              },
            );
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
