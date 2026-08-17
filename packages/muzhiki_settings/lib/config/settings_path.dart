class SettingsPath {
  SettingsPath._();

  static const _baseNotificationsUrl = 'https://v2.notifications.muzhiki.pro';

  static const String notificationSubscriptions =
      '$_baseNotificationsUrl/notification-subscriptions';

  static String notificationSubscriptionByKey({
    required String notificationKey,
  }) => '$_baseNotificationsUrl/notification-subscriptions/$notificationKey';
}
