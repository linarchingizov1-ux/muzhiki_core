import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/app_colors.dart';
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
          color: AppColors.white,
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
                backgroundColor: AppColors.light,
                progressColor: AppColors.black17,
                labelColor: AppColors.black17,
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
    );
  }
}
