// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ChatMessageBubble extends StatefulWidget {
//   final AppWebsocketChat websocketChat;
//   final MessageModel mess;
//   final bool isMe;
//   final String messageDate;
//   final FocusNode? fucusNode;
//   final String? avatar;
//   final List<AttachmentsModel>? attachments;

//   const ChatMessageBubble({
//     required this.websocketChat,
//     this.avatar,
//     super.key,
//     required this.mess,
//     this.fucusNode,
//     this.attachments,
//     required this.isMe,
//     required this.messageDate,
//   });

//   @override
//   State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
// }

// class _ChatMessageBubbleState extends State<ChatMessageBubble> {
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constrained) {
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisAlignment: widget.isMe
//               ? MainAxisAlignment.end
//               : MainAxisAlignment.start,
//           children: [
//             Container(
//               constraints: BoxConstraints(
//                 maxWidth: constrained.maxWidth * 0.75,
//               ),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12.r),
//                 color: widget.isMe ? AppColors.light : AppColors.white,
//               ),
//               child: IntrinsicWidth(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: 11.w,
//                         right: 11.w,
//                         top: 5.h,
//                         bottom: 5.h,
//                       ),
//                       child: Text(
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         widget.isMe ? 'Вы' : (widget.mess.name ?? ''),
//                         style: TextStyle(
//                           height: 1.h,
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.blood,
//                         ).copyWith(fontFamily: 'Inter'),
//                       ),
//                     ),
//                     if (widget.mess.text.isNotEmpty)
//                       Padding(
//                         padding: EdgeInsets.only(
//                           left: 11.w,
//                           right: 11.w,
//                           bottom: 5.h,
//                         ),
//                         child: _MessageWidgetState(text: widget.mess.text),
//                       ),
//                     if (widget.attachments != null &&
//                         widget.attachments!.isNotEmpty)
//                       _BubbleAttachment(
//                         websocketChat: widget.websocketChat,
//                         attachments: widget.attachments!,
//                         width: constrained.maxWidth,
//                       ),
//                     if (widget.messageDate.isNotEmpty)
//                       Padding(
//                         padding: EdgeInsets.only(left: 11.w, right: 11.w),
//                         child: Align(
//                           alignment: Alignment.bottomRight,
//                           child: Text(
//                             widget.messageDate,
//                             style: TextStyle(
//                               height: 2.h,
//                               color: AppColors.grey,
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _MessageWidgetState extends StatefulWidget {
//   final String text;
//   const _MessageWidgetState({required this.text});

//   @override
//   State<_MessageWidgetState> createState() => __MessageWidgetStateState();
// }

// class __MessageWidgetStateState extends State<_MessageWidgetState> {
//   final List<TapGestureRecognizer> _recognizers = [];

//   @override
//   void dispose() {
//     for (final r in _recognizers) {
//       r.dispose();
//     }
//     _recognizers.clear();
//     super.dispose();
//   }

//   Widget buildMessage(String text) {
//     final urlRegExp = RegExp(r'(https?:\/\/[^\s]+)');

//     final spans = <TextSpan>[];

//     text.splitMapJoin(
//       urlRegExp,
//       onMatch: (m) {
//         final url = m.group(0)!;

//         spans.add(
//           TextSpan(
//             text: url,
//             style: const TextStyle(
//               color: Colors.blue,
//               decoration: TextDecoration.underline,
//             ),
//             recognizer: TapGestureRecognizer()
//               ..onTap = () {
//                 launchUrl(Uri.parse(url));
//               },
//           ),
//         );

//         return '';
//       },
//       onNonMatch: (t) {
//         spans.add(
//           TextSpan(
//             text: t,
//             style: const TextStyle(fontSize: 12, color: Colors.black),
//           ),
//         );

//         return '';
//       },
//     );

//     return SelectableText.rich(TextSpan(children: spans));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return buildMessage(widget.text);
//   }
// }

// class _BubbleAttachment extends StatelessWidget {
//   final List<AttachmentsModel> attachments;
//   final AppWebsocketChat websocketChat;
//   final double width;
//   const _BubbleAttachment({
//     required this.attachments,
//     required this.width,
//     required this.websocketChat,
//   });

//   int get count => attachments.length;

//   @override
//   Widget build(BuildContext context) {
//     switch (count) {
//       case 1:
//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: 11.w),
//           child: ChatAttachment(
//             attachment: attachments.first,
//             websocketChat: websocketChat,
//           ),
//         );
//       default:
//         return ConstrainedBox(
//           constraints: BoxConstraints(maxWidth: width * 0.75, maxHeight: 77.w),
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 11.w),
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               spacing: 5.w,
//               children: List.generate(attachments.length, (index) {
//                 return SizedBox(
//                   width: 77.w,
//                   height: 77.w,
//                   child: ChatAttachment(
//                     attachment: attachments[index],
//                     websocketChat: websocketChat,
//                   ),
//                 );
//               }),
//             ),
//           ),
//         );
//     }
//   }
// }
