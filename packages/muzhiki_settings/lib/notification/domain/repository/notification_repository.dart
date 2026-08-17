import 'package:muzhiki_settings/notification/data/model/notification_subscription_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationSubscriptionModel>> getSubscriptions();

  Future<NotificationSubscriptionModel> updateSubscription({
    required String notificationKey,
    bool? isEnabled,
    List<String>? channels,
    bool resetChannelsToDefault = false,
    Map<String, dynamic>? filters,
  });
}
