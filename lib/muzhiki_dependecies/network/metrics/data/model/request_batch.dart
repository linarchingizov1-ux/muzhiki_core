import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_enum.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_metric.dart';

part 'request_batch.freezed.dart';
part 'request_batch.g.dart';

@freezed
abstract class RequestBatch with _$RequestBatch {
  const factory RequestBatch({
    @JsonKey(name: 'batch_timestamp') required DateTime batchTimestamp,

    @JsonKey(name: 'session_id') required String sessionId,

    @JsonKey(name: 'app_name') required String appName,

    required RequestPlatform platform,

    @JsonKey(name: 'app_version') required String appVersion,

    int? mpid,

    required List<RequestMetric> requests,
  }) = _RequestBatch;

  factory RequestBatch.fromJson(Map<String, dynamic> json) =>
      _$RequestBatchFromJson(json);
}
