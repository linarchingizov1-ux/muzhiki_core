import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_option_entity.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_type.dart';

class NotificationParameterEntity {
  final String key;
  final String name;
  final NotificationParameterType type;
  final bool required;
  final bool isInverted;
  final List<NotificationParameterOptionEntity> options;
  final List<Object> selectedValues;

  const NotificationParameterEntity({
    required this.key,
    required this.name,
    required this.type,
    required this.required,
    required this.options,
    required this.selectedValues,
    this.isInverted = false,
  });
}
