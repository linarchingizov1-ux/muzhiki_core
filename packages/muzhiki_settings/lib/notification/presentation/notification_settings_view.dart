import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_settings/config/settings_assets.dart';
import 'package:muzhiki_settings/config/settings_route_constant.dart';
import 'package:muzhiki_settings/notification/presentation/extension/notification_subscription_extension.dart';
import 'package:muzhiki_settings/notification/presentation/state/notification_settings_view_model.dart';
import 'package:muzhiki_settings/widgets/action_card.dart';
import 'package:muzhiki_settings/widgets/settings_badge.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';
import 'package:provider/provider.dart';

class NotificationSettingsView extends StatefulWidget {
  final NotificationSettingsViewModel viewModel;
  final Widget? banner;

  const NotificationSettingsView({
    super.key,
    required this.viewModel,
    this.banner,
  });

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.init();
  }

  @override
  void dispose() {
    widget.viewModel.clearExternalOptions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ChangeNotifierProvider.value(
        value: widget.viewModel,
        child: Consumer<NotificationSettingsViewModel>(
          builder: (context, viewModel, _) {
            final state = viewModel.state;

            return RefreshIndicator.adaptive(
              displacement: 120,
              color: MuzhikiColors.black23,
              strokeWidth: 0.5,
              onRefresh: () => viewModel.init(isRefresh: true),
              child: Scaffold(
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
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        slivers: [
                          SliverPadding(padding: EdgeInsets.only(top: 7.h)),
                          if (state.isSubscriptionsLoading)
                            const SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          else if (state.subscriptionsError != null &&
                              state.subscriptions == null)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.subscriptionsError!,
                                      textAlign: TextAlign.center,
                                      style: MuzhikiFonts.manropeStyle(
                                        fontSize: 15.sp,
                                        color: MuzhikiColors.alertTextGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 15.h),
                                    MuzhikiUi.buttons.primary(
                                      label: 'Повторить',
                                      onPressed: () =>
                                          viewModel.getSubscriptions(),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (state.subscriptions?.isEmpty ?? false)
                            const SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(child: Text('Ничего не найдено')),
                            )
                          else
                            SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              sliver: SliverList.separated(
                                itemCount: state.subscriptions!.length,
                                separatorBuilder: (_, _) =>
                                    SizedBox(height: 7.h),
                                itemBuilder: (context, index) {
                                  final subscription =
                                      state.subscriptions![index];

                                  return ActionCard(
                                    title: subscription.name,
                                    description: subscription.description,
                                    icon: SettingsAssets.power,
                                    iconColor: !subscription.isEditable
                                        ? MuzhikiColors.alertTextGrey
                                              .withValues(alpha: 0.3)
                                        : subscription.isEnabled
                                        ? MuzhikiColors.alertTextGrey
                                        : MuzhikiColors.white,
                                    backgroundIconColor:
                                        !subscription.isEditable
                                        ? MuzhikiColors.appBackgroud
                                        : subscription.isEnabled
                                        ? MuzhikiColors.appBackgroud
                                        : MuzhikiColors.blood,
                                    badge: SettingsBadge(
                                      label: subscription.statusLabel,
                                      icon: !subscription.isEditable
                                          ? SettingsAssets.lockFilled
                                          : null,
                                      color: subscription.statusColor,
                                      backgroundColor:
                                          subscription.statusBackgroundColor,
                                    ),
                                    badgeSpacing: 10,
                                    enabled: subscription.isEditable,
                                    onIconTap: () =>
                                        widget.viewModel.toggleEnabled(
                                          subscription: subscription,
                                        ),
                                    showSuffixIcon: subscription.isEditable,
                                    onTap: () {
                                      viewModel.setSelectedKey(
                                        subscription.notificationKey,
                                      );
                                      context.pushNamed(
                                        SettingsRouteConstant
                                            .notificationSettingsDetail,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          SliverPadding(padding: EdgeInsets.only(bottom: 30.h)),
                        ],
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
