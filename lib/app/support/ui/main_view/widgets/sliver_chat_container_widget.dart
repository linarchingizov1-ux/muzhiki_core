// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mp_master_app/src/core/config/color/app_colors.dart';
// import 'package:mp_master_app/src/core/config/constants/app_route_constant.dart';
// import 'package:mp_master_app/src/core/dependencies/app_dependencies.dart';
// import 'package:mp_master_app/src/data/model/support/my_chat.dart';
// import 'package:mp_master_app/src/features/main/view_support/state/chat/chat_cubit.dart';
// import 'package:mp_master_app/src/features/widgets/interface/app_support/chat_container.dart';
// import 'package:mp_master_app/src/features/widgets/interface/button.dart';
// import 'package:mp_master_app/src/features/widgets/interface/dialog/app_dialog.dart';

// class SliverChatContainerWidget extends StatelessWidget {
//   const SliverChatContainerWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: getIt<ChatCubit>(),
//       child: BlocConsumer<ChatCubit, ChatState>(
//         listenWhen: (previous, current) => previous.error != current.error,
//         listener: (context, state) {
//           if (state.error != null) {
//             Future.delayed(const Duration(milliseconds: 350), () {
//               if (context.mounted) {
//                 AppDialog.standart(
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.error_outline_rounded,
//                           size: 56,
//                           color: Colors.redAccent,
//                         ),
//                         const SizedBox(height: 16),
//                         const Text(
//                           'Сбой приложения',
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.w700,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 12),
//                         const Text(
//                           'Произошла непредвиденная ошибка.\n'
//                           'Мы уже работаем над её устранением.\n\n'
//                           'Попробуйте открыть приложение снова немного позже. Просим у вас прощения !',
//                           style: TextStyle(
//                             fontSize: 15,
//                             height: 1.5,
//                             color: Colors.black87,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 24),
//                         AppButton(
//                           mode: ButtonMode.black,
//                           onPressed: () {
//                             context.read<ChatCubit>().sendProblems(
//                               error: state.error,
//                             );
//                             Future.delayed(
//                               const Duration(milliseconds: 350),
//                               () {
//                                 if (context.mounted) {
//                                   context.goNamed(AppRouteConstant.home);
//                                 }
//                               },
//                             );
//                           },
//                           label: 'Отправить сообщение о сбое',
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }
//             });
//           }
//         },
//         builder: (context, state) {
//           return SliverPadding(
//             padding: EdgeInsetsGeometry.symmetric(
//               horizontal: 17.w,
//               vertical: 10.h,
//             ),
//             sliver: Builder(
//               builder: (context) {
//                 return switch (state.chatStatus) {
//                   StateStatus.loading => SliverList.separated(
//                     separatorBuilder: (context, index) =>
//                         Divider(height: 1.h, color: AppColors.light),
//                     itemCount: 5,
//                     itemBuilder: (context, index) {
//                       return ChatContainerWidgets(
//                         isLoading: true,
//                         chat: ChatModel(
//                           id: 1,
//                           chatId: 1,
//                           unreadCount: 0,
//                           title: 'title',
//                           status: 'status',
//                           statusColor: 'F000000',
//                           channelId: 2,
//                         ),
//                       );
//                     },
//                   ),
//                   StateStatus.success => SliverPadding(
//                     padding: EdgeInsetsGeometry.only(bottom: 20),
//                     sliver: SliverList.separated(
//                       separatorBuilder: (context, index) =>
//                           Divider(height: 1.h, color: AppColors.light),
//                       itemCount: state.chats.length,
//                       itemBuilder: (context, i) {
//                         final chat = state.chats[i];
//                         return ChatContainerWidgets(
//                           isLoading: false,
//                           chat: chat,
//                         );
//                       },
//                     ),
//                   ),
//                   StateStatus.fail => SliverToBoxAdapter(),
//                   StateStatus.userNotFound => SliverFillRemaining(
//                     child: Center(
//                       child: Text(
//                         'Пользователь не найден.\nОбратитесь в поддержку',
//                       ),
//                     ),
//                   ),
//                   StateStatus.isFakeUser => SliverFillRemaining(
//                     child: Center(
//                       child: Column(
//                         spacing: 10.h,
//                         children: [
//                           Text(
//                             'Подтвердите аккаунт, чтобы пользоваться сервисом.\nКак это сделать вы можете узнать у себя в профиле',
//                           ),
//                           AppButton(
//                             label: 'Мой аккаунт',
//                             mode: ButtonMode.classic,
//                             onPressed: () {
//                               context.pushNamed(AppRouteConstant.account);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 };
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
