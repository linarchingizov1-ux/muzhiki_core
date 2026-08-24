import 'package:flutter/material.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_subscription_entity.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

extension NotificationSubscriptionExtension on NotificationSubscriptionEntity {
  String get statusLabel {
    if (!isEditable) return 'Нельзя отключить и настроить';
    if (!isEnabled) return 'Отключено';
    if (channels?.isEmpty ?? true) return 'Каналы не выбраны';

    return channelsLabel;
  }

  String get channelsLabel => availableChannels
      .where((channel) => channels?.contains(channel.key) ?? false)
      .map((channel) => channel.name)
      .join(', ');

  Color get statusColor =>
      !isEnabled && isEditable ? MuzhikiColors.blood : MuzhikiColors.black23;

  Color get statusBackgroundColor => !isEnabled && isEditable
      ? MuzhikiColors.backgroundBlood
      : MuzhikiColors.light;
}
