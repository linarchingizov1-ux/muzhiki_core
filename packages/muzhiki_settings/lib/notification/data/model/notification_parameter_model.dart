import 'package:json_annotation/json_annotation.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_type.dart';

part 'notification_parameter_model.g.dart';

@JsonSerializable()
class NotificationParameterModel {
  final String key;
  final String name;
  @JsonKey(unknownEnumValue: NotificationParameterType.unknown)
  final NotificationParameterType type;
  @JsonKey(name: 'enum')
  final List<dynamic>? enumValues;
  final bool required;
  @JsonKey(name: 'default')
  final dynamic defaultValue;
  @JsonKey(name: 'is_inverted')
  final bool isInverted;

  const NotificationParameterModel({
    required this.key,
    required this.name,
    required this.type,
    required this.enumValues,
    required this.required,
    required this.defaultValue,
    this.isInverted = false,
  });

  factory NotificationParameterModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationParameterModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationParameterModelToJson(this);
}
