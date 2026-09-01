import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_settings/widgets/settings_error_dialog.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

class NotificationNumberDialog extends StatefulWidget {
  final String title;
  final num? value;
  final bool isRequired;
  final String errorTitle;
  final String? Function()? errorDescription;
  final Future<bool> Function(num? value) onSubmit;

  const NotificationNumberDialog({
    super.key,
    required this.title,
    required this.onSubmit,
    required this.errorTitle,
    this.errorDescription,
    this.value,
    this.isRequired = false,
  });

  @override
  State<NotificationNumberDialog> createState() =>
      _NotificationNumberDialogState();
}

class _NotificationNumberDialogState extends State<NotificationNumberDialog> {
  bool isSaving = false;
  bool isFieldEmpty = false;
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value?.toString() ?? '');
    isFieldEmpty = controller.text.isEmpty;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final text = controller.text;
    final value = num.tryParse(text);
    if (isSaving) return;

    if (text.isEmpty && widget.isRequired) return;
    if (text.isNotEmpty && value == null) return;

    setState(() => isSaving = true);

    final isSuccess = await widget.onSubmit(text.isEmpty ? null : value);

    if (!mounted) return;
    if (isSuccess) {
      context.pop();
      return;
    }

    setState(() => isSaving = false);

    final error = widget.errorDescription?.call();
    if (error == null) return;

    await MuzhikiUi.dialog.standart<void>(
      child: SettingsErrorDialog(
        title: widget.errorTitle,
        description: error,
        onRetry: submit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          spacing: 20.h,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: MuzhikiFonts.manropeStyle(
                fontSize: 18.sp,
                color: MuzhikiColors.black23,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: MuzhikiColors.appBackgroud,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: TextField(
                controller: controller,
                enabled: !isSaving,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final isEmpty = value.isEmpty;
                  if (isEmpty == isFieldEmpty) return;

                  setState(() => isFieldEmpty = isEmpty);
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  errorText: widget.isRequired && isFieldEmpty
                      ? 'Поле обязательно для заполнения'
                      : null,
                  errorStyle: MuzhikiFonts.manropeStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: MuzhikiColors.blood,
                  ),
                ),
                cursorColor: MuzhikiColors.alertTextGrey,
                onSubmitted: (_) => submit(),
                style: MuzhikiFonts.manropeStyle(
                  fontSize: 15.sp,
                  color: MuzhikiColors.black23,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            MuzhikiUi.buttons.primary(
              label: 'Готово',
              disabled: widget.isRequired && isFieldEmpty,
              isLoading: isSaving,
              onPressed: submit,
            ),
          ],
        ),
      ),
    );
  }
}
