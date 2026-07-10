import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_enum.dart';
part 'request_metric.freezed.dart';
part 'request_metric.g.dart';

@freezed
abstract class RequestMetric with _$RequestMetric {
  const factory RequestMetric({
    @JsonKey(name: 'started_at') required DateTime startedAt,

    required String path,

    @JsonKey(name: 'path_raw') required String pathRaw,

    required RequestMethod method,

    @JsonKey(name: 'duration_ms') required int durationMs,

    @JsonKey(name: 'status_code') required int? statusCode,

    required bool success,

    @JsonKey(name: 'error_type') RequestError? errorType,

    @JsonKey(name: 'response_size_bytes') int? responseSizeBytes,

    @JsonKey(name: 'request_size_bytes') int? requestSizeBytes,

    @JsonKey(name: 'network_type') required RequestNetwork networkType,

    @JsonKey(name: 'vpn_active') required bool? vpnActive,

    @JsonKey(name: 'request_id') String? requestId,
  }) = _RequestMetric;

  factory RequestMetric.fromJson(Map<String, dynamic> json) =>
      _$RequestMetricFromJson(json);
}
