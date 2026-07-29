import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/extension/chat_extension.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/state/chat/chat_cubit.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/appbar_main/appbar_main.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/choice.dart';
import 'package:muzhiki_core/muzhiki_ui/muzhiki_ui.dart';

class SliverHomeAppbarWidget extends StatelessWidget {
  final TypeApp typeApp;
  final SessionApp? sessionApp;
  final ChatCubit chatCubit;
  final bool showChoi;
  final bool canPop;
  final Function()? firebaseRemoveFCM;
  const SliverHomeAppbarWidget({
    super.key,
    required this.canPop,
    required this.showChoi,
    required this.chatCubit,
    required this.typeApp,
    this.sessionApp,
    this.firebaseRemoveFCM,
  });

  @override
  Widget build(BuildContext context) {
    if (typeApp == TypeApp.support && sessionApp != null) {
      return SliverAppBar(
        centerTitle: false,
        pinned: true,
        automaticallyImplyLeading: false,

        title: SupportAppBar(
          sessionApp: sessionApp!,
          firebaseRemoveFCM: firebaseRemoveFCM,
        ),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(bottom: 5.h),
        sliver: SliverAppBar(
          centerTitle: false,
          pinned: false,
          floating: true,
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: showChoi
                ? AppBarChoi(chatCubit: chatCubit)
                : AppBarTitle(canPop: canPop),
          ),
          automaticallyImplyLeading: false,
          leading: null,
          leadingWidth: 40.w,
          titleSpacing: canPop ? 0 : 25.w,
        ),
      );
    }
  }
}

class AppBarTitle extends StatelessWidget {
  final bool canPop;
  const AppBarTitle({super.key, required this.canPop});

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const ValueKey('title'),
      spacing: 10.w,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canPop)
          Padding(
            padding: EdgeInsets.only(left: 17.w),
            child: MuzhikiUi.buttons.circle(
              size: 40,
              iconSize: 16,
              backgroundColor: SupportColors.alertTextGrey,
              onTap: context.pop,
              icon: Icons.arrow_back_ios_new,
            ),
          ),
        Text(
          'Мои чаты',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class AppBarChoi extends StatelessWidget {
  final ChatCubit chatCubit;
  const AppBarChoi({super.key, required this.chatCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: chatCubit,
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state.chatStatus != StateStatus.success) {
            return const SizedBox.shrink();
          }

          final channels = state.myChat?.channels ?? [];

          return SizedBox(
            key: const ValueKey('choi'),
            height: 40.h,
            width: MediaQuery.sizeOf(context).width,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 17.w),
              separatorBuilder: (_, _) => SizedBox(width: 5.w),
              itemCount: channels.length,
              itemBuilder: (context, i) {
                final channel = channels[i];

                return ChoiceWidgets(
                  newMessage: state.myChat!.chats.unreadByChannel(channel.id),
                  onSelected: (_) {
                    context.read<ChatCubit>().selecteChannel(
                      index: i,
                      channelId: channel.id,
                    );
                  },
                  isSelected: i == state.selectedChannels,
                  label: channel.name,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
