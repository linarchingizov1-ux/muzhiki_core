import 'package:dio/dio.dart';
import 'package:muzhiki_dependencies/muzhiki_dependencies.dart';
import 'package:muzhiki_settings/config/settings_path.dart';
import 'package:muzhiki_settings/notification/data/model/notification_subscription_model.dart';
import 'package:muzhiki_settings/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final Dio dio;

  const NotificationRepositoryImpl(this.dio);

  @override
  Future<List<NotificationSubscriptionModel>> getSubscriptions() async {
    try {
      final response = await dio.get(SettingsPath.notificationSubscriptions);

      final data = response.data['data'] as Map<String, dynamic>;

      return (data['items'] as List<dynamic>)
          .map(
            (e) => NotificationSubscriptionModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }

  @override
  Future<NotificationSubscriptionModel> updateSubscription({
    required String notificationKey,
    bool? isEnabled,
    List<String>? channels,
    bool resetChannelsToDefault = false,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final response = await dio.patch(
        SettingsPath.notificationSubscriptionByKey(
          notificationKey: notificationKey,
        ),
        data: {
          if (isEnabled != null) 'is_enabled': isEnabled,
          if (resetChannelsToDefault) 'channels': null,
          if (!resetChannelsToDefault && channels != null) 'channels': channels,
          if (filters != null) 'filters': filters,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;

      return NotificationSubscriptionModel.fromJson(data);
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }
}
