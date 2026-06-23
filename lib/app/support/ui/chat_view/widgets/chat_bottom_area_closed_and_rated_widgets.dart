import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/app/support/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/chat_websocket_state.dart';

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
    hideReopenButton = DateTime.now().difference(createdAt).inDays >= 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          color: Colors.white,
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
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 20.w,
                  ),
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
                            'Вопрос не решён',
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
