import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_settings/notification/data/model/notification_parameter_model.dart';
import 'package:muzhiki_settings/notification/data/model/notification_subscription_model.dart';
import 'package:muzhiki_settings/notification/domain/model/notification_external_option_source.dart';
import 'package:muzhiki_settings/notification/domain/model/notification_parameter_option.dart';
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
  static const builtInParameterTypes = {'number', 'enum', 'multiply_enum'};

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

  List<Object> selectedValues(
    NotificationSubscriptionModel subscription,
    NotificationParameterModel parameter,
  ) {
    final value = subscription.filters.containsKey(parameter.key)
        ? subscription.filters[parameter.key]
        : parameter.defaultValue;
    if (value == null) return const [];

    return value is List ? value.whereType<Object>().toList() : [value];
  }

  String valueLabel(
    NotificationSubscriptionModel subscription,
    NotificationParameterModel parameter,
  ) {
    final selected = selectedValues(subscription, parameter);
    final hasError = widget.viewModel.state.externalOptionsErrorsByType
        .containsKey(parameter.type);

    if (selected.isEmpty) {
      return hasError ? 'Не удалось загрузить' : 'Не настроено';
    }

    final isExternalType = widget.viewModel.externalOptionSources.containsKey(
      parameter.type,
    );
    final availableOptions =
        widget.viewModel.state.externalOptionsByType[parameter.type] ??
        const [];
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

  bool isSupported(NotificationParameterModel parameter) =>
      builtInParameterTypes.contains(parameter.type) ||
      widget.viewModel.externalOptionSources.containsKey(parameter.type);

  Future<void> pickChannels(NotificationSubscriptionModel subscription) async {
    await MuzhikiUi.dialog.standart<void>(
      child: NotificationOptionsDialog.multiple(
        title: 'Каналы уведомления',
        errorTitle: 'Не удалось сохранить каналы',
        errorDescription: () => widget.viewModel.state.lastDetailSavingError,
        selected: subscription.channels ?? const [],
        emptyLabel: 'Список доступных каналов пуст',
        options: subscription.availableChannels
            .map(
              (channel) => NotificationParameterOption(
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
    NotificationSubscriptionModel subscription,
    NotificationParameterModel parameter,
  ) async {
    final selected = selectedValues(subscription, parameter);

    if (parameter.type == 'number') {
      await MuzhikiUi.dialog.standart<void>(
        child: NotificationNumberDialog(
          title: parameter.name,
          value: selected.firstOrNull is num
              ? selected.firstOrNull as num?
              : null,
          isRequired: parameter.required,
          onSubmit: (value) => saveFilter(subscription, parameter, value),
          errorTitle: 'Не удалось сохранить настройки',
          errorDescription: () => widget.viewModel.state.lastDetailSavingError,
        ),
      );
      return;
    }

    final source = widget.viewModel.externalOptionSources[parameter.type];
    final isMultiple = source?.isMultiple ?? parameter.type == 'multiply_enum';

    List<NotificationParameterOption> options;

    if (source == null) {
      if (!builtInParameterTypes.contains(parameter.type)) return;

      options = (parameter.enumValues ?? const [])
          .map(
            (value) => NotificationParameterOption(
              value: value as Object,
              label: '$value',
            ),
          )
          .toList();
    } else {
      final loadedOptions = await getOptionsOrShowError(
        subscription: subscription,
        parameter: parameter,
        source: source,
      );
      if (loadedOptions == null) return;

      options = loadedOptions;
    }

    if (!mounted) return;

    await MuzhikiUi.dialog.standart<void>(
      child: isMultiple
          ? NotificationOptionsDialog.multiple(
              title: parameter.name,
              errorTitle: 'Не удалось сохранить настройки',
              errorDescription: () => widget.viewModel.state.lastDetailSavingError,
              isRequired: parameter.required,
              selected: selected,
              options: options,
              emptyLabel: parameter.type == 'masters'
                  ? 'Список доступных мастеров пуст'
                  : 'Список доступных вариантов пуст',
              onSubmit: (pickedOptions) => saveFilter(
                subscription,
                parameter,
                pickedOptions.map((option) => option.value).toList(),
              ),
            )
          : NotificationOptionsDialog.single(
              title: parameter.name,
              errorTitle: 'Не удалось сохранить настройки',
              errorDescription: () => widget.viewModel.state.lastDetailSavingError,
              isRequired: parameter.required,
              selected: selected,
              options: options,
              emptyLabel: parameter.type == 'masters'
                  ? 'Список доступных мастеров пуст'
                  : 'Список доступных вариантов пуст',
              onSelect: (pickedOption) =>
                  saveFilter(subscription, parameter, pickedOption?.value),
            ),
    );
  }

  Future<List<NotificationParameterOption>?> getOptionsOrShowError({
    required NotificationSubscriptionModel subscription,
    required NotificationParameterModel parameter,
    required NotificationExternalOptionSource source,
  }) async {
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

  Future<bool> saveFilter(
    NotificationSubscriptionModel subscription,
    NotificationParameterModel parameter,
    Object? value,
  ) {
    final currentSubscription =
        widget.viewModel.state.selectedSubscription ?? subscription;

    return widget.viewModel.setFilters(
      subscription: currentSubscription,
      filters: {...currentSubscription.filters, parameter.key: value},
    );
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
                                        isSupported,
                                      )) ...[
                                    SizedBox(height: 7.h),
                                    ActionCard(
                                      title: parameter.name,
                                      titleSize: 12,
                                      titleColor: MuzhikiColors.black23,
                                      titleWeight: FontWeight.w600,
                                      badge: SettingsBadge(
                                        label: valueLabel(
                                          subscription,
                                          parameter,
                                        ),
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
