import 'package:json_annotation/json_annotation.dart';

part 'notification_parameter_model.g.dart';

@JsonSerializable()
class NotificationParameterModel {
  final String key;
  final String name;
  final String type;
  @JsonKey(name: 'enum')
  final List<dynamic>? enumValues;
  final bool required;
  @JsonKey(name: 'default')
  final dynamic defaultValue;

  const NotificationParameterModel({
    required this.key,
    required this.name,
    required this.type,
    required this.enumValues,
    required this.required,
    required this.defaultValue,
  });

  factory NotificationParameterModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationParameterModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationParameterModelToJson(this);
}
