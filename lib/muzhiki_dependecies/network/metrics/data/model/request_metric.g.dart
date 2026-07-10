// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestMetric _$RequestMetricFromJson(Map<String, dynamic> json) =>
    _RequestMetric(
      startedAt: DateTime.parse(json['started_at'] as String),
      path: json['path'] as String,
      pathRaw: json['path_raw'] as String,
      method: $enumDecode(_$RequestMethodEnumMap, json['method']),
      durationMs: (json['duration_ms'] as num).toInt(),
      statusCode: (json['status_code'] as num?)?.toInt(),
      success: json['success'] as bool,
      errorType: $enumDecodeNullable(_$RequestErrorEnumMap, json['error_type']),
      responseSizeBytes: (json['response_size_bytes'] as num?)?.toInt(),
      requestSizeBytes: (json['request_size_bytes'] as num?)?.toInt(),
      networkType: $enumDecode(_$RequestNetworkEnumMap, json['network_type']),
      vpnActive: json['vpn_active'] as bool?,
      requestId: json['request_id'] as String?,
    );

Map<String, dynamic> _$RequestMetricToJson(_RequestMetric instance) =>
    <String, dynamic>{
      'started_at': instance.startedAt.toIso8601String(),
      'path': instance.path,
      'path_raw': instance.pathRaw,
      'method': _$RequestMethodEnumMap[instance.method]!,
      'duration_ms': instance.durationMs,
      'status_code': instance.statusCode,
      'success': instance.success,
      'error_type': _$RequestErrorEnumMap[instance.errorType],
      'response_size_bytes': instance.responseSizeBytes,
      'request_size_bytes': instance.requestSizeBytes,
      'network_type': _$RequestNetworkEnumMap[instance.networkType]!,
      'vpn_active': instance.vpnActive,
      'request_id': instance.requestId,
    };

const _$RequestMethodEnumMap = {
  RequestMethod.get: 'GET',
  RequestMethod.post: 'POST',
  RequestMethod.put: 'PUT',
  RequestMethod.patch: 'PATCH',
  RequestMethod.delete: 'DELETE',
};

const _$RequestErrorEnumMap = {
  RequestError.none: 'null',
  RequestError.timeout: 'timeout',
  RequestError.connection: 'connection',
  RequestError.dns: 'dns',
  RequestError.cancelled: 'cancelled',
  RequestError.http4xx: 'http_4xx',
  RequestError.http5xx: 'http_5xx',
  RequestError.unknown: 'unknown',
};

const _$RequestNetworkEnumMap = {
  RequestNetwork.wifi: 'wifi',
  RequestNetwork.cellular: 'cellular',
  RequestNetwork.ethernet: 'ethernet',
  RequestNetwork.bluetooth: 'bluetooth',
  RequestNetwork.vpn: 'vpn',
  RequestNetwork.satellite: 'satellite',
  RequestNetwork.other: 'other',
  RequestNetwork.none: 'none',
  RequestNetwork.unknown: 'unknown',
};
