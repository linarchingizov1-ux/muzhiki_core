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
mixin _$OperatorModel {

 int get id; String get name; String? get avatar;
/// Create a copy of OperatorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OperatorModelCopyWith<OperatorModel> get copyWith => _$OperatorModelCopyWithImpl<OperatorModel>(this as OperatorModel, _$identity);

  /// Serializes this OperatorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OperatorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatar);

@override
String toString() {
  return 'OperatorModel(id: $id, name: $name, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class $OperatorModelCopyWith<$Res>  {
  factory $OperatorModelCopyWith(OperatorModel value, $Res Function(OperatorModel) _then) = _$OperatorModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? avatar
});




}
/// @nodoc
class _$OperatorModelCopyWithImpl<$Res>
    implements $OperatorModelCopyWith<$Res> {
  _$OperatorModelCopyWithImpl(this._self, this._then);

  final OperatorModel _self;
  final $Res Function(OperatorModel) _then;

/// Create a copy of OperatorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatar = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OperatorModel].
extension OperatorModelPatterns on OperatorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OperatorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OperatorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OperatorModel value)  $default,){
final _that = this;
switch (_that) {
case _OperatorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OperatorModel value)?  $default,){
final _that = this;
switch (_that) {
case _OperatorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? avatar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OperatorModel() when $default != null:
return $default(_that.id,_that.name,_that.avatar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? avatar)  $default,) {final _that = this;
switch (_that) {
case _OperatorModel():
return $default(_that.id,_that.name,_that.avatar);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? avatar)?  $default,) {final _that = this;
switch (_that) {
case _OperatorModel() when $default != null:
return $default(_that.id,_that.name,_that.avatar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OperatorModel implements OperatorModel {
  const _OperatorModel({required this.id, required this.name, this.avatar});
  factory _OperatorModel.fromJson(Map<String, dynamic> json) => _$OperatorModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? avatar;

/// Create a copy of OperatorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OperatorModelCopyWith<_OperatorModel> get copyWith => __$OperatorModelCopyWithImpl<_OperatorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OperatorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OperatorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatar);

@override
String toString() {
  return 'OperatorModel(id: $id, name: $name, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class _$OperatorModelCopyWith<$Res> implements $OperatorModelCopyWith<$Res> {
  factory _$OperatorModelCopyWith(_OperatorModel value, $Res Function(_OperatorModel) _then) = __$OperatorModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? avatar
});




}
/// @nodoc
class __$OperatorModelCopyWithImpl<$Res>
    implements _$OperatorModelCopyWith<$Res> {
  __$OperatorModelCopyWithImpl(this._self, this._then);

  final _OperatorModel _self;
  final $Res Function(_OperatorModel) _then;

/// Create a copy of OperatorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatar = freezed,}) {
  return _then(_OperatorModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SocketConnectionModel {

 int get id; ChatType get type;@JsonKey(name: 'chat_id') int get chatId;@JsonKey(name: 'operator') List<OperatorModel> get operators; DateTime? get deadline; List<MessageModel> get messages; SocketConnectionChatStatus get status;@JsonKey(name: 'can_write') bool get canWrite;@JsonKey(name: 'created_at', fromJson: fromJsonDate) DateTime? get createdAt; String get title;@JsonKey(name: 'channel_id') int get channelId;@JsonKey(name: 'rated') bool get isRated;
/// Create a copy of SocketConnectionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocketConnectionModelCopyWith<SocketConnectionModel> get copyWith => _$SocketConnectionModelCopyWithImpl<SocketConnectionModel>(this as SocketConnectionModel, _$identity);

  /// Serializes this SocketConnectionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocketConnectionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&const DeepCollectionEquality().equals(other.operators, operators)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.status, status) || other.status == status)&&(identical(other.canWrite, canWrite) || other.canWrite == canWrite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.isRated, isRated) || other.isRated == isRated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,chatId,const DeepCollectionEquality().hash(operators),deadline,const DeepCollectionEquality().hash(messages),status,canWrite,createdAt,title,channelId,isRated);

@override
String toString() {
  return 'SocketConnectionModel(id: $id, type: $type, chatId: $chatId, operators: $operators, deadline: $deadline, messages: $messages, status: $status, canWrite: $canWrite, createdAt: $createdAt, title: $title, channelId: $channelId, isRated: $isRated)';
}


}

/// @nodoc
abstract mixin class $SocketConnectionModelCopyWith<$Res>  {
  factory $SocketConnectionModelCopyWith(SocketConnectionModel value, $Res Function(SocketConnectionModel) _then) = _$SocketConnectionModelCopyWithImpl;
@useResult
$Res call({
 int id, ChatType type,@JsonKey(name: 'chat_id') int chatId,@JsonKey(name: 'operator') List<OperatorModel> operators, DateTime? deadline, List<MessageModel> messages, SocketConnectionChatStatus status,@JsonKey(name: 'can_write') bool canWrite,@JsonKey(name: 'created_at', fromJson: fromJsonDate) DateTime? createdAt, String title,@JsonKey(name: 'channel_id') int channelId,@JsonKey(name: 'rated') bool isRated
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? chatId = null,Object? operators = null,Object? deadline = freezed,Object? messages = null,Object? status = null,Object? canWrite = null,Object? createdAt = freezed,Object? title = null,Object? channelId = null,Object? isRated = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatType,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,operators: null == operators ? _self.operators : operators // ignore: cast_nullable_to_non_nullable
as List<OperatorModel>,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  ChatType type, @JsonKey(name: 'chat_id')  int chatId, @JsonKey(name: 'operator')  List<OperatorModel> operators,  DateTime? deadline,  List<MessageModel> messages,  SocketConnectionChatStatus status, @JsonKey(name: 'can_write')  bool canWrite, @JsonKey(name: 'created_at', fromJson: fromJsonDate)  DateTime? createdAt,  String title, @JsonKey(name: 'channel_id')  int channelId, @JsonKey(name: 'rated')  bool isRated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocketConnectionModel() when $default != null:
return $default(_that.id,_that.type,_that.chatId,_that.operators,_that.deadline,_that.messages,_that.status,_that.canWrite,_that.createdAt,_that.title,_that.channelId,_that.isRated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  ChatType type, @JsonKey(name: 'chat_id')  int chatId, @JsonKey(name: 'operator')  List<OperatorModel> operators,  DateTime? deadline,  List<MessageModel> messages,  SocketConnectionChatStatus status, @JsonKey(name: 'can_write')  bool canWrite, @JsonKey(name: 'created_at', fromJson: fromJsonDate)  DateTime? createdAt,  String title, @JsonKey(name: 'channel_id')  int channelId, @JsonKey(name: 'rated')  bool isRated)  $default,) {final _that = this;
switch (_that) {
case _SocketConnectionModel():
return $default(_that.id,_that.type,_that.chatId,_that.operators,_that.deadline,_that.messages,_that.status,_that.canWrite,_that.createdAt,_that.title,_that.channelId,_that.isRated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  ChatType type, @JsonKey(name: 'chat_id')  int chatId, @JsonKey(name: 'operator')  List<OperatorModel> operators,  DateTime? deadline,  List<MessageModel> messages,  SocketConnectionChatStatus status, @JsonKey(name: 'can_write')  bool canWrite, @JsonKey(name: 'created_at', fromJson: fromJsonDate)  DateTime? createdAt,  String title, @JsonKey(name: 'channel_id')  int channelId, @JsonKey(name: 'rated')  bool isRated)?  $default,) {final _that = this;
switch (_that) {
case _SocketConnectionModel() when $default != null:
return $default(_that.id,_that.type,_that.chatId,_that.operators,_that.deadline,_that.messages,_that.status,_that.canWrite,_that.createdAt,_that.title,_that.channelId,_that.isRated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SocketConnectionModel implements SocketConnectionModel {
  const _SocketConnectionModel({required this.id, required this.type, @JsonKey(name: 'chat_id') required this.chatId, @JsonKey(name: 'operator') final  List<OperatorModel> operators = const [], this.deadline, final  List<MessageModel> messages = const [], required this.status, @JsonKey(name: 'can_write') required this.canWrite, @JsonKey(name: 'created_at', fromJson: fromJsonDate) this.createdAt, required this.title, @JsonKey(name: 'channel_id') required this.channelId, @JsonKey(name: 'rated') this.isRated = false}): _operators = operators,_messages = messages;
  factory _SocketConnectionModel.fromJson(Map<String, dynamic> json) => _$SocketConnectionModelFromJson(json);

@override final  int id;
@override final  ChatType type;
@override@JsonKey(name: 'chat_id') final  int chatId;
 final  List<OperatorModel> _operators;
@override@JsonKey(name: 'operator') List<OperatorModel> get operators {
  if (_operators is EqualUnmodifiableListView) return _operators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_operators);
}

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocketConnectionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&const DeepCollectionEquality().equals(other._operators, _operators)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.status, status) || other.status == status)&&(identical(other.canWrite, canWrite) || other.canWrite == canWrite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.isRated, isRated) || other.isRated == isRated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,chatId,const DeepCollectionEquality().hash(_operators),deadline,const DeepCollectionEquality().hash(_messages),status,canWrite,createdAt,title,channelId,isRated);

@override
String toString() {
  return 'SocketConnectionModel(id: $id, type: $type, chatId: $chatId, operators: $operators, deadline: $deadline, messages: $messages, status: $status, canWrite: $canWrite, createdAt: $createdAt, title: $title, channelId: $channelId, isRated: $isRated)';
}


}

/// @nodoc
abstract mixin class _$SocketConnectionModelCopyWith<$Res> implements $SocketConnectionModelCopyWith<$Res> {
  factory _$SocketConnectionModelCopyWith(_SocketConnectionModel value, $Res Function(_SocketConnectionModel) _then) = __$SocketConnectionModelCopyWithImpl;
@override @useResult
$Res call({
 int id, ChatType type,@JsonKey(name: 'chat_id') int chatId,@JsonKey(name: 'operator') List<OperatorModel> operators, DateTime? deadline, List<MessageModel> messages, SocketConnectionChatStatus status,@JsonKey(name: 'can_write') bool canWrite,@JsonKey(name: 'created_at', fromJson: fromJsonDate) DateTime? createdAt, String title,@JsonKey(name: 'channel_id') int channelId,@JsonKey(name: 'rated') bool isRated
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? chatId = null,Object? operators = null,Object? deadline = freezed,Object? messages = null,Object? status = null,Object? canWrite = null,Object? createdAt = freezed,Object? title = null,Object? channelId = null,Object? isRated = null,}) {
  return _then(_SocketConnectionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChatType,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,operators: null == operators ? _self._operators : operators // ignore: cast_nullable_to_non_nullable
as List<OperatorModel>,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
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


/// @nodoc
mixin _$MessageModel {

 String get id;@JsonKey(name: 'created_at', fromJson: _fromJsonDate) DateTime? get createdAt; MessageStatus? get status; String get text; MessageType get type;@JsonKey(name: 'operator_name') String? get name; List<AttachmentsModel> get attachments;
/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageModelCopyWith<MessageModel> get copyWith => _$MessageModelCopyWithImpl<MessageModel>(this as MessageModel, _$identity);

  /// Serializes this MessageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.text, text) || other.text == text)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.attachments, attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,status,text,type,name,const DeepCollectionEquality().hash(attachments));

@override
String toString() {
  return 'MessageModel(id: $id, createdAt: $createdAt, status: $status, text: $text, type: $type, name: $name, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class $MessageModelCopyWith<$Res>  {
  factory $MessageModelCopyWith(MessageModel value, $Res Function(MessageModel) _then) = _$MessageModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'created_at', fromJson: _fromJsonDate) DateTime? createdAt, MessageStatus? status, String text, MessageType type,@JsonKey(name: 'operator_name') String? name, List<AttachmentsModel> attachments
});




}
/// @nodoc
class _$MessageModelCopyWithImpl<$Res>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._self, this._then);

  final MessageModel _self;
  final $Res Function(MessageModel) _then;

/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = freezed,Object? status = freezed,Object? text = null,Object? type = null,Object? name = freezed,Object? attachments = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MessageStatus?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<AttachmentsModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageModel].
extension MessageModelPatterns on MessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageModel value)  $default,){
final _that = this;
switch (_that) {
case _MessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'created_at', fromJson: _fromJsonDate)  DateTime? createdAt,  MessageStatus? status,  String text,  MessageType type, @JsonKey(name: 'operator_name')  String? name,  List<AttachmentsModel> attachments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
return $default(_that.id,_that.createdAt,_that.status,_that.text,_that.type,_that.name,_that.attachments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'created_at', fromJson: _fromJsonDate)  DateTime? createdAt,  MessageStatus? status,  String text,  MessageType type, @JsonKey(name: 'operator_name')  String? name,  List<AttachmentsModel> attachments)  $default,) {final _that = this;
switch (_that) {
case _MessageModel():
return $default(_that.id,_that.createdAt,_that.status,_that.text,_that.type,_that.name,_that.attachments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'created_at', fromJson: _fromJsonDate)  DateTime? createdAt,  MessageStatus? status,  String text,  MessageType type, @JsonKey(name: 'operator_name')  String? name,  List<AttachmentsModel> attachments)?  $default,) {final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
return $default(_that.id,_that.createdAt,_that.status,_that.text,_that.type,_that.name,_that.attachments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageModel implements MessageModel {
  const _MessageModel({required this.id, @JsonKey(name: 'created_at', fromJson: _fromJsonDate) this.createdAt, this.status, required this.text, this.type = MessageType.client, @JsonKey(name: 'operator_name') this.name, final  List<AttachmentsModel> attachments = const []}): _attachments = attachments;
  factory _MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'created_at', fromJson: _fromJsonDate) final  DateTime? createdAt;
@override final  MessageStatus? status;
@override final  String text;
@override@JsonKey() final  MessageType type;
@override@JsonKey(name: 'operator_name') final  String? name;
 final  List<AttachmentsModel> _attachments;
@override@JsonKey() List<AttachmentsModel> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}


/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageModelCopyWith<_MessageModel> get copyWith => __$MessageModelCopyWithImpl<_MessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.text, text) || other.text == text)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._attachments, _attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,status,text,type,name,const DeepCollectionEquality().hash(_attachments));

@override
String toString() {
  return 'MessageModel(id: $id, createdAt: $createdAt, status: $status, text: $text, type: $type, name: $name, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class _$MessageModelCopyWith<$Res> implements $MessageModelCopyWith<$Res> {
  factory _$MessageModelCopyWith(_MessageModel value, $Res Function(_MessageModel) _then) = __$MessageModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'created_at', fromJson: _fromJsonDate) DateTime? createdAt, MessageStatus? status, String text, MessageType type,@JsonKey(name: 'operator_name') String? name, List<AttachmentsModel> attachments
});




}
/// @nodoc
class __$MessageModelCopyWithImpl<$Res>
    implements _$MessageModelCopyWith<$Res> {
  __$MessageModelCopyWithImpl(this._self, this._then);

  final _MessageModel _self;
  final $Res Function(_MessageModel) _then;

/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = freezed,Object? status = freezed,Object? text = null,Object? type = null,Object? name = freezed,Object? attachments = null,}) {
  return _then(_MessageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MessageStatus?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<AttachmentsModel>,
  ));
}


}

// dart format on
