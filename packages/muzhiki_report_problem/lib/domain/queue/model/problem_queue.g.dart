// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_queue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProblemQueue _$ProblemQueueFromJson(Map<String, dynamic> json) => ProblemQueue(
  payload: json['payload'] as Map<String, dynamic>,
  screenshotPath: json['screenshotPath'] as String?,
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$ProblemQueueToJson(ProblemQueue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'payload': instance.payload,
      'screenshotPath': instance.screenshotPath,
    };
