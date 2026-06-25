// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mp_master_app/src/core/dependencies/app_dependencies.dart';
// import 'package:mp_master_app/src/core/utils/extension/support/chat_extension.dart';
// import 'package:mp_master_app/src/features/main/view_support/state/chat/chat_cubit.dart';
// import 'package:mp_master_app/src/features/widgets/interface/choice.dart';

// class SliverChoiWidget extends StatelessWidget {
//   const SliverChoiWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: getIt<ChatCubit>(),
//       child: BlocBuilder<ChatCubit, ChatState>(
//         builder: (context, state) {
//           switch (state.chatStatus) {
//             case StateStatus.loading:
//               return SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: 40.h,
//                   child: ListView.separated(
//                     scrollDirection: Axis.horizontal,
//                     separatorBuilder: (context, index) => SizedBox(width: 5.w),
//                     itemCount: 2,
//                     padding: EdgeInsets.symmetric(horizontal: 17.w),
//                     itemBuilder: (context, i) {
//                       return ChoiceWidgets(
//                         isLoading: true,
//                         newMessage: 0,
//                         onSelected: (v) {},
//                         isSelected: i == 0,
//                         label: 'Чат поддержки $i',
//                       );
//                     },
//                   ),
//                 ),
//               );
//             case StateStatus.fail:
//               return SliverToBoxAdapter();
//             case StateStatus.success:
//               return SliverAppBar(
//                 toolbarHeight: 40.h,
//                 collapsedHeight: 40.h,
//                 expandedHeight: 40.h,
//                 automaticallyImplyLeading: false,
//                 primary: false,
//                 forceMaterialTransparency: true,
//                 stretchTriggerOffset: 40.h,
//                 pinned: true,
//                 stretch: false,
//                 elevation: 0,
//                 scrolledUnderElevation: 0,
//                 title: SizedBox(
//                   height: 40.h,
//                   child:
//                       ListView.separated(
//                             scrollDirection: Axis.horizontal,
//                             separatorBuilder: (context, index) =>
//                                 SizedBox(width: 5.w),
//                             itemCount: state.myChat!.channels.length,
//                             padding: EdgeInsets.zero,
//                             itemBuilder: (context, i) {
//                               final channel = state.myChat!.channels[i];
//                               return ChoiceWidgets(
//                                 newMessage: state.myChat!.chats.unreadByChannel(
//                                   channel.id,
//                                 ),
//                                 onSelected: (v) =>
//                                     context.read<ChatCubit>().selecteChannel(
//                                       index: i,
//                                       channelId: channel.id,
//                                     ),
//                                 isSelected: i == state.selectedChannels,
//                                 label: channel.name,
//                               );
//                             },
//                           )
//                           .animate()
//                           .fadeIn(duration: 220.ms)
//                           .scaleXY(
//                             begin: 0.94,
//                             end: 1,
//                             curve: Curves.easeOutBack,
//                             duration: 320.ms,
//                           )
//                           .moveY(
//                             begin: 10,
//                             end: 0,
//                             duration: 320.ms,
//                             curve: Curves.easeOut,
//                           ),
//                 ),
//               );
//             case StateStatus.userNotFound:
//               return SliverToBoxAdapter();
//             case StateStatus.isFakeUser:
//               return SliverToBoxAdapter();
//           }
//         },
//       ),
//     );
//   }
// }
