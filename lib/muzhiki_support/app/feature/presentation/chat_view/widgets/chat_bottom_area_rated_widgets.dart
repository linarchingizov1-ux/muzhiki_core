import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_assets.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/chat_websocket_state.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/button.dart';

class ChatBottomAreaRatedWidgets extends StatefulWidget {
  final WebSocketChat webSocketApp;
  final WebSocketChatState state;
  const ChatBottomAreaRatedWidgets({
    super.key,
    required this.webSocketApp,
    required this.state,
  });

  @override
  State<ChatBottomAreaRatedWidgets> createState() =>
      _ChatBottomAreaRatedWidgetsState();
}

class _ChatBottomAreaRatedWidgetsState
    extends State<ChatBottomAreaRatedWidgets> {
  int selectedStar = 0;
  bool isLoadingReview = false;
  bool isLoadingReopen = false;
  bool hideReopenButton = false;

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
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: SupportColors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Обращение закрыто',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
              Text(
                'Оцените работу оператора',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: SupportColors.alertTextGrey,
                ),
              ),

              SizedBox(height: 12.h),

              Row(
                children: List.generate(5, (index) {
                  final isSelected = index < selectedStar;

                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        if (context.mounted) {
                          setState(() {
                            selectedStar = index + 1;
                          });
                        }
                      },
                      child: Padding(
                        key: ValueKey('$index and $selectedStar'),
                        padding: EdgeInsets.all(6.r),
                        child: SizedBox(
                          height: 40.r,
                          width: 40.r,
                          child: Center(
                            child: Image.asset(
                              isSelected
                                  ? SupportAssets.I.png.starEnable
                                  : SupportAssets.I.png.starDisable,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: 16.h),

              if (selectedStar != 0)
                AppButton(
                      height: 43,
                      isLoading: isLoadingReview,
                      progressColor: SupportColors.white,
                      mode: ButtonMode.rounded,
                      onPressed: () {
                        if (selectedStar == 0 && widget.state.socket == null) {
                          return;
                        }

                        if (context.mounted) {
                          setState(() {
                            isLoadingReview = true;
                          });
                        }

                        widget.webSocketApp
                            .reviewChat(
                              sessionId: widget.state.socket!.id,
                              score: selectedStar,
                            )
                            .then((_) {
                              if (context.mounted) {
                                setState(() {
                                  isLoadingReview = false;
                                });
                              }
                            });
                      },
                      label: 'Оценить',
                    )
                    .animate()
                    .fadeIn(duration: 220.ms)
                    .scaleXY(
                      begin: 0.98,
                      end: 1,
                      curve: Curves.easeOutBack,
                      duration: 320.ms,
                    )
                    .moveY(
                      begin: 5,
                      end: 0,
                      duration: 320.ms,
                      curve: Curves.easeOut,
                    ),
              if (!hideReopenButton)
                Padding(
                  padding: EdgeInsets.only(top: 9.h),
                  child: AppButton(
                    height: 48,
                    labelWeight: FontWeight.w700,
                    isLoading: isLoadingReopen,
                    backgroundColor: SupportColors.light,
                    progressColor: SupportColors.black17,
                    labelColor: SupportColors.alertTextGrey,
                    mode: ButtonMode.rounded,
                    onPressed: () {
                      if (selectedStar == 0 && widget.state.socket == null) {
                        return;
                      }

                      if (context.mounted) {
                        setState(() {
                          isLoadingReopen = true;
                        });
                      }
                      widget.webSocketApp
                          .reopenWebChat(sessionId: widget.state.socket!.id)
                          .then((_) {
                            if (context.mounted) {
                              setState(() {
                                isLoadingReopen = false;
                              });
                            }
                          });
                    },
                    label: 'Вопрос не решён',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
