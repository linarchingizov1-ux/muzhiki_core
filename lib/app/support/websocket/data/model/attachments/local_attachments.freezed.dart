// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_attachments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalAttachmentsModel {

 String get id; ChatAttachmentType get type;
/// Create a copy of LocalAttachmentsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalAttachmentsModelCopyWith<LocalAttachmentsModel> get copyWith => _$LocalAttachmentsModelCopyWithImpl<LocalAttachmentsModel>(this as LocalAttachmentsModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalAttachmentsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,id,type);

@override
String toString() {
  return 'LocalAttachmentsModel(id: $id, type: $type)';
}


}

/// @nodoc
abstract mixin class $LocalAttachmentsModelCopyWith<$Res>  {
  factory $LocalAttachmentsModelCopyWith(LocalAttachmentsModel value, $Res Function(LocalAttachmentsModel) _then) = _$LocalAttachmentsModelCopyWithImpl;
@useResult
$Res call({
 String id, ChatAttachmentType type
});




}
/// @nodoc
class _$LocalAttachmentsModelCopyWithImpl<$Res>
    implements $LocalAttachmentsModelCopyWith<$Res> {
  _$LocalAttachmentsModelCopyWithImpl(this._self, this._then);

  final LocalAttachmentsModel _self;
  final $Res Function(LocalAttachmentsModel) _then;

/// Create a copy of LocalAttachmentsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatAttachmentType,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalAttachmentsModel].
extension LocalAttachmentsModelPatterns on LocalAttachmentsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LocalAttachmentViewItem value)?  local,TResult Function( _RemoteAttachmentViewItem value)?  remote,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalAttachmentViewItem() when local != null:
return local(_that);case _RemoteAttachmentViewItem() when remote != null:
return remote(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LocalAttachmentViewItem value)  local,required TResult Function( _RemoteAttachmentViewItem value)  remote,}){
final _that = this;
switch (_that) {
case _LocalAttachmentViewItem():
return local(_that);case _RemoteAttachmentViewItem():
return remote(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LocalAttachmentViewItem value)?  local,TResult? Function( _RemoteAttachmentViewItem value)?  remote,}){
final _that = this;
switch (_that) {
case _LocalAttachmentViewItem() when local != null:
return local(_that);case _RemoteAttachmentViewItem() when remote != null:
return remote(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  ChatAttachmentType type,  String path,  bool isLoading)?  local,TResult Function( String id,  ChatAttachmentType type,  UploadDataModel data)?  remote,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalAttachmentViewItem() when local != null:
return local(_that.id,_that.type,_that.path,_that.isLoading);case _RemoteAttachmentViewItem() when remote != null:
return remote(_that.id,_that.type,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  ChatAttachmentType type,  String path,  bool isLoading)  local,required TResult Function( String id,  ChatAttachmentType type,  UploadDataModel data)  remote,}) {final _that = this;
switch (_that) {
case _LocalAttachmentViewItem():
return local(_that.id,_that.type,_that.path,_that.isLoading);case _RemoteAttachmentViewItem():
return remote(_that.id,_that.type,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  ChatAttachmentType type,  String path,  bool isLoading)?  local,TResult? Function( String id,  ChatAttachmentType type,  UploadDataModel data)?  remote,}) {final _that = this;
switch (_that) {
case _LocalAttachmentViewItem() when local != null:
return local(_that.id,_that.type,_that.path,_that.isLoading);case _RemoteAttachmentViewItem() when remote != null:
return remote(_that.id,_that.type,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _LocalAttachmentViewItem extends LocalAttachmentsModel {
  const _LocalAttachmentViewItem({required this.id, required this.type, required this.path, this.isLoading = true}): super._();
  

@override final  String id;
@override final  ChatAttachmentType type;
 final  String path;
@JsonKey() final  bool isLoading;

/// Create a copy of LocalAttachmentsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalAttachmentViewItemCopyWith<_LocalAttachmentViewItem> get copyWith => __$LocalAttachmentViewItemCopyWithImpl<_LocalAttachmentViewItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalAttachmentViewItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.path, path) || other.path == path)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,path,isLoading);

@override
String toString() {
  return 'LocalAttachmentsModel.local(id: $id, type: $type, path: $path, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$LocalAttachmentViewItemCopyWith<$Res> implements $LocalAttachmentsModelCopyWith<$Res> {
  factory _$LocalAttachmentViewItemCopyWith(_LocalAttachmentViewItem value, $Res Function(_LocalAttachmentViewItem) _then) = __$LocalAttachmentViewItemCopyWithImpl;
@override @useResult
$Res call({
 String id, ChatAttachmentType type, String path, bool isLoading
});




}
/// @nodoc
class __$LocalAttachmentViewItemCopyWithImpl<$Res>
    implements _$LocalAttachmentViewItemCopyWith<$Res> {
  __$LocalAttachmentViewItemCopyWithImpl(this._self, this._then);

  final _LocalAttachmentViewItem _self;
  final $Res Function(_LocalAttachmentViewItem) _then;

/// Create a copy of LocalAttachmentsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? path = null,Object? isLoading = null,}) {
  return _then(_LocalAttachmentViewItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatAttachmentType,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _RemoteAttachmentViewItem extends LocalAttachmentsModel {
  const _RemoteAttachmentViewItem({required this.id, required this.type, required this.data}): super._();
  

@override final  String id;
@override final  ChatAttachmentType type;
 final  UploadDataModel data;

/// Create a copy of LocalAttachmentsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteAttachmentViewItemCopyWith<_RemoteAttachmentViewItem> get copyWith => __$RemoteAttachmentViewItemCopyWithImpl<_RemoteAttachmentViewItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteAttachmentViewItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,data);

@override
String toString() {
  return 'LocalAttachmentsModel.remote(id: $id, type: $type, data: $data)';
}


}

/// @nodoc
abstract mixin class _$RemoteAttachmentViewItemCopyWith<$Res> implements $LocalAttachmentsModelCopyWith<$Res> {
  factory _$RemoteAttachmentViewItemCopyWith(_RemoteAttachmentViewItem value, $Res Function(_RemoteAttachmentViewItem) _then) = __$RemoteAttachmentViewItemCopyWithImpl;
@override @useResult
$Res call({
 String id, ChatAttachmentType type, UploadDataModel data
});




}
/// @nodoc
class __$RemoteAttachmentViewItemCopyWithImpl<$Res>
    implements _$RemoteAttachmentViewItemCopyWith<$Res> {
  __$RemoteAttachmentViewItemCopyWithImpl(this._self, this._then);

  final _RemoteAttachmentViewItem _self;
  final $Res Function(_RemoteAttachmentViewItem) _then;

/// Create a copy of LocalAttachmentsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? data = null,}) {
  return _then(_RemoteAttachmentViewItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatAttachmentType,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UploadDataModel,
  ));
}


}

// dart format on
