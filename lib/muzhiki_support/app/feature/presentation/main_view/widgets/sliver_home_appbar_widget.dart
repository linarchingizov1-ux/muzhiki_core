import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          title: SliverPersistentHeader(
            floating: true,
            delegate: _HomeAppBarDelegate(canPop: canPop, chatCubit: chatCubit),
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

class _HomeAppBarDelegate extends SliverPersistentHeaderDelegate {
  final bool canPop;
  final ChatCubit chatCubit;

  static const double _height = 56;

  _HomeAppBarDelegate({required this.canPop, required this.chatCubit});

  @override
  double get minExtent => _height.h;

  @override
  double get maxExtent => _height.h;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / _height.h).clamp(0.0, 1.0);

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildTitle(opacity: progress),

          _buildChoi(opacity: 1.0 - progress),
        ],
      ),
    );
  }

  Widget _buildTitle({required double opacity}) {
    return IgnorePointer(
      ignoring: opacity < 0.5,
      child: Opacity(
        opacity: opacity,
        child: Row(
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
                  onTap: () {},
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
        ),
      ),
    );
  }

  Widget _buildChoi({required double opacity}) {
    return IgnorePointer(
      ignoring: opacity < 0.5,
      child: Opacity(
        opacity: opacity,
        child: BlocProvider.value(
          value: chatCubit,
          child: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              if (state.chatStatus != StateStatus.success) {
                return const SizedBox.shrink();
              }

              final channels = state.myChat?.channels ?? [];

              return Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 40.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 17.w),
                    separatorBuilder: (_, _) => SizedBox(width: 5.w),
                    itemCount: channels.length,
                    itemBuilder: (context, i) {
                      final channel = channels[i];

                      return ChoiceWidgets(
                        newMessage: state.myChat!.chats.unreadByChannel(
                          channel.id,
                        ),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _HomeAppBarDelegate oldDelegate) {
    return oldDelegate.canPop != canPop || oldDelegate.chatCubit != chatCubit;
  }
}
