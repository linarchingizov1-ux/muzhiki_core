import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/extension/color.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_route_constant.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/my_chat.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/extension/date_format.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/extension/status_extension.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/circle.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/notification.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/skelet.dart';

class ChatContainerWidgets extends StatelessWidget {
  final bool isLoading;
  final ChatModel chat;
  const ChatContainerWidgets({
    super.key,
    required this.isLoading,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return AppSkelet(
      enable: isLoading,
      child: InkWell(
        onTap: () => context.pushNamed(
          SupportRouteConstant.I.chat,
          pathParameters: {'id': chat.id.toString()},
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Row(
              spacing: 11.w,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    chat.title,
                    maxLines: 1,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      wordSpacing: 0,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                if (chat.unreadCount > 0)
                  NotificationWidgets(count: chat.unreadCount),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 5.w,
                children: [
                  CircleWidgets(colors: chat.statusColor.toColor),
                  Text(
                    chat.stringStatus,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      wordSpacing: 0,
                      letterSpacing: 0,
                    ),
                  ),
                  if (chat.createdAt != null)
                    Text(
                      chat.createdAt!.formatDate,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        wordSpacing: 0,
                        letterSpacing: 0,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
