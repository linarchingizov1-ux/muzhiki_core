import 'package:flutter/material.dart';
import 'package:muzhiki_settings/config/settings_colors.dart';
import 'package:muzhiki_settings/notification/data/model/notification_subscription_model.dart';

extension NotificationSubscriptionExtension on NotificationSubscriptionModel {
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
      !isEnabled && isEditable ? SettingsColors.blood : SettingsColors.black23;

  Color get statusBackgroundColor => !isEnabled && isEditable
      ? SettingsColors.backgroundRed
      : SettingsColors.light;
}
