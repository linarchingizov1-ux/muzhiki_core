// // GENERATED CODE - DO NOT MODIFY BY HAND
// // coverage:ignore-file
// // ignore_for_file: type=lint
// // ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

// part of 'chat_cubit.dart';

// // **************************************************************************
// // FreezedGenerator
// // **************************************************************************

// // dart format off
// T _$identity<T>(T value) => value;
// /// @nodoc
// mixin _$ChatState {

//  MyChatModel? get myChat; int get chatPage; List<MessageModel> get messageChat; SocketConnectionModel? get socketConnection; int get selectedChannels; int? get channelId; List<ChatModel> get chats; StateStatus get chatStatus; AppException? get error;
// /// Create a copy of ChatState
// /// with the given fields replaced by the non-null parameter values.
// @JsonKey(includeFromJson: false, includeToJson: false)
// @pragma('vm:prefer-inline')
// $ChatStateCopyWith<ChatState> get copyWith => _$ChatStateCopyWithImpl<ChatState>(this as ChatState, _$identity);



// @override
// bool operator ==(Object other) {
//   return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatState&&(identical(other.myChat, myChat) || other.myChat == myChat)&&(identical(other.chatPage, chatPage) || other.chatPage == chatPage)&&const DeepCollectionEquality().equals(other.messageChat, messageChat)&&(identical(other.socketConnection, socketConnection) || other.socketConnection == socketConnection)&&(identical(other.selectedChannels, selectedChannels) || other.selectedChannels == selectedChannels)&&(identical(other.channelId, channelId) || other.channelId == channelId)&&const DeepCollectionEquality().equals(other.chats, chats)&&(identical(other.chatStatus, chatStatus) || other.chatStatus == chatStatus)&&(identical(other.error, error) || other.error == error));
// }


// @override
// int get hashCode => Object.hash(runtimeType,myChat,chatPage,const DeepCollectionEquality().hash(messageChat),socketConnection,selectedChannels,channelId,const DeepCollectionEquality().hash(chats),chatStatus,error);

// @override
// String toString() {
//   return 'ChatState(myChat: $myChat, chatPage: $chatPage, messageChat: $messageChat, socketConnection: $socketConnection, selectedChannels: $selectedChannels, channelId: $channelId, chats: $chats, chatStatus: $chatStatus, error: $error)';
// }


// }

// /// @nodoc
// abstract mixin class $ChatStateCopyWith<$Res>  {
//   factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) _then) = _$ChatStateCopyWithImpl;
// @useResult
// $Res call({
//  MyChatModel? myChat, int chatPage, List<MessageModel> messageChat, SocketConnectionModel? socketConnection, int selectedChannels, int? channelId, List<ChatModel> chats, StateStatus chatStatus, AppException? error
// });


// $SocketConnectionModelCopyWith<$Res>? get socketConnection;

// }
// /// @nodoc
// class _$ChatStateCopyWithImpl<$Res>
//     implements $ChatStateCopyWith<$Res> {
//   _$ChatStateCopyWithImpl(this._self, this._then);

//   final ChatState _self;
//   final $Res Function(ChatState) _then;

// /// Create a copy of ChatState
// /// with the given fields replaced by the non-null parameter values.
// @pragma('vm:prefer-inline') @override $Res call({Object? myChat = freezed,Object? chatPage = null,Object? messageChat = null,Object? socketConnection = freezed,Object? selectedChannels = null,Object? channelId = freezed,Object? chats = null,Object? chatStatus = null,Object? error = freezed,}) {
//   return _then(_self.copyWith(
// myChat: freezed == myChat ? _self.myChat : myChat // ignore: cast_nullable_to_non_nullable
// as MyChatModel?,chatPage: null == chatPage ? _self.chatPage : chatPage // ignore: cast_nullable_to_non_nullable
// as int,messageChat: null == messageChat ? _self.messageChat : messageChat // ignore: cast_nullable_to_non_nullable
// as List<MessageModel>,socketConnection: freezed == socketConnection ? _self.socketConnection : socketConnection // ignore: cast_nullable_to_non_nullable
// as SocketConnectionModel?,selectedChannels: null == selectedChannels ? _self.selectedChannels : selectedChannels // ignore: cast_nullable_to_non_nullable
// as int,channelId: freezed == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
// as int?,chats: null == chats ? _self.chats : chats // ignore: cast_nullable_to_non_nullable
// as List<ChatModel>,chatStatus: null == chatStatus ? _self.chatStatus : chatStatus // ignore: cast_nullable_to_non_nullable
// as StateStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
// as AppException?,
//   ));
// }
// /// Create a copy of ChatState
// /// with the given fields replaced by the non-null parameter values.
// @override
// @pragma('vm:prefer-inline')
// $SocketConnectionModelCopyWith<$Res>? get socketConnection {
//     if (_self.socketConnection == null) {
//     return null;
//   }

