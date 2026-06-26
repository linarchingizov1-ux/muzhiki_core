import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/chat_websocket_state.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/chat_websocket_app.dart';
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.w),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          color: SupportColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'По вашему обращению создана задача ',
              style: TextStyle(
                height: 1.h,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              widget.state.title ?? 'Нет название обращения',
              style: TextStyle(
                height: 1.h,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.state.socket != null &&
                widget.state.socket!.deadline != null)
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Text(
                  'Срок выполнения ${widget.state.socket!.deadline}',
                  style: TextStyle(
                    color: SupportColors.alertTextGrey,
                    height: 1.h,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            SizedBox(height: 20.h),
            Text(
              'После решения задачи вам придет уведомление',
              style: TextStyle(
                color: SupportColors.alertTextGrey,
                height: 1.h,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            AppButton(
              isLoading: isLoadingReopen,
              height: 43,
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
              label: 'Мне нужно уточнить детали',
            ),
          ],
        ),
      ),
    );
  }
}
