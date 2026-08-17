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
  type: json['type'] as String,
  enumValues: json['enum'] as List<dynamic>?,
  required: json['required'] as bool,
  defaultValue: json['default'],
);

Map<String, dynamic> _$NotificationParameterModelToJson(
  NotificationParameterModel instance,
) => <String, dynamic>{
  'key': instance.key,
  'name': instance.name,
  'type': instance.type,
  'enum': instance.enumValues,
  'required': instance.required,
  'default': instance.defaultValue,
};
