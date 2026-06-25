// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mp_master_app/src/core/config/color/app_colors.dart';
// import 'package:mp_master_app/src/core/config/constants/app_assets_constant.dart';
// import 'package:mp_master_app/src/core/config/constants/app_route_constant.dart';
// import 'package:mp_master_app/src/core/dependencies/app_dependencies.dart';
// import 'package:mp_master_app/src/core/dependencies/session_app.dart';
// import 'package:mp_master_app/src/data/model/navigation_event.dart';
// import 'package:mp_master_app/src/features/main/view_support/main_view/widgets/sliver_informator.dart';
// import 'package:mp_master_app/src/features/main/view_support/state/chat/chat_cubit.dart';
// import 'package:mp_master_app/src/features/main/view_support/main_view/widgets/sliver_chat_container_widget.dart';
// import 'package:mp_master_app/src/features/main/view_support/main_view/widgets/sliver_choi_widget.dart';
// import 'package:mp_master_app/src/features/main/view_support/main_view/widgets/sliver_home_appbar_widget.dart';
// import 'package:muzhiki_core/dependecies/service/session/model/session_roles.dart';

// class SupportView extends StatefulWidget {
//   final Object? extra;
//   const SupportView({super.key, this.extra});

//   @override
//   State<SupportView> createState() => _SupportViewState();
// }

// class _SupportViewState extends State<SupportView> {
//   late ChatCubit chatCubit;
//   SessionRole? role;

//   @override
//   void initState() {
//     super.initState();
//     chatCubit = getIt<ChatCubit>();
//     chatCubit.getMyChats().then((_) {
//       if (widget.extra is OpenSupportRecordsEvent) {
//         Future.delayed(const Duration(milliseconds: 350), () {
//           chatCubit.createSession(
//             action: (sessionId) {
//               if (mounted) {
//                 context.pushNamed(
//                   extra: widget.extra,
//                   AppRouteConstant.chat,
//                   pathParameters: {'id': sessionId.toString()},
//                 );
//               }
//             },
//           );
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion(
//       value: SystemUiOverlayStyle.dark,
//       child: RefreshIndicator.noSpinner(
//         onRefresh: () async => chatCubit.getMyChats(),
//         child: Scaffold(
//           floatingActionButtonLocation:
//               FloatingActionButtonLocation.miniEndFloat,
//           floatingActionButton: BlocProvider.value(
//             value: chatCubit,
//             child: BlocBuilder<ChatCubit, ChatState>(
//               builder: (context, state) {
//                 if (state.chatStatus == StateStatus.success) {
//                   return InkWell(
//                     onTap: () {
//                       chatCubit.createSession(
//                         action: (sessionId) {
//                           context.pushNamed(
//                             AppRouteConstant.chat,
//                             pathParameters: {'id': sessionId.toString()},
//                           );
//                         },
//                       );
//                     },
//                     child: Container(
//                       height: 55.w,
//                       width: 55.w,
//                       padding: EdgeInsets.all(12.r),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: AppColors.blood,
//                       ),
//                       child: Center(
//                         child: SvgPicture.asset(
//                           height: 15.w,
//                           width: 15.w,
//                           AppAssetsSvg.add,
//                         ),
//                       ),
//                     ),
//                   );
//                 } else {
//                   return const SizedBox.shrink();
//                 }
//               },
//             ),
//           ),
//           body: CustomScrollView(
//             slivers: [
//               const SliverHomeAppbarWidget(),
//               if (sessionApp.user != null &&
//                   sessionApp.user!.isAllowedAccessInformator)
//                 const SliverInformator(),
//               const SliverChoiWidget(),
//               const SliverChatContainerWidget(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
