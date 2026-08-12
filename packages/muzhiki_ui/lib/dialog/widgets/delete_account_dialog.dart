import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key, required this.onOpenDetails});

  final VoidCallback onOpenDetails;

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  late final TapGestureRecognizer _detailsTap;

  @override
  void initState() {
    super.initState();
    _detailsTap = TapGestureRecognizer()..onTap = widget.onOpenDetails;
  }

  @override
  void dispose() {
    _detailsTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Удалить аккаунт?',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: MuzhikiColors.black23,
          ),
        ),
        SizedBox(height: 8.h),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: MuzhikiColors.black23,
              height: 1.4,
            ),
            children: [
              const TextSpan(
                text:
                    'Это действие необратимо. После подтверждения будут удалены ваши данные, связанные с этим аккаунтом. Более подробную информацию вы можете получить по ссылке ',
              ),
              TextSpan(
                text: '«Какие данные мы удаляем»',
                style: TextStyle(
                  color: MuzhikiColors.blood,
                  fontWeight: FontWeight.w800,
                ),
                recognizer: _detailsTap,
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        MuzhikiUi.buttons.primary(
          backgroundColor: MuzhikiColors.blood,
          labelColor: MuzhikiColors.white,
          label: 'Удалить аккаунт',
          onPressed: () => Navigator.pop(context, true),
        ),
        SizedBox(height: 10.h),
        MuzhikiUi.buttons.primary(
          backgroundColor: MuzhikiColors.light,
          labelColor: MuzhikiColors.black17,
          label: 'Отмена',
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
