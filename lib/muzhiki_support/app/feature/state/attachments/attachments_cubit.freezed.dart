// // GENERATED CODE - DO NOT MODIFY BY HAND
// // coverage:ignore-file
// // ignore_for_file: type=lint
// // ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

// part of 'attachments_cubit.dart';

// // **************************************************************************
// // FreezedGenerator
// // **************************************************************************

// // dart format off
// T _$identity<T>(T value) => value;
// /// @nodoc
// mixin _$AttachmentsState {

//  List<LocalAttachmentsModel> get items; double get progress; AttachmentProcessStage get stage;
// /// Create a copy of AttachmentsState
// /// with the given fields replaced by the non-null parameter values.
// @JsonKey(includeFromJson: false, includeToJson: false)
// @pragma('vm:prefer-inline')
// $AttachmentsStateCopyWith<AttachmentsState> get copyWith => _$AttachmentsStateCopyWithImpl<AttachmentsState>(this as AttachmentsState, _$identity);



// @override
// bool operator ==(Object other) {
//   return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachmentsState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.stage, stage) || other.stage == stage));
// }


// @override
// int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),progress,stage);

// @override
// String toString() {
//   return 'AttachmentsState(items: $items, progress: $progress, stage: $stage)';
// }


// }

// /// @nodoc
// abstract mixin class $AttachmentsStateCopyWith<$Res>  {
//   factory $AttachmentsStateCopyWith(AttachmentsState value, $Res Function(AttachmentsState) _then) = _$AttachmentsStateCopyWithImpl;
// @useResult
// $Res call({
//  List<LocalAttachmentsModel> items, double progress, AttachmentProcessStage stage
// });




// }
// /// @nodoc
// class _$AttachmentsStateCopyWithImpl<$Res>
//     implements $AttachmentsStateCopyWith<$Res> {
//   _$AttachmentsStateCopyWithImpl(this._self, this._then);

//   final AttachmentsState _self;
//   final $Res Function(AttachmentsState) _then;

// /// Create a copy of AttachmentsState
// /// with the given fields replaced by the non-null parameter values.
// @pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? progress = null,Object? stage = null,}) {
//   return _then(_self.copyWith(
// items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
// as List<LocalAttachmentsModel>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
// as double,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
// as AttachmentProcessStage,
//   ));
// }

// }


// /// Adds pattern-matching-related methods to [AttachmentsState].
// extension AttachmentsStatePatterns on AttachmentsState {
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

// @optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachmentsState value)?  $default,{required TResult orElse(),}){
// final _that = this;
// switch (_that) {
// case _AttachmentsState() when $default != null:
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

// @optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachmentsState value)  $default,){
// final _that = this;
// switch (_that) {
// case _AttachmentsState():
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

// @optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachmentsState value)?  $default,){
// final _that = this;
// switch (_that) {
// case _AttachmentsState() when $default != null:
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

// @optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LocalAttachmentsModel> items,  double progress,  AttachmentProcessStage stage)?  $default,{required TResult orElse(),}) {final _that = this;
// switch (_that) {
// case _AttachmentsState() when $default != null:
// return $default(_that.items,_that.progress,_that.stage);case _:
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

// @optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LocalAttachmentsModel> items,  double progress,  AttachmentProcessStage stage)  $default,) {final _that = this;
// switch (_that) {
// case _AttachmentsState():
// return $default(_that.items,_that.progress,_that.stage);case _:
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

// @optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LocalAttachmentsModel> items,  double progress,  AttachmentProcessStage stage)?  $default,) {final _that = this;
// switch (_that) {
// case _AttachmentsState() when $default != null:
// return $default(_that.items,_that.progress,_that.stage);case _:
//   return null;

// }
// }

// }

// /// @nodoc


// class _AttachmentsState implements AttachmentsState {
//   const _AttachmentsState({final  List<LocalAttachmentsModel> items = const [], this.progress = 0.0, this.stage = AttachmentProcessStage.idle}): _items = items;
  

//  final  List<LocalAttachmentsModel> _items;
// @override@JsonKey() List<LocalAttachmentsModel> get items {
//   if (_items is EqualUnmodifiableListView) return _items;
//   // ignore: implicit_dynamic_type
//   return EqualUnmodifiableListView(_items);
// }

// @override@JsonKey() final  double progress;
// @override@JsonKey() final  AttachmentProcessStage stage;

// /// Create a copy of AttachmentsState
// /// with the given fields replaced by the non-null parameter values.
// @override @JsonKey(includeFromJson: false, includeToJson: false)
// @pragma('vm:prefer-inline')
// _$AttachmentsStateCopyWith<_AttachmentsState> get copyWith => __$AttachmentsStateCopyWithImpl<_AttachmentsState>(this, _$identity);



// @override
// bool operator ==(Object other) {
//   return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachmentsState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.stage, stage) || other.stage == stage));
// }


// @override
// int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),progress,stage);

// @override
// String toString() {
//   return 'AttachmentsState(items: $items, progress: $progress, stage: $stage)';
// }


// }

// /// @nodoc
// abstract mixin class _$AttachmentsStateCopyWith<$Res> implements $AttachmentsStateCopyWith<$Res> {
//   factory _$AttachmentsStateCopyWith(_AttachmentsState value, $Res Function(_AttachmentsState) _then) = __$AttachmentsStateCopyWithImpl;
// @override @useResult
// $Res call({
//  List<LocalAttachmentsModel> items, double progress, AttachmentProcessStage stage
// });




// }
// /// @nodoc
// class __$AttachmentsStateCopyWithImpl<$Res>
//     implements _$AttachmentsStateCopyWith<$Res> {
//   __$AttachmentsStateCopyWithImpl(this._self, this._then);

//   final _AttachmentsState _self;
//   final $Res Function(_AttachmentsState) _then;

// /// Create a copy of AttachmentsState
// /// with the given fields replaced by the non-null parameter values.
// @override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? progress = null,Object? stage = null,}) {
//   return _then(_AttachmentsState(
// items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
// as List<LocalAttachmentsModel>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
// as double,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
// as AttachmentProcessStage,
//   ));
// }


// }

// // dart format on
