import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_settings/config/settings_colors.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

class SettingsErrorDialog extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback onRetry;

  const SettingsErrorDialog({
    super.key,
    required this.title,
    required this.onRetry,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: SettingsColors.black23,
          ),
        ),
        if (description != null) ...[
          SizedBox(height: 15.h),
          Text(
            description!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: SettingsColors.black23,
            ),
          ),
        ],
        SizedBox(height: 30.h),
        MuzhikiUi.buttons.primary(
          label: 'Повторить',
          backgroundColor: SettingsColors.black23,
          labelColor: SettingsColors.white,
          onPressed: () {
            context.pop();
            onRetry();
          },
        ),
        SizedBox(height: 10.h),
        MuzhikiUi.buttons.primary(
          label: 'Понятно',
          backgroundColor: SettingsColors.light,
          labelColor: SettingsColors.black23,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
