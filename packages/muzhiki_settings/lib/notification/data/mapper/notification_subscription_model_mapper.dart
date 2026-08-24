import 'package:muzhiki_settings/notification/data/model/notification_channel_model.dart';
import 'package:muzhiki_settings/notification/data/model/notification_parameter_model.dart';
import 'package:muzhiki_settings/notification/data/model/notification_subscription_model.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_channel_entity.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_entity.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_option_entity.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_type.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_subscription_entity.dart';

extension NotificationSubscriptionModelMapper on NotificationSubscriptionModel {
  NotificationSubscriptionEntity toEntity() {
    return NotificationSubscriptionEntity(
      notificationKey: notificationKey,
      name: name,
      description: description,
      isEnabled: isEnabled,
      isEditable: isEditable,
      availableChannels: availableChannels
          .map((channel) => channel.toEntity())
          .toList(),
      channels: channels,
      filters: filters,
      parameters: parameters.map(
        (key, parameter) => MapEntry(
          key,
          parameter.toEntity(filters: filters),
        ),
      ),
    );
  }
}

extension NotificationParameterModelMapper on NotificationParameterModel {
  NotificationParameterEntity toEntity({
    required Map<String, dynamic> filters,
  }) {
    return NotificationParameterEntity(
      key: key,
      name: name,
      type: type,
      required: required,
      isInverted: isInverted,
      options: enumOptions,
      selectedValues: selectedValues(filters: filters),
    );
  }

  List<NotificationParameterOptionEntity> get enumOptions {
    if (type != NotificationParameterType.enumeration &&
        type != NotificationParameterType.multiplyEnum) {
      return const [];
    }

    return (enumValues ?? const [])
        .map(
          (value) => NotificationParameterOptionEntity(
            value: value as Object,
            label: '$value',
          ),
        )
        .toList();
  }

  List<Object> selectedValues({required Map<String, dynamic> filters}) {
    final value = filters.containsKey(key) ? filters[key] : defaultValue;
    if (value == null) return const [];

    return value is List ? value.whereType<Object>().toList() : [value];
  }
}

extension NotificationChannelModelMapper on NotificationChannelModel {
  NotificationChannelEntity toEntity() =>
      NotificationChannelEntity(key: key, name: name);
}
