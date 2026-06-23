// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:muzhiki_core/app/support/websocket/data/model/chat_websocket_state.dart';

// class ChatHeaderWidgets extends StatelessWidget {
//   final AsyncSnapshot<WebSocketChatState> snapshot;
//   final Object? chatViewExtra;
//   const ChatHeaderWidgets({
//     super.key,
//     required this.snapshot,
//     this.chatViewExtra,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (snapshot.data == null) {
//       return SizedBox.shrink();
//     }
//     return PopScope(
//       canPop: true,
//       onPopInvokedWithResult: (didPop, result) {
//         // if (didPop) {
//         //   if (chatViewExtra is OpenHomeMobileWidgetsChatEvent) {
//         //     getIt<BffCubit>().getMobileWidgets();
//         //   } else {
//         //     getIt<ChatCubit>().onPopScopeResultForChat();
//         //   }
//         // }
//       },
//       child: ClipRect(
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 2, sigmaY: 5),
//           child: Container(
//             padding: EdgeInsets.all(10.r),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(54.r),
//               color: const Color.fromARGB(100, 0, 0, 0),
//             ),
//             child: Row(
//               children: [
//                 AppButton(
//                   backgroundColor: AppColors.black1,
//                   assetIcon: AppAssetsSvg.arrowBack,
//                   width: 44,
//                   height: 44,
//                   mode: ButtonMode.circle,
//                   onPressed: () {
//                     context.pop(true);
//                   },
//                 ),

//                 SizedBox(width: 10.w),

//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (snapshot.data!.title != null)
//                         AppSkelet(
//                           enable:
//                               snapshot.connectionState !=
//                               ConnectionState.active,
//                           child: Text(
//                             snapshot.data!.title!,
//                             style: TextStyle(
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.white,
//                             ),
//                           ),
//                         ),

//                       if (snapshot.data!.createdAt != null)
//                         AppSkelet(
//                           enable:
//                               snapshot.connectionState !=
//                               ConnectionState.active,
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CircleWidgets(colors: snapshot.data!.statusColor),

//                               SizedBox(width: 5.w),

//                               Text(
//                                 snapshot.data!.stringStatus,
//                                 style: TextStyle(
//                                   fontSize: 12.sp,
//                                   fontWeight: FontWeight.w400,
//                                   color: AppColors.white,
//                                 ),
//                               ),

//                               SizedBox(width: 5.w),

//                               Text(
//                                 snapshot.data!.createdAt!,
//                                 style: TextStyle(
//                                   fontSize: 12.sp,
//                                   fontWeight: FontWeight.w400,
//                                   color: AppColors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
