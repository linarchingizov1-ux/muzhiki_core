import 'package:go_router/go_router.dart';
import 'package:muzhiki_settings/config/settings_route_constant.dart';
import 'package:muzhiki_settings/notification/config/notification_settings_config.dart';
import 'package:muzhiki_settings/notification/data/repository/notification_repository_impl.dart';
import 'package:muzhiki_settings/notification/presentation/notification_settings_detail_view.dart';
import 'package:muzhiki_settings/notification/presentation/notification_settings_view.dart';
import 'package:muzhiki_settings/notification/presentation/state/notification_settings_view_model.dart';

class NotificationSettingsModule {
  const NotificationSettingsModule._();

  static List<RouteBase> routers({
    required NotificationSettingsModuleConfig config,
  }) {
    final NotificationSettingsViewModel viewModel =
        NotificationSettingsViewModel(
          repository: NotificationRepositoryImpl(config.authDio),
          externalOptionSources: config.externalOptionSources,
        );

    return [
      GoRoute(
        path: SettingsRouteConstant.notificationSetting,
        name: SettingsRouteConstant.notificationSetting,
        builder: (context, state) => NotificationSettingsView(
          viewModel: viewModel,
          banner: config.vpnDetector,
        ),
      ),
      GoRoute(
        path: SettingsRouteConstant.notificationSettingsDetail,
        name: SettingsRouteConstant.notificationSettingsDetail,
        builder: (context, state) => NotificationSettingsDetailView(
          viewModel: viewModel,
          banner: config.vpnDetector,
        ),
      ),
    ];
  }
}
