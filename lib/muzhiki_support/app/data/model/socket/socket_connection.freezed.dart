// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'socket_connection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SocketConnectionModel {

 int get id; ChatType get type;@JsonKey(name: 'chat_id') int get chatId;@JsonKey(readValue: readAvatar) String? get avatar;// @JsonKey(name: 'deadline', fromJson: fromJsonDate)
 DateTime? get deadline; List<MessageModel> get messages; SocketConnectionChatStatus get status;@JsonKey(name: 'can_write') bool get canWrite;@JsonKey(name: 'created_at', fromJson: fromJsonDate) DateTime? get createdAt; String get title;@JsonKey(name: 'channel_id') int get channelId;@JsonKey(name: 'rated') bool get isRated;
/// Create a copy of SocketConnectionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocketConnectionModelCopyWith<SocketConnectionModel> get copyWith => _$SocketConnectionModelCopyWithImpl<SocketConnectionModel>(this as SocketConnectionModel, _$identity);

  /// Serializes this SocketConnectionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocketConnectionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.status, status) || other.status == status)&&(identical(other.canWrite, canWrite) || other.canWrite == canWrite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.isRated, isRated) || other.isRated == isRated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,chatId,avatar,deadline,const DeepCollectionEquality().hash(messages),status,canWrite,createdAt,title,channelId,isRated);

@override
String toString() {
  return 'SocketConnectionModel(id: $id, type: $type, chatId: $chatId, avatar: $avatar, deadline: $deadline, messages: $messages, status: $status, canWrite: $canWrite, createdAt: $createdAt, title: $title, channelId: $channelId, isRated: $isRated)';
}


}

