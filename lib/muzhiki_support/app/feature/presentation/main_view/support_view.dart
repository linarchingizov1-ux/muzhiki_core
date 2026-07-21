import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/model/session_roles.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_assets.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_route_constant.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/support_route_event.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/main_view/widgets/sliver_chat_container_widget.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/main_view/widgets/sliver_choi_widget.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/main_view/widgets/sliver_home_appbar_widget.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/main_view/widgets/sliver_informator.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/state/chat/chat_cubit.dart';

class SupportView extends StatefulWidget {
  final String homeRoute, profileRoute;
  final ChatCubit chatCubit;
  final SessionApp? sessionApp;
  final void Function()? firebaseRemoveFCM;
  final bool showInformator;
  final SupportAction action;
  final TypeApp typeApp;
  const SupportView({
    super.key,
    required this.typeApp,
    this.sessionApp,
    required this.chatCubit,
    required this.firebaseRemoveFCM,
    required this.action,
    required this.homeRoute,
    this.showInformator = false,
    required this.profileRoute,
  });

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  SessionRole? role;

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  Future<void> loadChats() async {
    await widget.chatCubit.getMyChats();

    switch (widget.action) {
      case SupportNone():
        break;

      case SupportOpenChat(:final sessionId):
        if (mounted) {
          context.pushNamed(
            SupportRouteConstant.I.chat,
            pathParameters: {'id': sessionId},
          );
        }
        break;

      case SupportCreateSession(:final supportChatsEventWidgets):
        if (mounted) {
          context.pushNamed(
            extra: supportChatsEventWidgets,
            SupportRouteConstant.I.chat,
            pathParameters: {'id': AppWebsocketChat.draftSessionId.toString()},
          );
        }
        break;
      case SupportOpenInformator(:final initalURL):
        if (mounted) {
          context.pushNamed(
            SupportRouteConstant.I.informator,
            queryParameters: {"initialUrl": initalURL},
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: RefreshIndicator.noSpinner(
        onRefresh: () async => widget.chatCubit.getMyChats(),
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: BlocProvider.value(
            value: widget.chatCubit,
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state.chatStatus == StateStatus.success) {
                  return InkWell(
                    onTap: () => context.pushNamed(
                      SupportRouteConstant.I.chat,
                      pathParameters: {
                        'id': AppWebsocketChat.draftSessionId.toString(),
                      },
                    ),

                    child: Container(
                      height: 55.w,
                      width: 55.w,
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: SupportColors.blood,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          height: 15.w,
                          width: 15.w,
                          SupportAssets.I.svg.add,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverHomeAppbarWidget(
                typeApp: widget.typeApp,
                sessionApp: widget.sessionApp,
                firebaseRemoveFCM: widget.firebaseRemoveFCM,
              ),
              if (widget.showInformator) const SliverInformator(),
              SliverChoiWidget(chatCubit: widget.chatCubit),
              SliverChatContainerWidget(
                chatCubit: widget.chatCubit,
                homeRoute: widget.homeRoute,
                profileRoute: widget.profileRoute,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
