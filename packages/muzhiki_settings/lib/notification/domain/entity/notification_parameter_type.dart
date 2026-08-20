import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum NotificationParameterType {
  number('number'),
  enumeration('enum'),
  multiplyEnum('multiply_enum'),
  masters('masters'),
  companies('companies'),
  unknown('unknown');

  const NotificationParameterType(this.value);

  final String value;

  bool get isFromServer =>
      this == number || this == enumeration || this == multiplyEnum;

  bool get isExternal => this == masters || this == companies;
}
