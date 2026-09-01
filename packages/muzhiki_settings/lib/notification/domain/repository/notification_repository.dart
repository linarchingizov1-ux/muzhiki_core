import 'package:muzhiki_settings/notification/domain/entity/notification_subscription_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationSubscriptionEntity>> getSubscriptions();

  Future<NotificationSubscriptionEntity> updateSubscription({
    required String notificationKey,
    bool? isEnabled,
    List<String>? channels,
    bool resetChannelsToDefault = false,
    Map<String, dynamic>? filters,
  });
}
