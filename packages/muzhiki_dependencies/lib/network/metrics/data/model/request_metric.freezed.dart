// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_metric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestMetric {

@JsonKey(name: 'started_at') DateTime get startedAt; String get path;@JsonKey(name: 'path_raw') String get pathRaw; RequestMethod get method;@JsonKey(name: 'duration_ms') int get durationMs;@JsonKey(name: 'status_code') int? get statusCode; bool get success;@JsonKey(name: 'error_type') RequestError? get errorType;@JsonKey(name: 'response_size_bytes') int? get responseSizeBytes;@JsonKey(name: 'request_size_bytes') int? get requestSizeBytes;@JsonKey(name: 'network_type') RequestNetwork get networkType;@JsonKey(name: 'vpn_active') bool? get vpnActive;@JsonKey(name: 'request_id') String? get requestId;
/// Create a copy of RequestMetric
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestMetricCopyWith<RequestMetric> get copyWith => _$RequestMetricCopyWithImpl<RequestMetric>(this as RequestMetric, _$identity);

  /// Serializes this RequestMetric to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestMetric&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.path, path) || other.path == path)&&(identical(other.pathRaw, pathRaw) || other.pathRaw == pathRaw)&&(identical(other.method, method) || other.method == method)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.success, success) || other.success == success)&&(identical(other.errorType, errorType) || other.errorType == errorType)&&(identical(other.responseSizeBytes, responseSizeBytes) || other.responseSizeBytes == responseSizeBytes)&&(identical(other.requestSizeBytes, requestSizeBytes) || other.requestSizeBytes == requestSizeBytes)&&(identical(other.networkType, networkType) || other.networkType == networkType)&&(identical(other.vpnActive, vpnActive) || other.vpnActive == vpnActive)&&(identical(other.requestId, requestId) || other.requestId == requestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startedAt,path,pathRaw,method,durationMs,statusCode,success,errorType,responseSizeBytes,requestSizeBytes,networkType,vpnActive,requestId);

