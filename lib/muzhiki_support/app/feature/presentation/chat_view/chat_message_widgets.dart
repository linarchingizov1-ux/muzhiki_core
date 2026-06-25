// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/chat_websocket_state.dart';
// import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/socket_connection.dart';
// import 'package:muzhiki_core/muzhiki_support/app/data/websocket/chat_websocket_app.dart';
// import 'package:muzhiki_core/muzhiki_support/app/data/websocket/extension/chat_footer_state_extension.dart';
// import 'package:muzhiki_core/muzhiki_support/app/data/websocket/extension/date_format.dart';
// import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/chat_view/widgets/chat_bottom_area_closed_and_rated_widgets.dart';
// import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/chat_view/widgets/chat_bottom_area_rated_widgets.dart';
// import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/chat_view/widgets/chat_bottom_area_ticket_widgets.dart';
// import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/bubble_chat.dart';
// import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/skelet.dart';

// class ChatMessageWidgets extends StatelessWidget {
//   final AppWebsocketChat websocket;
//   final double topInset;
//   final double bottomInset;
//   final AsyncSnapshot<WebSocketChatState> snapshot;

//   const ChatMessageWidgets({
//     required this.snapshot,
//     super.key,
//     required this.websocket,
//     required this.topInset,
//     required this.bottomInset,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
//       },
//       child: Column(
//         children: [
//           Expanded(
//             child: ListView.separated(
//               reverse: true,
//               scrollCacheExtent: ScrollCacheExtent.pixels(300),
//               physics: snapshot.connectionState != ConnectionState.active
//                   ? const NeverScrollableScrollPhysics()
//                   : null,
//               padding: EdgeInsets.only(
//                 top: topInset + 80.h,
//                 left: 17.w,
//                 right: 17.w,
//                 bottom:
//                     snapshot.data != null &&
//                         snapshot.data!.socket != null &&
//                         snapshot.data!.socket!.footerState ==
//                             ChatFooterState.chat
//                     ? MediaQuery.paddingOf(context).bottom + 65.h + 16.h
//                     : 16.h,
//               ),
//               itemCount: snapshot.data!.messages.length,
//               separatorBuilder: (_, _) => SizedBox(height: 10.h),
//               itemBuilder: (context, index) {
//                 final mess = snapshot.data!.messages[index];

//                 final isMe = mess.type == MessageType.client;

//                 return AppSkelet(
//                   enable: snapshot.connectionState != ConnectionState.active,
//                   child: ChatMessageBubble(
//                     websocketChat: websocket,
//                     key: ValueKey(mess.id),
//                     avatar: snapshot.data!.operatorAvatar,
//                     mess: mess,
//                     attachments: mess.attachments,
//                     isMe: isMe,
//                     messageDate:
//                         mess.createdAt?.formatDateOnlyTime ??
//                         DateTime.now().formatDateOnlyTime,
//                   ),
//                 );
//               },
//             ),
//           ),
//           if (snapshot.data != null && snapshot.data!.socket != null)
//             SafeArea(
//               top: false,
//               bottom:
//                   snapshot.data != null &&
//                       snapshot.data!.socket != null &&
//                       snapshot.data!.socket!.footerState == ChatFooterState.chat
//                   ? false
//                   : true,
//               child: Builder(
//                 builder: (context) {
//                   switch (snapshot.data!.socket!.footerState) {
//                     case ChatFooterState.closedNeedRating:
//                       return ChatBottomAreaRatedWidgets(
//                         webSocketApp: websocket,
//                         state: snapshot.data!,
//                       );

//                     case ChatFooterState.closedRated:
//                       return ChatBottomAreaClosedAndRatedWidgets(
//                         webSocketApp: websocket,
//                         state: snapshot.data!,
//                       );

//                     case ChatFooterState.ticketActive:
//                       return ChatBottomAreaTicketWidgets(
//                         webSocketApp: websocket,
//                         state: snapshot.data!,
//                       );
//                     case ChatFooterState.chat:
//                       return const SizedBox.shrink();
//                   }
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