/// @nodoc
abstract mixin class $SocketConnectionModelCopyWith<$Res>  {
  factory $SocketConnectionModelCopyWith(SocketConnectionModel value, $Res Function(SocketConnectionModel) _then) = _$SocketConnectionModelCopyWithImpl;
@useResult
$Res call({
 int id, ChatType type,@JsonKey(name: 'chat_id') int chatId,@JsonKey(readValue: readAvatar) String? avatar, DateTime? deadline, List<MessageModel> messages, SocketConnectionChatStatus status,@JsonKey(name: 'can_write') bool canWrite,@JsonKey(name: 'created_at', fromJson: fromJsonDate) DateTime? createdAt, String title,@JsonKey(name: 'channel_id') int channelId,@JsonKey(name: 'rated') bool isRated
});




}
/// @nodoc
class _$SocketConnectionModelCopyWithImpl<$Res>
    implements $SocketConnectionModelCopyWith<$Res> {
  _$SocketConnectionModelCopyWithImpl(this._self, this._then);

  final SocketConnectionModel _self;
  final $Res Function(SocketConnectionModel) _then;

/// Create a copy of SocketConnectionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? chatId = null,Object? avatar = freezed,Object? deadline = freezed,Object? messages = null,Object? status = null,Object? canWrite = null,Object? createdAt = freezed,Object? title = null,Object? channelId = null,Object? isRated = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatType,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SocketConnectionChatStatus,canWrite: null == canWrite ? _self.canWrite : canWrite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as int,isRated: null == isRated ? _self.isRated : isRated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SocketConnectionModel].
extension SocketConnectionModelPatterns on SocketConnectionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SocketConnectionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SocketConnectionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SocketConnectionModel value)  $default,){
final _that = this;
switch (_that) {
case _SocketConnectionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SocketConnectionModel value)?  $default,){
final _that = this;
switch (_that) {
case _SocketConnectionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  ChatType type, @JsonKey(name: 'chat_id')  int chatId, @JsonKey(readValue: readAvatar)  String? avatar,  DateTime? deadline,  List<MessageModel> messages,  SocketConnectionChatStatus status, @JsonKey(name: 'can_write')  bool canWrite, @JsonKey(name: 'created_at', fromJson: fromJsonDate)  DateTime? createdAt,  String title, @JsonKey(name: 'channel_id')  int channelId, @JsonKey(name: 'rated')  bool isRated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocketConnectionModel() when $default != null:
return $default(_that.id,_that.type,_that.chatId,_that.avatar,_that.deadline,_that.messages,_that.status,_that.canWrite,_that.createdAt,_that.title,_that.channelId,_that.isRated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  ChatType type, @JsonKey(name: 'chat_id')  int chatId, @JsonKey(readValue: readAvatar)  String? avatar,  DateTime? deadline,  List<MessageModel> messages,  SocketConnectionChatStatus status, @JsonKey(name: 'can_write')  bool canWrite, @JsonKey(name: 'created_at', fromJson: fromJsonDate)  DateTime? createdAt,  String title, @JsonKey(name: 'channel_id')  int channelId, @JsonKey(name: 'rated')  bool isRated)  $default,) {final _that = this;
switch (_that) {
case _SocketConnectionModel():
return $default(_that.id,_that.type,_that.chatId,_that.avatar,_that.deadline,_that.messages,_that.status,_that.canWrite,_that.createdAt,_that.title,_that.channelId,_that.isRated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  ChatType type, @JsonKey(name: 'chat_id')  int chatId, @JsonKey(readValue: readAvatar)  String? avatar,  DateTime? deadline,  List<MessageModel> messages,  SocketConnectionChatStatus status, @JsonKey(name: 'can_write')  bool canWrite, @JsonKey(name: 'created_at', fromJson: fromJsonDate)  DateTime? createdAt,  String title, @JsonKey(name: 'channel_id')  int channelId, @JsonKey(name: 'rated')  bool isRated)?  $default,) {final _that = this;
switch (_that) {
case _SocketConnectionModel() when $default != null:
return $default(_that.id,_that.type,_that.chatId,_that.avatar,_that.deadline,_that.messages,_that.status,_that.canWrite,_that.createdAt,_that.title,_that.channelId,_that.isRated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SocketConnectionModel implements SocketConnectionModel {
  const _SocketConnectionModel({required this.id, required this.type, @JsonKey(name: 'chat_id') required this.chatId, @JsonKey(readValue: readAvatar) this.avatar, this.deadline, final  List<MessageModel> messages = const [], required this.status, @JsonKey(name: 'can_write') required this.canWrite, @JsonKey(name: 'created_at', fromJson: fromJsonDate) this.createdAt, required this.title, @JsonKey(name: 'channel_id') required this.channelId, @JsonKey(name: 'rated') this.isRated = false}): _messages = messages;
  factory _SocketConnectionModel.fromJson(Map<String, dynamic> json) => _$SocketConnectionModelFromJson(json);

@override final  int id;
@override final  ChatType type;
@override@JsonKey(name: 'chat_id') final  int chatId;
@override@JsonKey(readValue: readAvatar) final  String? avatar;
// @JsonKey(name: 'deadline', fromJson: fromJsonDate)
@override final  DateTime? deadline;
 final  List<MessageModel> _messages;
@override@JsonKey() List<MessageModel> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override final  SocketConnectionChatStatus status;
@override@JsonKey(name: 'can_write') final  bool canWrite;
@override@JsonKey(name: 'created_at', fromJson: fromJsonDate) final  DateTime? createdAt;
@override final  String title;
@override@JsonKey(name: 'channel_id') final  int channelId;
@override@JsonKey(name: 'rated') final  bool isRated;

/// Create a copy of SocketConnectionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SocketConnectionModelCopyWith<_SocketConnectionModel> get copyWith => __$SocketConnectionModelCopyWithImpl<_SocketConnectionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SocketConnectionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocketConnectionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.status, status) || other.status == status)&&(identical(other.canWrite, canWrite) || other.canWrite == canWrite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.isRated, isRated) || other.isRated == isRated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,chatId,avatar,deadline,const DeepCollectionEquality().hash(_messages),status,canWrite,createdAt,title,channelId,isRated);

@override
String toString() {
  return 'SocketConnectionModel(id: $id, type: $type, chatId: $chatId, avatar: $avatar, deadline: $deadline, messages: $messages, status: $status, canWrite: $canWrite, createdAt: $createdAt, title: $title, channelId: $channelId, isRated: $isRated)';
}


}

/// @nodoc
abstract mixin class _$SocketConnectionModelCopyWith<$Res> implements $SocketConnectionModelCopyWith<$Res> {
  factory _$SocketConnectionModelCopyWith(_SocketConnectionModel value, $Res Function(_SocketConnectionModel) _then) = __$SocketConnectionModelCopyWithImpl;
@override @useResult
$Res call({
 int id, ChatType type,@JsonKey(name: 'chat_id') int chatId,@JsonKey(readValue: readAvatar) String? avatar, DateTime? deadline, List<MessageModel> messages, SocketConnectionChatStatus status,@JsonKey(name: 'can_write') bool canWrite,@JsonKey(name: 'created_at', fromJson: fromJsonDate) DateTime? createdAt, String title,@JsonKey(name: 'channel_id') int channelId,@JsonKey(name: 'rated') bool isRated
});




}
/// @nodoc
class __$SocketConnectionModelCopyWithImpl<$Res>
    implements _$SocketConnectionModelCopyWith<$Res> {
  __$SocketConnectionModelCopyWithImpl(this._self, this._then);

  final _SocketConnectionModel _self;
  final $Res Function(_SocketConnectionModel) _then;

/// Create a copy of SocketConnectionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? chatId = null,Object? avatar = freezed,Object? deadline = freezed,Object? messages = null,Object? status = null,Object? canWrite = null,Object? createdAt = freezed,Object? title = null,Object? channelId = null,Object? isRated = null,}) {
  return _then(_SocketConnectionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatType,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SocketConnectionChatStatus,canWrite: null == canWrite ? _self.canWrite : canWrite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as int,isRated: null == isRated ? _self.isRated : isRated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
