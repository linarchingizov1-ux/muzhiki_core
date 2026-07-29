import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/extension/chat_extension.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/state/chat/chat_cubit.dart';
import 'package:muzhiki_core/muzhiki_ui/muzhiki_ui.dart';
import 'package:shimmer/shimmer.dart';

class SliverChoiWidget extends StatelessWidget {
  final ChatCubit chatCubit;
  const SliverChoiWidget({super.key, required this.chatCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: chatCubit,
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          switch (state.chatStatus) {
            case StateStatus.loading:
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 40.h,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 5.w),
                      itemCount: 2,
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      itemBuilder: (context, i) {
                        return Container(
                          width: 80.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(21.h),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );

            case StateStatus.fail:
              return SliverToBoxAdapter();
            case StateStatus.success:
              return SliverAppBar(
                toolbarHeight: 40.h,
                collapsedHeight: 40.h,
                expandedHeight: 40.h,
                automaticallyImplyLeading: false,
                primary: false,
                forceMaterialTransparency: true,
                pinned: false,
                floating: true,
                stretch: false,
                elevation: 0,
                scrolledUnderElevation: 0,

                titleSpacing: 0,

                title: SizedBox(
                  height: 40.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 17.w),
                    separatorBuilder: (_, _) => SizedBox(width: 5.w),
                    itemCount: state.myChat!.channels.length,
                    itemBuilder: (context, i) {
                      final channel = state.myChat!.channels[i];

                      return MuzhikiUi.buttons.choi(
                        newMessage: state.myChat!.chats.unreadByChannel(
                          channel.id,
                        ),
                        onSelected: (v) {
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
            case StateStatus.userNotFound:
              return SliverToBoxAdapter();
            case StateStatus.isFakeUser:
              return SliverToBoxAdapter();
          }
        },
      ),
    );
  }
}
