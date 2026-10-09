import 'package:json_annotation/json_annotation.dart';
part 'problem_queue.g.dart';

@JsonSerializable()
class ProblemQueue {
  final String id;
  final DateTime date;
  final Map<String, Object?> payload;
  final String? screenshotPath;
  const ProblemQueue({
    required this.payload,
    this.screenshotPath,
    required this.id,
    required this.date,
  });

  factory ProblemQueue.fromJson(Map<String, dynamic> json) =>
      _$ProblemQueueFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemQueueToJson(this);
}
