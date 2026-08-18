import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_settings/notification/domain/model/notification_parameter_option.dart';
import 'package:muzhiki_settings/widgets/action_card.dart';
import 'package:muzhiki_settings/widgets/settings_error_dialog.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

class NotificationOptionsDialog extends StatefulWidget {
  final String title;
  final String errorTitle;
  final String? Function() errorDescription;
  final List<NotificationParameterOption> options;
  final List<Object> selected;
  final bool isRequired;
  final bool isMultiple;
  final Future<bool> Function(NotificationParameterOption? option)? onSelect;
  final Future<bool> Function(List<NotificationParameterOption> options)?
  onSubmit;

  const NotificationOptionsDialog.single({
    super.key,
    required this.title,
    required this.errorTitle,
    required this.errorDescription,
    required this.options,
    required this.selected,
    required this.onSelect,
    this.isRequired = false,
  }) : isMultiple = false,
       onSubmit = null;

  const NotificationOptionsDialog.multiple({
    super.key,
    required this.title,
    required this.errorTitle,
    required this.errorDescription,
    required this.options,
    required this.selected,
    required this.onSubmit,
    this.isRequired = false,
  }) : isMultiple = true,
       onSelect = null;

  @override
  State<NotificationOptionsDialog> createState() =>
      _NotificationOptionsDialogState();
}

class _NotificationOptionsDialogState extends State<NotificationOptionsDialog> {
  bool isSaving = false;
  late final List<String> selected;
  late final List<String> initialSelected;
  late final List<NotificationParameterOption> options;
  late final bool isEmptyOptions;

  Future<void> submit(List<NotificationParameterOption> picked) async {
    if (isSaving) return;
    if (selected.length == initialSelected.length &&
        initialSelected.every(selected.contains)) {
      context.pop();
      return;
    }

    setState(() => isSaving = true);

    final isSuccess = widget.isMultiple
        ? await widget.onSubmit!(picked)
        : await widget.onSelect!(picked.firstOrNull);

    if (!mounted) return;
    if (isSuccess) {
      context.pop();
      return;
    }

    setState(() => isSaving = false);

    final error = widget.errorDescription.call();
    if (error == null) return;

    await MuzhikiUi.dialog.standart<void>(
      child: SettingsErrorDialog(
        title: widget.errorTitle,
        description: error,
        onRetry: () => submit(picked),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selected = widget.selected.map((value) => '$value').toList();
    initialSelected = List<String>.from(selected);
    options = [
      ...widget.options.where((option) => selected.contains('${option.value}')),
      ...widget.options.where(
        (option) => !selected.contains('${option.value}'),
      ),
    ];
    isEmptyOptions = options.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 300.h,
        maxHeight: MediaQuery.sizeOf(context).height / 2,
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: widget.isMultiple || isEmptyOptions ? 72.h : 0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10.w,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: MuzhikiFonts.manropeStyle(
                          fontSize: 18.sp,
                          color: MuzhikiColors.black23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isSaving && !widget.isMultiple)
                      SizedBox(
                        width: 18.w,
                        height: 18.h,
                        child: const CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 14.h),
                if (isEmptyOptions)
                  Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: Center(
                      child: Text(
                        'Список пустой',
                        textAlign: TextAlign.center,
                        style: MuzhikiFonts.manropeStyle(
                          fontSize: 15.sp,
                          color: MuzhikiColors.alertTextGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                else
                  ...List.generate(options.length, (index) {
                    final option = options[index];
                    final optionValue = '${option.value}';

                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: ActionCard(
                        title: option.label,
                        description: option.description,
                        leading: option.imageUrl == null
                            ? null
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(60.r),
                                child: CachedNetworkImage(
                                  imageUrl: option.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, _, _) => Container(
                                    alignment: Alignment.center,
                                    color: MuzhikiColors.white,
                                    child: Text(
                                      option.label.characters.firstOrNull ?? '',
                                      style: MuzhikiFonts.manropeStyle(
                                        fontSize: 16.sp,
                                        color: MuzhikiColors.alertTextGrey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        backgroundColor: MuzhikiColors.appBackgroud,
                        isCheckSelection: true,
                        isSelected: selected.contains(optionValue),
                        enabled: !isSaving,
                        onTap: isSaving
                            ? null
                            : () {
                                if (!widget.isMultiple) {
                                  final isAlreadySelected = selected.contains(
                                    optionValue,
                                  );
                                  if (isAlreadySelected && widget.isRequired) {
                                    return;
                                  }

                                  selected.clear();
                                  if (!isAlreadySelected) {
                                    selected.add(optionValue);
                                  }
                                  submit(
                                    isAlreadySelected ? const [] : [option],
                                  );
                                  return;
                                }

                                setState(() {
                                  if (!selected.remove(optionValue)) {
                                    selected.add(optionValue);
                                  }
                                });
                              },
                      ),
                    );
                  }),
              ],
            ),
          ),
          if (widget.isMultiple || isEmptyOptions)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(top: 24.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, 0.5, 1],
                    colors: [
                      MuzhikiColors.white.withValues(alpha: 0),
                      MuzhikiColors.white,
                      MuzhikiColors.white,
                    ],
                  ),
                ),
                child: MuzhikiUi.buttons.primary(
                  label: isEmptyOptions ? 'Назад' : 'Готово',
                  isLoading: isSaving,
                  disabled: !isEmptyOptions && widget.isRequired && selected.isEmpty,
                  onPressed: isEmptyOptions
                      ? () => context.pop()
                      : () => submit(
                          options
                              .where(
                                (option) =>
                                    selected.contains('${option.value}'),
                              )
                              .toList(),
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
