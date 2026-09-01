import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_entity.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_option_entity.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_type.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_subscription_entity.dart';
import 'package:muzhiki_settings/notification/presentation/extension/notification_subscription_extension.dart';
import 'package:muzhiki_settings/notification/presentation/state/notification_settings_view_model.dart';
import 'package:muzhiki_settings/notification/presentation/widgets/notification_number_dialog.dart';
import 'package:muzhiki_settings/notification/presentation/widgets/notification_options_dialog.dart';
import 'package:muzhiki_settings/widgets/action_card.dart';
import 'package:muzhiki_settings/widgets/settings_badge.dart';
import 'package:muzhiki_settings/widgets/settings_error_dialog.dart';
import 'package:muzhiki_settings/widgets/settings_switch.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';
import 'package:provider/provider.dart';

class NotificationSettingsDetailView extends StatefulWidget {
  final NotificationSettingsViewModel viewModel;
  final Widget? banner;

  const NotificationSettingsDetailView({
    super.key,
    required this.viewModel,
    this.banner,
  });

  @override
  State<NotificationSettingsDetailView> createState() =>
      _NotificationSettingsDetailViewState();
}

class _NotificationSettingsDetailViewState
    extends State<NotificationSettingsDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final subscription = widget.viewModel.state.selectedSubscription;
      if (subscription == null) return;

      widget.viewModel.preloadExternalOptions(subscription: subscription);
    });
  }

  String valueLabel(NotificationParameterEntity parameter) {
    final selected = parameter.selectedValues;
    final hasError = widget.viewModel.state.externalOptionsErrorsByType
        .containsKey(parameter.type);

    if (selected.isEmpty) {
      return hasError ? 'Не удалось загрузить' : 'Не настроено';
    }

    final isExternalType = parameter.type.isExternal;
    final availableOptions = isExternalType
        ? widget.viewModel.state.externalOptionsByType[parameter.type] ??
              const []
        : parameter.options;

    final labels = <String>[];
    for (final value in selected) {
      final matchedOption = availableOptions
          .where((option) => '${option.value}' == '$value')
          .firstOrNull;

      if (matchedOption != null) {
        labels.add(matchedOption.label);
      } else if (!isExternalType) {
        labels.add('$value');
      }
    }

    if (labels.isEmpty) {
      return hasError ? 'Не удалось загрузить' : 'Выбрано: ${selected.length}';
    }

    return labels.length == 1
        ? labels.first
        : '${labels.first} и ещё ${labels.length - 1}';
  }

  bool isParameterSupported(NotificationParameterEntity parameter) =>
      parameter.type.isFromServer ||
      widget.viewModel.externalOptionSources.containsKey(parameter.type);

  Future<void> pickChannels(NotificationSubscriptionEntity subscription) async {
    await MuzhikiUi.dialog.standart<void>(
      child: NotificationOptionsDialog.multiple(
        title: 'Каналы уведомления',
        errorTitle: 'Не удалось сохранить каналы',
        errorDescription: () => widget.viewModel.state.lastDetailSavingError,
        selected: subscription.channels ?? const [],
        emptyLabel: 'Список доступных каналов пуст',
        options: subscription.availableChannels
            .map(
              (channel) => NotificationParameterOptionEntity(
                value: channel.key,
                label: channel.name,
              ),
            )
            .toList(),
        onSubmit: (pickedOptions) => widget.viewModel.setChannels(
          subscription: subscription,
          channels: pickedOptions.map((option) => '${option.value}').toList(),
        ),
      ),
    );
  }

  Future<void> pickParameter(
    NotificationSubscriptionEntity subscription,
    NotificationParameterEntity parameter,
  ) async {
    if (parameter.type == NotificationParameterType.number) {
      await MuzhikiUi.dialog.standart<void>(
        child: NotificationNumberDialog(
          title: parameter.name,
          value: parameter.selectedValues.firstOrNull is num
              ? parameter.selectedValues.firstOrNull as num?
              : null,
          isRequired: parameter.required,
          onSubmit: (value) => widget.viewModel.setParameterValue(
            subscription: subscription,
            parameterKey: parameter.key,
            value: value,
          ),
          errorTitle: 'Не удалось сохранить настройки',
          errorDescription: () => widget.viewModel.state.lastDetailSavingError,
        ),
      );
      return;
    }

    final source = widget.viewModel.externalOptionSources[parameter.type];
    final isMultiple =
        source?.isMultiple ??
        parameter.type == NotificationParameterType.multiplyEnum;

    final options = await optionsOrShowError(
      subscription: subscription,
      parameter: parameter,
    );
    if (options == null || !mounted) return;

    final emptyLabel = switch (parameter.type) {
      NotificationParameterType.masters => 'Список доступных мастеров пуст',
      NotificationParameterType.companies => 'Список доступных салонов пуст',
      _ => 'Список доступных вариантов пуст',
    };

    await MuzhikiUi.dialog.standart<void>(
      child: isMultiple
          ? NotificationOptionsDialog.multiple(
              title: parameter.name,
              errorTitle: 'Не удалось сохранить настройки',
              errorDescription: () =>
                  widget.viewModel.state.lastDetailSavingError,
              isRequired: parameter.required,
              isInverted: parameter.isInverted,
              selected: parameter.selectedValues,
              options: options,
              emptyLabel: emptyLabel,
              onSubmit: (pickedOptions) => widget.viewModel.setParameterValue(
                subscription: subscription,
                parameterKey: parameter.key,
                value: pickedOptions.map((option) => option.value).toList(),
              ),
            )
          : NotificationOptionsDialog.single(
              title: parameter.name,
              errorTitle: 'Не удалось сохранить настройки',
              errorDescription: () =>
                  widget.viewModel.state.lastDetailSavingError,
              isRequired: parameter.required,
              isInverted: parameter.isInverted,
              selected: parameter.selectedValues,
              options: options,
              emptyLabel: emptyLabel,
              onSelect: (pickedOption) => widget.viewModel.setParameterValue(
                subscription: subscription,
                parameterKey: parameter.key,
                value: pickedOption?.value,
              ),
            ),
    );
  }

  Future<List<NotificationParameterOptionEntity>?> optionsOrShowError({
    required NotificationSubscriptionEntity subscription,
    required NotificationParameterEntity parameter,
  }) async {
    final source = widget.viewModel.externalOptionSources[parameter.type];
    if (source == null) return parameter.options;

    final loadedOptions =
        widget.viewModel.state.externalOptionsByType[parameter.type];
    if (loadedOptions != null) return loadedOptions;

    final options = await widget.viewModel.getExternalOptions(
      type: parameter.type,
      source: source,
    );

    if (!mounted || options != null) return options;

    await MuzhikiUi.dialog.standart<void>(
      child: SettingsErrorDialog(
        title: 'Не удалось загрузить список',
        description:
            widget.viewModel.state.externalOptionsErrorsByType[parameter
                .type] ??
            'Что-то пошло не так, попробуйте ещё раз',
        onRetry: () => pickParameter(subscription, parameter),
      ),
    );

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider.value(
        value: widget.viewModel,
        child: Consumer<NotificationSettingsViewModel>(
          builder: (context, viewModel, _) {
            final subscription = viewModel.state.selectedSubscription;
            return RefreshIndicator.adaptive(
              displacement: 120,
              color: MuzhikiColors.black23,
              strokeWidth: 0.5,
              onRefresh: () async {
                await widget.viewModel.getSubscriptions(isRefresh: true);
                if (!mounted) return;

                final subscription =
                    widget.viewModel.state.selectedSubscription;
                if (subscription == null) return;

                await widget.viewModel.preloadExternalOptions(
                  subscription: subscription,
                  isRefresh: true,
                );
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 19.w,
                        right: 19.w,
                        top: MediaQuery.paddingOf(context).top + 5,
                        bottom: 15.h,
                      ),
                      child: SizedBox(
                        height: 44.h,
                        width: double.infinity,
                        child: Row(
                          children: [
                            MuzhikiUi.buttons.animated(
                              size: 40,
                              iconSize: 16,
                              backgroundColor: MuzhikiColors.darkGrey,
                              onTap: context.pop,
                              icon: Icons.arrow_back_ios_new,
                            ),
                            SizedBox(width: 13.w),
                            Text(
                              'Настройка уведомлений',
                              style: MuzhikiFonts.manropeStyle(
                                height: 1.h,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: MuzhikiColors.black23,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.banner != null) widget.banner!,
                    Expanded(
                      child: subscription == null
                          ? Center(
                              child: Text(
                                'Ничего не найдено',
                                style: MuzhikiFonts.manropeStyle(
                                  fontSize: 16.sp,
                                  color: MuzhikiColors.black23,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: EdgeInsets.only(
                                top: 7.h,
                                bottom: 30.h,
                                left: 14.w,
                                right: 14.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subscription.name,
                                    style: MuzhikiFonts.manropeStyle(
                                      fontSize: 18.sp,
                                      height: 1,
                                      color: MuzhikiColors.black23,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (subscription.description != null) ...[
                                    SizedBox(height: 9.h),
                                    Text(
                                      subscription.description!,
                                      style: MuzhikiFonts.manropeStyle(
                                        fontSize: 15.sp,
                                        color: MuzhikiColors.alertTextGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: 22.h),
                                  ActionCard(
                                    title: subscription.isEnabled
                                        ? 'Уведомление включено'
                                        : 'Уведомление отключено',
                                    suffixIcon: SettingsSwitch(
                                      value: subscription.isEnabled,
                                      disableSwitchColor: MuzhikiColors.black23,
                                      enabled: subscription.isEditable,
                                      onTap: () =>
                                          widget.viewModel.toggleEnabled(
                                            subscription: subscription,
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Детальные настройки',
                                    style: MuzhikiFonts.manropeStyle(
                                      fontSize: 18.sp,
                                      color: MuzhikiColors.black23,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  ActionCard(
                                    title: 'Каналы уведомления',
                                    titleSize: 12,
                                    titleColor: MuzhikiColors.black23,
                                    titleWeight: FontWeight.w600,
                                    badge: SettingsBadge(
                                      label:
                                          subscription.channels?.isEmpty ?? true
                                          ? 'Не настроено'
                                          : subscription.channelsLabel,
                                      color: MuzhikiColors.alertTextGrey,
                                      fontSize: 15,
                                    ),
                                    badgeSpacing: 5,
                                    onTap: () => pickChannels(subscription),
                                  ),
                                  for (final parameter
                                      in subscription.parameters.values.where(
                                        isParameterSupported,
                                      )) ...[
                                    SizedBox(height: 7.h),
                                    ActionCard(
                                      title: parameter.name,
                                      titleSize: 12,
                                      titleColor: MuzhikiColors.black23,
                                      titleWeight: FontWeight.w600,
                                      badge: SettingsBadge(
                                        label: valueLabel(parameter),
                                        color: MuzhikiColors.alertTextGrey,
                                        fontSize: 15,
                                      ),
                                      badgeSpacing: 5,
                                      isLoading: viewModel
                                          .state
                                          .loadingExternalOptionsTypes
                                          .contains(parameter.type),
                                      enabled: !viewModel
                                          .state
                                          .loadingExternalOptionsTypes
                                          .contains(parameter.type),
                                      onTap: () => pickParameter(
                                        subscription,
                                        parameter,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
