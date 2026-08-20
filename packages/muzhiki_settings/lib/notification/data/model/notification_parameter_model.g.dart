// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_parameter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationParameterModel _$NotificationParameterModelFromJson(
  Map<String, dynamic> json,
) => NotificationParameterModel(
  key: json['key'] as String,
  name: json['name'] as String,
  type: $enumDecode(
    _$NotificationParameterTypeEnumMap,
    json['type'],
    unknownValue: NotificationParameterType.unknown,
  ),
  enumValues: json['enum'] as List<dynamic>?,
  required: json['required'] as bool,
  defaultValue: json['default'],
  isInverted: json['is_inverted'] as bool? ?? false,
);

Map<String, dynamic> _$NotificationParameterModelToJson(
  NotificationParameterModel instance,
) => <String, dynamic>{
  'key': instance.key,
  'name': instance.name,
  'type': _$NotificationParameterTypeEnumMap[instance.type]!,
  'enum': instance.enumValues,
  'required': instance.required,
  'default': instance.defaultValue,
  'is_inverted': instance.isInverted,
};

const _$NotificationParameterTypeEnumMap = {
  NotificationParameterType.number: 'number',
  NotificationParameterType.enumeration: 'enum',
  NotificationParameterType.multiplyEnum: 'multiply_enum',
  NotificationParameterType.masters: 'masters',
  NotificationParameterType.companies: 'companies',
  NotificationParameterType.unknown: 'unknown',
};
