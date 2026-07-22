import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/chat_websocket_state.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/button.dart';

class ChatBottomAreaClosedAndRatedWidgets extends StatefulWidget {
  final WebSocketChat webSocketApp;
  final WebSocketChatState state;
  const ChatBottomAreaClosedAndRatedWidgets({
    super.key,
    required this.webSocketApp,
    required this.state,
  });

  @override
  State<ChatBottomAreaClosedAndRatedWidgets> createState() =>
      _ChatBottomAreaClosedAndRatedWidgetsState();
}

class _ChatBottomAreaClosedAndRatedWidgetsState
    extends State<ChatBottomAreaClosedAndRatedWidgets> {
  bool isLoadingReopen = false;
  late DateTime createdAt;
  late bool hideReopenButton;

  @override
  void initState() {
    super.initState();
    final createdAt = widget.state.socket!.createdAt;
    if (createdAt != null) {
      hideReopenButton = DateTime.now().difference(createdAt).inDays >= 1;
    } else {
      hideReopenButton = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: Platform.isIOS ? false : true,
      child: Padding(
        padding: EdgeInsets.only(left: 17.w, right: 17.h, bottom: 10.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: SupportColors.white,
          ),
          child: Column(
            spacing: 24.h,
            crossAxisAlignment: !hideReopenButton
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Text(
                'Обращение закрыто',
                style: TextStyle(
                  height: 1.h,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!hideReopenButton)
                AppButton(
                  height: 43,
                  isLoading: isLoadingReopen,
                  backgroundColor: SupportColors.light,
                  progressColor: SupportColors.black17,
                  labelColor: SupportColors.black17,
                  mode: ButtonMode.rounded,
                  onPressed: () {
                    setState(() {
                      isLoadingReopen = true;
                    });
                    widget.webSocketApp
                        .reopenWebChat(sessionId: widget.state.socket!.id)
                        .then((_) {
                          setState(() {
                            isLoadingReopen = false;
                          });
                        });
                  },
                  label: 'Вопрос не решён',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
