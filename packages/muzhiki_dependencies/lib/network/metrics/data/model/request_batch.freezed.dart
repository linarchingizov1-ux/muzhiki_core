// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_batch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestBatch {

@JsonKey(name: 'batch_timestamp') DateTime get batchTimestamp;@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'app_name') String get appName; RequestPlatform get platform;@JsonKey(name: 'app_version') String get appVersion; int? get mpid; List<RequestMetric> get requests;
/// Create a copy of RequestBatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestBatchCopyWith<RequestBatch> get copyWith => _$RequestBatchCopyWithImpl<RequestBatch>(this as RequestBatch, _$identity);

  /// Serializes this RequestBatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestBatch&&(identical(other.batchTimestamp, batchTimestamp) || other.batchTimestamp == batchTimestamp)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.mpid, mpid) || other.mpid == mpid)&&const DeepCollectionEquality().equals(other.requests, requests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,batchTimestamp,sessionId,appName,platform,appVersion,mpid,const DeepCollectionEquality().hash(requests));

@override
String toString() {
  return 'RequestBatch(batchTimestamp: $batchTimestamp, sessionId: $sessionId, appName: $appName, platform: $platform, appVersion: $appVersion, mpid: $mpid, requests: $requests)';
}


}

/// @nodoc
abstract mixin class $RequestBatchCopyWith<$Res>  {
  factory $RequestBatchCopyWith(RequestBatch value, $Res Function(RequestBatch) _then) = _$RequestBatchCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'batch_timestamp') DateTime batchTimestamp,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'app_name') String appName, RequestPlatform platform,@JsonKey(name: 'app_version') String appVersion, int? mpid, List<RequestMetric> requests
});




}
/// @nodoc
class _$RequestBatchCopyWithImpl<$Res>
    implements $RequestBatchCopyWith<$Res> {
  _$RequestBatchCopyWithImpl(this._self, this._then);

  final RequestBatch _self;
  final $Res Function(RequestBatch) _then;

/// Create a copy of RequestBatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? batchTimestamp = null,Object? sessionId = null,Object? appName = null,Object? platform = null,Object? appVersion = null,Object? mpid = freezed,Object? requests = null,}) {
  return _then(_self.copyWith(
batchTimestamp: null == batchTimestamp ? _self.batchTimestamp : batchTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as RequestPlatform,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,mpid: freezed == mpid ? _self.mpid : mpid // ignore: cast_nullable_to_non_nullable
as int?,requests: null == requests ? _self.requests : requests // ignore: cast_nullable_to_non_nullable
as List<RequestMetric>,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestBatch].
extension RequestBatchPatterns on RequestBatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestBatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestBatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestBatch value)  $default,){
final _that = this;
switch (_that) {
case _RequestBatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestBatch value)?  $default,){
final _that = this;
switch (_that) {
case _RequestBatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'batch_timestamp')  DateTime batchTimestamp, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'app_name')  String appName,  RequestPlatform platform, @JsonKey(name: 'app_version')  String appVersion,  int? mpid,  List<RequestMetric> requests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestBatch() when $default != null:
return $default(_that.batchTimestamp,_that.sessionId,_that.appName,_that.platform,_that.appVersion,_that.mpid,_that.requests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'batch_timestamp')  DateTime batchTimestamp, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'app_name')  String appName,  RequestPlatform platform, @JsonKey(name: 'app_version')  String appVersion,  int? mpid,  List<RequestMetric> requests)  $default,) {final _that = this;
switch (_that) {
case _RequestBatch():
return $default(_that.batchTimestamp,_that.sessionId,_that.appName,_that.platform,_that.appVersion,_that.mpid,_that.requests);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'batch_timestamp')  DateTime batchTimestamp, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'app_name')  String appName,  RequestPlatform platform, @JsonKey(name: 'app_version')  String appVersion,  int? mpid,  List<RequestMetric> requests)?  $default,) {final _that = this;
switch (_that) {
case _RequestBatch() when $default != null:
return $default(_that.batchTimestamp,_that.sessionId,_that.appName,_that.platform,_that.appVersion,_that.mpid,_that.requests);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestBatch implements RequestBatch {
  const _RequestBatch({@JsonKey(name: 'batch_timestamp') required this.batchTimestamp, @JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'app_name') required this.appName, required this.platform, @JsonKey(name: 'app_version') required this.appVersion, this.mpid, required final  List<RequestMetric> requests}): _requests = requests;
  factory _RequestBatch.fromJson(Map<String, dynamic> json) => _$RequestBatchFromJson(json);

@override@JsonKey(name: 'batch_timestamp') final  DateTime batchTimestamp;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'app_name') final  String appName;
@override final  RequestPlatform platform;
@override@JsonKey(name: 'app_version') final  String appVersion;
@override final  int? mpid;
 final  List<RequestMetric> _requests;
@override List<RequestMetric> get requests {
  if (_requests is EqualUnmodifiableListView) return _requests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requests);
}


/// Create a copy of RequestBatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestBatchCopyWith<_RequestBatch> get copyWith => __$RequestBatchCopyWithImpl<_RequestBatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestBatchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestBatch&&(identical(other.batchTimestamp, batchTimestamp) || other.batchTimestamp == batchTimestamp)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.mpid, mpid) || other.mpid == mpid)&&const DeepCollectionEquality().equals(other._requests, _requests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,batchTimestamp,sessionId,appName,platform,appVersion,mpid,const DeepCollectionEquality().hash(_requests));

@override
String toString() {
  return 'RequestBatch(batchTimestamp: $batchTimestamp, sessionId: $sessionId, appName: $appName, platform: $platform, appVersion: $appVersion, mpid: $mpid, requests: $requests)';
}


}

/// @nodoc
abstract mixin class _$RequestBatchCopyWith<$Res> implements $RequestBatchCopyWith<$Res> {
  factory _$RequestBatchCopyWith(_RequestBatch value, $Res Function(_RequestBatch) _then) = __$RequestBatchCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'batch_timestamp') DateTime batchTimestamp,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'app_name') String appName, RequestPlatform platform,@JsonKey(name: 'app_version') String appVersion, int? mpid, List<RequestMetric> requests
});




}
/// @nodoc
class __$RequestBatchCopyWithImpl<$Res>
    implements _$RequestBatchCopyWith<$Res> {
  __$RequestBatchCopyWithImpl(this._self, this._then);

  final _RequestBatch _self;
  final $Res Function(_RequestBatch) _then;

/// Create a copy of RequestBatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? batchTimestamp = null,Object? sessionId = null,Object? appName = null,Object? platform = null,Object? appVersion = null,Object? mpid = freezed,Object? requests = null,}) {
  return _then(_RequestBatch(
batchTimestamp: null == batchTimestamp ? _self.batchTimestamp : batchTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as RequestPlatform,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,mpid: freezed == mpid ? _self.mpid : mpid // ignore: cast_nullable_to_non_nullable
as int?,requests: null == requests ? _self._requests : requests // ignore: cast_nullable_to_non_nullable
as List<RequestMetric>,
  ));
}


}

// dart format on
