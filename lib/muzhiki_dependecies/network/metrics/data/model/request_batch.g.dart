// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestBatch _$RequestBatchFromJson(Map<String, dynamic> json) =>
    _RequestBatch(
      batchTimestamp: DateTime.parse(json['batch_timestamp'] as String),
      sessionId: json['session_id'] as String,
      appName: json['app_name'] as String,
      platform: $enumDecode(_$RequestPlatformEnumMap, json['platform']),
      appVersion: json['app_version'] as String,
      mpid: (json['mpid'] as num?)?.toInt(),
      requests: (json['requests'] as List<dynamic>)
          .map((e) => RequestMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RequestBatchToJson(_RequestBatch instance) =>
    <String, dynamic>{
      'batch_timestamp': instance.batchTimestamp.toIso8601String(),
      'session_id': instance.sessionId,
      'app_name': instance.appName,
      'platform': _$RequestPlatformEnumMap[instance.platform]!,
      'app_version': instance.appVersion,
      'mpid': instance.mpid,
      'requests': instance.requests,
    };

const _$RequestPlatformEnumMap = {
  RequestPlatform.android: 'android',
  RequestPlatform.ios: 'ios',
};
