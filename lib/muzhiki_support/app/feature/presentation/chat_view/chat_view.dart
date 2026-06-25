// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mp_master_app/src/core/dependencies/app_dependencies.dart';
// import 'package:mp_master_app/src/core/utils/extension/support/date_format.dart';
// import 'package:mp_master_app/src/core/websocket/chat_websocket_app.dart';
// import 'package:mp_master_app/src/data/model/navigation_event.dart';
// import 'package:mp_master_app/src/features/main/view_support/chat_view/chat_bottom_widgets.dart';
// import 'package:mp_master_app/src/features/main/view_support/chat_view/chat_header_widgets.dart';
// import 'package:mp_master_app/src/features/main/view_support/chat_view/chat_message_widgets.dart';
// import 'package:mp_master_app/src/features/main/view_support/state/attachments/attachments_cubit.dart';

// String _startNewSessionText = 'Здравствуйте 👋!';

// Object? _chatViewExtra;

// class ChatView extends StatefulWidget {
//   final int id;
//   final Object? extra;

//   const ChatView({super.key, required this.id, this.extra});

//   @override
//   State<ChatView> createState() => _ChatViewState();
// }

// class _ChatViewState extends State<ChatView> {
//   late final AppWebsocketChat websocketApp;
//   late final AttachmentsCubit attachmentsCubit;

//   @override
//   void initState() {
//     super.initState();
//     websocketApp = AppWebsocketChat(widget.id);
//     attachmentsCubit = getIt<AttachmentsCubit>();
//     websocketApp.connect();
//     _chatViewExtra = widget.extra;
//     if (_chatViewExtra is OpenSupportRecordsEvent) {
//       final event = _chatViewExtra as OpenSupportRecordsEvent;
//       final record = event.model;

//       final services = record.services.map((s) => s.name).join(', ');

//       _startNewSessionText = [
//         'Здравствуйте 👋!\n',

//         'Пишу насчет записи. Клиент: ${record.client?.name ?? 'Нет имени'}.\n',

//         '• ID записи: ${record.id}',
//         '• Статус: ${record.status.name}',
//         if (record.companyName?.trim().isNotEmpty == true)
//           '• Салон: ${record.companyName}',
//         '• Дата: ${record.datetime?.formatDate}',
//         '• Комментарий: ${record.comment ?? 'нет'}',
//         '• Услуги: $services',
//       ].join('\n');
//     }
//   }

//   @override
//   void dispose() {
//     websocketApp.dispose();
//     attachmentsCubit.clear();
//     super.dispose();
//   }

//   EdgeInsets get mq => MediaQuery.paddingOf(context);

//   double get topInset => mq.top;
//   double get bottomInset => mq.bottom;

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.dark,
//       child: Scaffold(
//         body: StreamBuilder(
//           initialData: websocketApp.state,
//           stream: websocketApp.stream,
//           builder: (context, snapshot) {
//             return Stack(
//               children: [
//                 ChatMessageWidgets(
//                   websocket: websocketApp,
//                   topInset: topInset,
//                   bottomInset: bottomInset,
//                   snapshot: snapshot,
//                 ),
//                 Positioned(
//                   left: 17.w,
//                   right: 17.w,
//                   top: topInset + 10.h,
//                   child: ChatHeaderWidgets(
//                     snapshot: snapshot,
//                     chatViewExtra: _chatViewExtra,
//                   ),
//                 ),

//                 Positioned(
//                   left: 17.w,
//                   right: 17.w,
//                   bottom: bottomInset + 15.h,
//                   child: ChatBottomWidgets(
//                     snapshot: snapshot,
//                     attachmentsCubit: attachmentsCubit,
//                     websocket: websocketApp,
//                     sessionId: widget.id,
//                     initMessage: _startNewSessionText,
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
