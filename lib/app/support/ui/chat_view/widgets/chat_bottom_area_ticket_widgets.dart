import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/app/support/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/chat_websocket_state.dart';

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
          color: Colors.white,
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
                    color: Color.fromARGB(255, 74, 74, 74),
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
                color: Color.fromARGB(255, 74, 74, 74),
                height: 1.h,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            InkWell(
              onTap: () {
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
              child: Container(
                height: 43.h,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  color: Color.fromARGB(255, 231, 231, 231),
                ),
                child: Center(
                  child: isLoadingReopen
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: CircularProgressIndicator(
                            strokeAlign: 0.8,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          'Мне нужно уточнить детали',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
