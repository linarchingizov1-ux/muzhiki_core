import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

class FirebasePushDialog extends StatefulWidget {
  const FirebasePushDialog({
    super.key,
    required this.onAccept,
    required this.onDeleteAccountInfo,
  });

  final Future<void> Function() onAccept;
  final VoidCallback onDeleteAccountInfo;

  @override
  State<FirebasePushDialog> createState() => _FirebasePushDialogState();
}

class _FirebasePushDialogState extends State<FirebasePushDialog> {
  bool _isLoading = false;

  Future<void> _onAccept() async {
    setState(() => _isLoading = true);
    try {
      await widget.onAccept();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Отправка уведомлений',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: MuzhikiColors.black23,
                ),
              ),
              SizedBox(height: 7.h),
              Text(
                'Будем уведомлять о полезных событиях. Позже вы сможете настроить уведомления только для тех событий, которые вам интересны.\n\n'
                'Для доставки уведомлений мы используем ваш идентификатор устройства. Это необходимо для точного уведомления вас о событиях при использовании наших сервисов.',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: MuzhikiColors.black23,
                ),
              ),
              SizedBox(height: 25.h),
              MuzhikiUi.buttons.dark(
                isLoading: _isLoading,
                onPressed: _onAccept,
                label: 'Хорошо',
              ),
            ],
          );
  }
}