@override
String toString() {
  return 'RequestMetric(startedAt: $startedAt, path: $path, pathRaw: $pathRaw, method: $method, durationMs: $durationMs, statusCode: $statusCode, success: $success, errorType: $errorType, responseSizeBytes: $responseSizeBytes, requestSizeBytes: $requestSizeBytes, networkType: $networkType, vpnActive: $vpnActive, requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class $RequestMetricCopyWith<$Res>  {
  factory $RequestMetricCopyWith(RequestMetric value, $Res Function(RequestMetric) _then) = _$RequestMetricCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'started_at') DateTime startedAt, String path,@JsonKey(name: 'path_raw') String pathRaw, RequestMethod method,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'status_code') int? statusCode, bool success,@JsonKey(name: 'error_type') RequestError? errorType,@JsonKey(name: 'response_size_bytes') int? responseSizeBytes,@JsonKey(name: 'request_size_bytes') int? requestSizeBytes,@JsonKey(name: 'network_type') RequestNetwork networkType,@JsonKey(name: 'vpn_active') bool? vpnActive,@JsonKey(name: 'request_id') String? requestId
});




}
/// @nodoc
class _$RequestMetricCopyWithImpl<$Res>
    implements $RequestMetricCopyWith<$Res> {
  _$RequestMetricCopyWithImpl(this._self, this._then);

  final RequestMetric _self;
  final $Res Function(RequestMetric) _then;

/// Create a copy of RequestMetric
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startedAt = null,Object? path = null,Object? pathRaw = null,Object? method = null,Object? durationMs = null,Object? statusCode = freezed,Object? success = null,Object? errorType = freezed,Object? responseSizeBytes = freezed,Object? requestSizeBytes = freezed,Object? networkType = null,Object? vpnActive = freezed,Object? requestId = freezed,}) {
  return _then(_self.copyWith(
startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,pathRaw: null == pathRaw ? _self.pathRaw : pathRaw // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as RequestMethod,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,errorType: freezed == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as RequestError?,responseSizeBytes: freezed == responseSizeBytes ? _self.responseSizeBytes : responseSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,requestSizeBytes: freezed == requestSizeBytes ? _self.requestSizeBytes : requestSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,networkType: null == networkType ? _self.networkType : networkType // ignore: cast_nullable_to_non_nullable
as RequestNetwork,vpnActive: freezed == vpnActive ? _self.vpnActive : vpnActive // ignore: cast_nullable_to_non_nullable
as bool?,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestMetric].
extension RequestMetricPatterns on RequestMetric {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestMetric value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestMetric() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestMetric value)  $default,){
final _that = this;
switch (_that) {
case _RequestMetric():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestMetric value)?  $default,){
final _that = this;
switch (_that) {
case _RequestMetric() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'started_at')  DateTime startedAt,  String path, @JsonKey(name: 'path_raw')  String pathRaw,  RequestMethod method, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'status_code')  int? statusCode,  bool success, @JsonKey(name: 'error_type')  RequestError? errorType, @JsonKey(name: 'response_size_bytes')  int? responseSizeBytes, @JsonKey(name: 'request_size_bytes')  int? requestSizeBytes, @JsonKey(name: 'network_type')  RequestNetwork networkType, @JsonKey(name: 'vpn_active')  bool? vpnActive, @JsonKey(name: 'request_id')  String? requestId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestMetric() when $default != null:
return $default(_that.startedAt,_that.path,_that.pathRaw,_that.method,_that.durationMs,_that.statusCode,_that.success,_that.errorType,_that.responseSizeBytes,_that.requestSizeBytes,_that.networkType,_that.vpnActive,_that.requestId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'started_at')  DateTime startedAt,  String path, @JsonKey(name: 'path_raw')  String pathRaw,  RequestMethod method, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'status_code')  int? statusCode,  bool success, @JsonKey(name: 'error_type')  RequestError? errorType, @JsonKey(name: 'response_size_bytes')  int? responseSizeBytes, @JsonKey(name: 'request_size_bytes')  int? requestSizeBytes, @JsonKey(name: 'network_type')  RequestNetwork networkType, @JsonKey(name: 'vpn_active')  bool? vpnActive, @JsonKey(name: 'request_id')  String? requestId)  $default,) {final _that = this;
switch (_that) {
case _RequestMetric():
return $default(_that.startedAt,_that.path,_that.pathRaw,_that.method,_that.durationMs,_that.statusCode,_that.success,_that.errorType,_that.responseSizeBytes,_that.requestSizeBytes,_that.networkType,_that.vpnActive,_that.requestId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'started_at')  DateTime startedAt,  String path, @JsonKey(name: 'path_raw')  String pathRaw,  RequestMethod method, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'status_code')  int? statusCode,  bool success, @JsonKey(name: 'error_type')  RequestError? errorType, @JsonKey(name: 'response_size_bytes')  int? responseSizeBytes, @JsonKey(name: 'request_size_bytes')  int? requestSizeBytes, @JsonKey(name: 'network_type')  RequestNetwork networkType, @JsonKey(name: 'vpn_active')  bool? vpnActive, @JsonKey(name: 'request_id')  String? requestId)?  $default,) {final _that = this;
switch (_that) {
case _RequestMetric() when $default != null:
return $default(_that.startedAt,_that.path,_that.pathRaw,_that.method,_that.durationMs,_that.statusCode,_that.success,_that.errorType,_that.responseSizeBytes,_that.requestSizeBytes,_that.networkType,_that.vpnActive,_that.requestId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestMetric implements RequestMetric {
  const _RequestMetric({@JsonKey(name: 'started_at') required this.startedAt, required this.path, @JsonKey(name: 'path_raw') required this.pathRaw, required this.method, @JsonKey(name: 'duration_ms') required this.durationMs, @JsonKey(name: 'status_code') required this.statusCode, required this.success, @JsonKey(name: 'error_type') this.errorType, @JsonKey(name: 'response_size_bytes') this.responseSizeBytes, @JsonKey(name: 'request_size_bytes') this.requestSizeBytes, @JsonKey(name: 'network_type') required this.networkType, @JsonKey(name: 'vpn_active') required this.vpnActive, @JsonKey(name: 'request_id') this.requestId});
  factory _RequestMetric.fromJson(Map<String, dynamic> json) => _$RequestMetricFromJson(json);

@override@JsonKey(name: 'started_at') final  DateTime startedAt;
@override final  String path;
@override@JsonKey(name: 'path_raw') final  String pathRaw;
@override final  RequestMethod method;
@override@JsonKey(name: 'duration_ms') final  int durationMs;
@override@JsonKey(name: 'status_code') final  int? statusCode;
@override final  bool success;
@override@JsonKey(name: 'error_type') final  RequestError? errorType;
@override@JsonKey(name: 'response_size_bytes') final  int? responseSizeBytes;
@override@JsonKey(name: 'request_size_bytes') final  int? requestSizeBytes;
@override@JsonKey(name: 'network_type') final  RequestNetwork networkType;
@override@JsonKey(name: 'vpn_active') final  bool? vpnActive;
@override@JsonKey(name: 'request_id') final  String? requestId;

/// Create a copy of RequestMetric
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestMetricCopyWith<_RequestMetric> get copyWith => __$RequestMetricCopyWithImpl<_RequestMetric>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestMetricToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestMetric&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.path, path) || other.path == path)&&(identical(other.pathRaw, pathRaw) || other.pathRaw == pathRaw)&&(identical(other.method, method) || other.method == method)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.success, success) || other.success == success)&&(identical(other.errorType, errorType) || other.errorType == errorType)&&(identical(other.responseSizeBytes, responseSizeBytes) || other.responseSizeBytes == responseSizeBytes)&&(identical(other.requestSizeBytes, requestSizeBytes) || other.requestSizeBytes == requestSizeBytes)&&(identical(other.networkType, networkType) || other.networkType == networkType)&&(identical(other.vpnActive, vpnActive) || other.vpnActive == vpnActive)&&(identical(other.requestId, requestId) || other.requestId == requestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startedAt,path,pathRaw,method,durationMs,statusCode,success,errorType,responseSizeBytes,requestSizeBytes,networkType,vpnActive,requestId);

