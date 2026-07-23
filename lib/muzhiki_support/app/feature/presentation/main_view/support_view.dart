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
    // Получаем уникальный ID текущего экземпляра виджета
    final widgetId = identityHashCode(this);

    print("[LOG_CHAT] >>> loadChats() запущен в виджете ID: $widgetId");
    print(
      "[LOG_CHAT] Текущий action: ${widget.action.runtimeType}, mounted: $mounted",
    );

    try {
      print("[LOG_CHAT] Начинаем загрузку getMyChats()...");
      await widget.chatCubit.getMyChats();
      print("[LOG_CHAT] getMyChats() успешно завершен. mounted: $mounted");
    } catch (e, stack) {
      print("[LOG_CHAT] Ошибка в getMyChats(): $e\n$stack");
    }

    if (!mounted) {
      print(
        "[LOG_CHAT] !!! Виджет ID $widgetId уже размонтирован (not mounted). Прерываем навигацию.",
      );
      return;
    }

    print("[LOG_CHAT] Обработка action: ${widget.action.runtimeType}");
    switch (widget.action) {
      case SupportNone():
        print("[LOG_CHAT] Экшен: SupportNone. Ничего не делаем.");
        break;

      case SupportOpenChat(:final sessionId):
        print("[LOG_CHAT] Навигация в Chat. ID сессии: $sessionId");
        context.pushNamed(
          SupportRouteConstant.I.chat,
          pathParameters: {'id': sessionId},
        );
        break;

      case SupportCreateSession(:final supportChatsEventWidgets):
        print("[LOG_CHAT] Навигация в ChatDraft (создание сессии)");
        context.pushNamed(
          extra: supportChatsEventWidgets,
          SupportRouteConstant.I.chatDraft,
        );
        break;

      case SupportOpenInformator(:final initalURL):
        print("[LOG_CHAT] НАВИГАЦИЯ В INFORMATOR! URL: $initalURL");
        context.pushNamed(
          SupportRouteConstant.I.informator,
          queryParameters: {"initialUrl": initalURL},
        );
        break;
    }
    print("[LOG_CHAT] <<< loadChats() завершил работу в виджете ID: $widgetId");
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
                    onTap: () =>
                        context.pushNamed(SupportRouteConstant.I.chatDraft),
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
