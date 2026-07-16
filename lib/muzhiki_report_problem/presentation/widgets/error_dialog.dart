import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/muzhiki_config/colors/core_colors.dart';
import 'package:muzhiki_core/muzhiki_config/fonts/core_fonts.dart';

import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/button.dart';


class ErrorDialog extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback? onRetry;

  const ErrorDialog({
    super.key,
    this.title = 'Не удалось отправить заявку',
    this.description,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 21.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            height: 1.3,
            fontWeight: CoreFonts.semiBold,
            color: CoreColors.black23,
          ),
        ),
        if (description != null) ...[
          SizedBox(height: 12.h),
          Text(
            description!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              height: 1.3,
              fontWeight: CoreFonts.medium,
              color: CoreColors.alertTextGrey,
            ),
          ),
        ],
        SizedBox(height: 27.h),
        if (onRetry != null) ...[
          AppButton(
            mode: ButtonMode.classic,
            label: 'Повторить',
            backgroundColor: CoreColors.black23,
            labelColor: CoreColors.white,
            borderRadius: 23,
            onPressed: () {
              context.pop();
              onRetry!.call();
            },
          ),
          SizedBox(height: 10.h),
        ],
        AppButton(
          mode: ButtonMode.classic,
          label: 'Понятно',
          backgroundColor: CoreColors.light,
          labelColor: CoreColors.black23,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