//   return $SocketConnectionModelCopyWith<$Res>(_self.socketConnection!, (value) {
//     return _then(_self.copyWith(socketConnection: value));
//   });
// }
// }


// /// Adds pattern-matching-related methods to [ChatState].
// extension ChatStatePatterns on ChatState {
// /// A variant of `map` that fallback to returning `orElse`.
// ///
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case final Subclass value:
// ///     return ...;
// ///   case _:
// ///     return orElse();
// /// }
// /// ```

// @optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatState value)?  $default,{required TResult orElse(),}){
// final _that = this;
// switch (_that) {
// case _ChatState() when $default != null:
// return $default(_that);case _:
//   return orElse();

// }
// }
// /// A `switch`-like method, using callbacks.
// ///
// /// Callbacks receives the raw object, upcasted.
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case final Subclass value:
// ///     return ...;
// ///   case final Subclass2 value:
// ///     return ...;
// /// }
// /// ```

// @optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatState value)  $default,){
// final _that = this;
// switch (_that) {
// case _ChatState():
// return $default(_that);case _:
//   throw StateError('Unexpected subclass');

// }
// }
// /// A variant of `map` that fallback to returning `null`.
// ///
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case final Subclass value:
// ///     return ...;
// ///   case _:
// ///     return null;
// /// }
// /// ```

// @optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatState value)?  $default,){
// final _that = this;
// switch (_that) {
// case _ChatState() when $default != null:
// return $default(_that);case _:
//   return null;

// }
// }
// /// A variant of `when` that fallback to an `orElse` callback.
// ///
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case Subclass(:final field):
// ///     return ...;
// ///   case _:
// ///     return orElse();
// /// }
// /// ```

// @optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MyChatModel? myChat,  int chatPage,  List<MessageModel> messageChat,  SocketConnectionModel? socketConnection,  int selectedChannels,  int? channelId,  List<ChatModel> chats,  StateStatus chatStatus,  AppException? error)?  $default,{required TResult orElse(),}) {final _that = this;
// switch (_that) {
// case _ChatState() when $default != null:
// return $default(_that.myChat,_that.chatPage,_that.messageChat,_that.socketConnection,_that.selectedChannels,_that.channelId,_that.chats,_that.chatStatus,_that.error);case _:
//   return orElse();

// }
// }
// /// A `switch`-like method, using callbacks.
// ///
// /// As opposed to `map`, this offers destructuring.
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case Subclass(:final field):
// ///     return ...;
// ///   case Subclass2(:final field2):
// ///     return ...;
// /// }
// /// ```

// @optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MyChatModel? myChat,  int chatPage,  List<MessageModel> messageChat,  SocketConnectionModel? socketConnection,  int selectedChannels,  int? channelId,  List<ChatModel> chats,  StateStatus chatStatus,  AppException? error)  $default,) {final _that = this;
// switch (_that) {
// case _ChatState():
// return $default(_that.myChat,_that.chatPage,_that.messageChat,_that.socketConnection,_that.selectedChannels,_that.channelId,_that.chats,_that.chatStatus,_that.error);case _:
//   throw StateError('Unexpected subclass');

// }
// }
// /// A variant of `when` that fallback to returning `null`
// ///
// /// It is equivalent to doing:
// /// ```dart
// /// switch (sealedClass) {
// ///   case Subclass(:final field):
// ///     return ...;
// ///   case _:
// ///     return null;
// /// }
// /// ```

// @optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MyChatModel? myChat,  int chatPage,  List<MessageModel> messageChat,  SocketConnectionModel? socketConnection,  int selectedChannels,  int? channelId,  List<ChatModel> chats,  StateStatus chatStatus,  AppException? error)?  $default,) {final _that = this;
// switch (_that) {
// case _ChatState() when $default != null:
// return $default(_that.myChat,_that.chatPage,_that.messageChat,_that.socketConnection,_that.selectedChannels,_that.channelId,_that.chats,_that.chatStatus,_that.error);case _:
//   return null;

// }
// }

// }

// /// @nodoc


// class _ChatState implements ChatState {
//   const _ChatState({this.myChat = null, this.chatPage = 1, final  List<MessageModel> messageChat = const [], this.socketConnection, this.selectedChannels = 0, this.channelId, final  List<ChatModel> chats = const [], this.chatStatus = StateStatus.loading, this.error}): _messageChat = messageChat,_chats = chats;
  

// @override@JsonKey() final  MyChatModel? myChat;
// @override@JsonKey() final  int chatPage;
//  final  List<MessageModel> _messageChat;
// @override@JsonKey() List<MessageModel> get messageChat {
//   if (_messageChat is EqualUnmodifiableListView) return _messageChat;
//   // ignore: implicit_dynamic_type
//   return EqualUnmodifiableListView(_messageChat);
// }