@override
String toString() {
  return 'RequestMetric(startedAt: $startedAt, path: $path, pathRaw: $pathRaw, method: $method, durationMs: $durationMs, statusCode: $statusCode, success: $success, errorType: $errorType, responseSizeBytes: $responseSizeBytes, requestSizeBytes: $requestSizeBytes, networkType: $networkType, vpnActive: $vpnActive, requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class _$RequestMetricCopyWith<$Res> implements $RequestMetricCopyWith<$Res> {
  factory _$RequestMetricCopyWith(_RequestMetric value, $Res Function(_RequestMetric) _then) = __$RequestMetricCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'started_at') DateTime startedAt, String path,@JsonKey(name: 'path_raw') String pathRaw, RequestMethod method,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'status_code') int? statusCode, bool success,@JsonKey(name: 'error_type') RequestError? errorType,@JsonKey(name: 'response_size_bytes') int? responseSizeBytes,@JsonKey(name: 'request_size_bytes') int? requestSizeBytes,@JsonKey(name: 'network_type') RequestNetwork networkType,@JsonKey(name: 'vpn_active') bool? vpnActive,@JsonKey(name: 'request_id') String? requestId
});




}
/// @nodoc
class __$RequestMetricCopyWithImpl<$Res>
    implements _$RequestMetricCopyWith<$Res> {
  __$RequestMetricCopyWithImpl(this._self, this._then);

  final _RequestMetric _self;
  final $Res Function(_RequestMetric) _then;

/// Create a copy of RequestMetric
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startedAt = null,Object? path = null,Object? pathRaw = null,Object? method = null,Object? durationMs = null,Object? statusCode = freezed,Object? success = null,Object? errorType = freezed,Object? responseSizeBytes = freezed,Object? requestSizeBytes = freezed,Object? networkType = null,Object? vpnActive = freezed,Object? requestId = freezed,}) {
  return _then(_RequestMetric(
startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,pathRaw: null == pathRaw ? _self.pathRaw : pathRaw // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as RequestMethod,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,errorType: freezed == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as RequestError?,responseSizeBytes: freezed == responseSizeBytes ? _self.responseSizeBytes : responseSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,requestSizeBytes: freezed == requestSizeBytes ? _self.requestSizeBytes : requestSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,networkType: null == networkType ? _self.networkType : networkType // ignore: cast_nullable_to_non_nullable
as RequestNetwork,vpnActive: freezed == vpnActive ? _self.vpnActive : vpnActive // ignore: cast_nullable_to_non_nullable
as bool?,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
