// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:muzhiki_core/app/support/state/attachments/attachments_cubit.dart';
// import 'package:muzhiki_core/app/support/ui/widgets/text_field.dart';
// import 'package:muzhiki_core/app/support/websocket/chat_websocket_app.dart';
// import 'package:muzhiki_core/app/support/websocket/data/model/attachments/local_attachments.dart';
// import 'package:muzhiki_core/app/support/websocket/data/model/chat_websocket_state.dart';
// import 'package:muzhiki_core/app/support/websocket/extension/chat_footer_state_extension.dart';
// import 'package:muzhiki_core/dependecies/service/app_banner/app_banner_controller.dart';

// class ChatBottomWidgets extends StatefulWidget {
//   final AttachmentsCubit attachmentsCubit;
//   final AppWebsocketChat websocket;
//   final int sessionId;
//   final String initMessage;
//   final AsyncSnapshot<WebSocketChatState> snapshot;
//   const ChatBottomWidgets({
//     super.key,
//     required this.attachmentsCubit,
//     required this.websocket,
//     required this.sessionId,
//     required this.snapshot,
//     required this.initMessage,
//   });

//   @override
//   State<ChatBottomWidgets> createState() => _ChatBottomWidgetsState();
// }

// class _ChatBottomWidgetsState extends State<ChatBottomWidgets> {
//   late final TextEditingController textEditingController;

//   @override
//   void initState() {
//     super.initState();
//     textEditingController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     textEditingController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.snapshot.connectionState != ConnectionState.active) {
//       return const SizedBox.shrink();
//     }

//     if (widget.snapshot.data!.didSendInitialMessage &&
//         textEditingController.text.isEmpty) {
//       textEditingController.text = widget.initMessage;
//     }
//     final socket = widget.snapshot.data!.socket;

//     if (socket == null) {
//       return const SizedBox.shrink();
//     }
//     if (socket.footerState == ChatFooterState.chat) {
//       return BlocProvider.value(
//         value: widget.attachmentsCubit,
//         child: BlocBuilder<AttachmentsCubit, AttachmentsState>(
//           builder: (context, state) {
//             return TextFieldWidgets(
//               controller: textEditingController,
//               send: () async {
//                 final text = textEditingController.text.trim();

//                 final uploadedFiles = state.items.where((e) => e.isRemote);

//                 final isUploading = state.items.any((e) => e.isLocal);

//                 final hasText = text.isNotEmpty;

//                 final hasFiles = uploadedFiles.isNotEmpty;

//                 if (isUploading) {
//                   BannerController.I.show(message: 'Файлы ещё загружаются');

//                   return;
//                 }

//                 if (!hasText && !hasFiles) {
//                   return;
//                 }

//                 final uuidFile = uploadedFiles
//                     .map(
//                       (e) => e.when(
//                         local: (_, _, _, _) => null,
//                         remote: (_, _, data) => data.uuid,
//                       ),
//                     )
//                     .whereType<String>()
//                     .toSet()
//                     .toList();

//                 await widget.websocket.sendMessage(
//                   sessionId: widget.sessionId,
//                   text: text,
//                   attachments: uuidFile,
//                 );

//                 widget.attachmentsCubit.clear();

//                 textEditingController.clear();
//               },
//             );
//           },
//         ),
//       );
//     } else {
//       return const SizedBox.shrink();
//     }
//   }
// }