// @override final  SocketConnectionModel? socketConnection;
// @override@JsonKey() final  int selectedChannels;
// @override final  int? channelId;
//  final  List<ChatModel> _chats;
// @override@JsonKey() List<ChatModel> get chats {
//   if (_chats is EqualUnmodifiableListView) return _chats;
//   // ignore: implicit_dynamic_type
//   return EqualUnmodifiableListView(_chats);
// }

// @override@JsonKey() final  StateStatus chatStatus;
// @override final  AppException? error;

// /// Create a copy of ChatState
// /// with the given fields replaced by the non-null parameter values.
// @override @JsonKey(includeFromJson: false, includeToJson: false)
// @pragma('vm:prefer-inline')
// _$ChatStateCopyWith<_ChatState> get copyWith => __$ChatStateCopyWithImpl<_ChatState>(this, _$identity);



// @override
// bool operator ==(Object other) {
//   return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatState&&(identical(other.myChat, myChat) || other.myChat == myChat)&&(identical(other.chatPage, chatPage) || other.chatPage == chatPage)&&const DeepCollectionEquality().equals(other._messageChat, _messageChat)&&(identical(other.socketConnection, socketConnection) || other.socketConnection == socketConnection)&&(identical(other.selectedChannels, selectedChannels) || other.selectedChannels == selectedChannels)&&(identical(other.channelId, channelId) || other.channelId == channelId)&&const DeepCollectionEquality().equals(other._chats, _chats)&&(identical(other.chatStatus, chatStatus) || other.chatStatus == chatStatus)&&(identical(other.error, error) || other.error == error));
// }


// @override
// int get hashCode => Object.hash(runtimeType,myChat,chatPage,const DeepCollectionEquality().hash(_messageChat),socketConnection,selectedChannels,channelId,const DeepCollectionEquality().hash(_chats),chatStatus,error);

// @override
// String toString() {
//   return 'ChatState(myChat: $myChat, chatPage: $chatPage, messageChat: $messageChat, socketConnection: $socketConnection, selectedChannels: $selectedChannels, channelId: $channelId, chats: $chats, chatStatus: $chatStatus, error: $error)';
// }


// }

// /// @nodoc
// abstract mixin class _$ChatStateCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
//   factory _$ChatStateCopyWith(_ChatState value, $Res Function(_ChatState) _then) = __$ChatStateCopyWithImpl;
// @override @useResult
// $Res call({
//  MyChatModel? myChat, int chatPage, List<MessageModel> messageChat, SocketConnectionModel? socketConnection, int selectedChannels, int? channelId, List<ChatModel> chats, StateStatus chatStatus, AppException? error
// });


// @override $SocketConnectionModelCopyWith<$Res>? get socketConnection;

// }
// /// @nodoc
// class __$ChatStateCopyWithImpl<$Res>
//     implements _$ChatStateCopyWith<$Res> {
//   __$ChatStateCopyWithImpl(this._self, this._then);

//   final _ChatState _self;
//   final $Res Function(_ChatState) _then;

// /// Create a copy of ChatState
// /// with the given fields replaced by the non-null parameter values.
// @override @pragma('vm:prefer-inline') $Res call({Object? myChat = freezed,Object? chatPage = null,Object? messageChat = null,Object? socketConnection = freezed,Object? selectedChannels = null,Object? channelId = freezed,Object? chats = null,Object? chatStatus = null,Object? error = freezed,}) {
//   return _then(_ChatState(
// myChat: freezed == myChat ? _self.myChat : myChat // ignore: cast_nullable_to_non_nullable
// as MyChatModel?,chatPage: null == chatPage ? _self.chatPage : chatPage // ignore: cast_nullable_to_non_nullable
// as int,messageChat: null == messageChat ? _self._messageChat : messageChat // ignore: cast_nullable_to_non_nullable
// as List<MessageModel>,socketConnection: freezed == socketConnection ? _self.socketConnection : socketConnection // ignore: cast_nullable_to_non_nullable
// as SocketConnectionModel?,selectedChannels: null == selectedChannels ? _self.selectedChannels : selectedChannels // ignore: cast_nullable_to_non_nullable
// as int,channelId: freezed == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
// as int?,chats: null == chats ? _self._chats : chats // ignore: cast_nullable_to_non_nullable
// as List<ChatModel>,chatStatus: null == chatStatus ? _self.chatStatus : chatStatus // ignore: cast_nullable_to_non_nullable
// as StateStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
// as AppException?,
//   ));
// }

// /// Create a copy of ChatState
// /// with the given fields replaced by the non-null parameter values.
// @override
// @pragma('vm:prefer-inline')
// $SocketConnectionModelCopyWith<$Res>? get socketConnection {
//     if (_self.socketConnection == null) {
//     return null;
//   }

//   return $SocketConnectionModelCopyWith<$Res>(_self.socketConnection!, (value) {
//     return _then(_self.copyWith(socketConnection: value));
//   });
// }
// }

// // dart format on
