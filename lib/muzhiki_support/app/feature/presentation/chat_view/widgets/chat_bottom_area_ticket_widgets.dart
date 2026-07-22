import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/chat_websocket_state.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/extension/date_format.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/button.dart';

class ChatBottomAreaTicketWidgets extends StatefulWidget {
  final WebSocketChat webSocketApp;
  final WebSocketChatState state;
  const ChatBottomAreaTicketWidgets({
    super.key,
    required this.webSocketApp,
    required this.state,
  });

  @override
  State<ChatBottomAreaTicketWidgets> createState() =>
      _ChatBottomAreaTicketWidgetsState();
}

class _ChatBottomAreaTicketWidgetsState
    extends State<ChatBottomAreaTicketWidgets> {
  bool isLoadingReopen = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: Platform.isIOS ? false : true,
      child: Padding(
        padding: EdgeInsets.only(left: 17.w, right: 17.h, bottom: 10.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: SupportColors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'По вашему обращению создана задача ',
                style: TextStyle(
                  color: SupportColors.alertTextGrey,
                  height: 1.h,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 28.h),
              Text(
                widget.state.title ?? 'Нет название обращения',
                style: TextStyle(
                  color: SupportColors.black17,
                  height: 1.h,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),

              if (widget.state.socket != null &&
                  widget.state.socket!.deadline != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 28.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 7.h,
                      horizontal: 10.w,
                    ),
                    decoration: BoxDecoration(
                      color: SupportColors.light,
                      borderRadius: BorderRadius.circular(42.r),
                    ),
                    child: Text.rich(
                      TextSpan(
                        text: "Дедлайн  ",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: SupportColors.alertTextGrey,
                        ),
                        children: [
                          TextSpan(
                            text: widget.state.socket!.deadline?.formatDate,
                            style: TextStyle(color: SupportColors.black17),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              Text(
                'После решения задачи вам придет уведомление',
                style: TextStyle(
                  color: SupportColors.alertTextGrey,
                  height: 1.h,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.h),
              AppButton(
                isLoading: isLoadingReopen,
                height: 48,
                backgroundColor: SupportColors.light,
                labelWeight: FontWeight.w700,
                progressColor: SupportColors.alertTextGrey,
                labelColor: SupportColors.alertTextGrey,
                mode: ButtonMode.rounded,
                onPressed: () async {
                  setState(() {
                    isLoadingReopen = true;
                  });

                  try {
                    final socketId = widget.state.socket?.id;
                    if (socketId == null) return;
                    await widget.webSocketApp.reopenWebChat(
                      sessionId: socketId,
                    );
                  } finally {
                    if (mounted) {
                      setState(() {
                        isLoadingReopen = false;
                      });
                    }
                  }
                },
                label: 'Мне нужно уточнить детали',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
