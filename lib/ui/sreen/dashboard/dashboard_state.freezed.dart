// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardState {

  bool get isRunning;

  bool get showDebug;

  ErrorResult? get error;

  List<BasePreset> get presets;

  BasePreset? get selectedPreset;

  Player? get player;

  AreaMap? get map;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DashboardStateCopyWith<DashboardState> get copyWith =>
      _$DashboardStateCopyWithImpl<DashboardState>(
          this as DashboardState, _$identity);


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DashboardState &&
            (identical(other.isRunning, isRunning) ||
                other.isRunning == isRunning) &&
            (identical(other.showDebug, showDebug) ||
                other.showDebug == showDebug) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(other.presets, presets) &&
            (identical(other.selectedPreset, selectedPreset) ||
                other.selectedPreset == selectedPreset) &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.map, map) || other.map == map));
  }


  @override
  int get hashCode =>
      Object.hash(
          runtimeType,
          isRunning,
          showDebug,
          error,
          const DeepCollectionEquality().hash(presets),
          selectedPreset,
          player,
          map);

  @override
  String toString() {
    return 'DashboardState(isRunning: $isRunning, showDebug: $showDebug, error: $error, presets: $presets, selectedPreset: $selectedPreset, player: $player, map: $map)';
  }


}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res> {
  factory $DashboardStateCopyWith(DashboardState value,
      $Res Function(DashboardState) _then) = _$DashboardStateCopyWithImpl;

  @useResult
  $Res call({
    bool isRunning, bool showDebug, ErrorResult? error, List<
        BasePreset> presets, BasePreset? selectedPreset, Player? player, AreaMap? map
  });


}

/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call(
      {Object? isRunning = null, Object? showDebug = null, Object? error = freezed, Object? presets = null, Object? selectedPreset = freezed, Object? player = freezed, Object? map = freezed,}) {
    return _then(_self.copyWith(
      isRunning: null == isRunning
          ? _self.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
      as bool,
      showDebug: null == showDebug
          ? _self.showDebug
          : showDebug // ignore: cast_nullable_to_non_nullable
      as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
      as ErrorResult?,
      presets: null == presets
          ? _self.presets
          : presets // ignore: cast_nullable_to_non_nullable
      as List<BasePreset>,
      selectedPreset: freezed == selectedPreset
          ? _self.selectedPreset
          : selectedPreset // ignore: cast_nullable_to_non_nullable
      as BasePreset?,
      player: freezed == player
          ? _self.player
          : player // ignore: cast_nullable_to_non_nullable
      as Player?,
      map: freezed == map
          ? _self.map
          : map // ignore: cast_nullable_to_non_nullable
      as AreaMap?,
    ));
  }

}


/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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

  @optionalTypeArgs TResult maybeMap

  <

  TResult

  extends

  Object?

  >

  (

  TResult Function( _DashboardState value)? $default,{required TResult orElse(),}){
  final _that = this;
  switch (_that) {
  case _DashboardState() when $default != null:
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

  @optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardState value) $default,){
  final _that = this;
  switch (_that) {
  case _DashboardState():
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

  @optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardState value)? $default,){
  final _that = this;
  switch (_that) {
  case _DashboardState() when $default != null:
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

  @optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isRunning, bool showDebug, ErrorResult? error, List<BasePreset> presets, BasePreset? selectedPreset, Player? player, AreaMap? map)? $default,{required TResult orElse(),}) {final _that = this;
  switch (_that) {
  case _DashboardState() when $default != null:
  return $default(_that.isRunning,_that.showDebug,_that.error,_that.presets,_that.selectedPreset,_that.player,_that.map);case _:
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

  @optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isRunning, bool showDebug, ErrorResult? error, List<BasePreset> presets, BasePreset? selectedPreset, Player? player, AreaMap? map) $default,) {final _that = this;
  switch (_that) {
  case _DashboardState():
  return $default(_that.isRunning,_that.showDebug,_that.error,_that.presets,_that.selectedPreset,_that.player,_that.map);case _:
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

  @optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isRunning, bool showDebug, ErrorResult? error, List<BasePreset> presets, BasePreset? selectedPreset, Player? player, AreaMap? map)? $default,) {final _that = this;
  switch (_that) {
  case _DashboardState() when $default != null:
  return $default(_that.isRunning,_that.showDebug,_that.error,_that.presets,_that.selectedPreset,_that.player,_that.map);case _:
  return null;

  }
  }

}

/// @nodoc


class _DashboardState implements DashboardState {
  const _DashboardState(
      {this.isRunning = false, this.showDebug = false, this.error, final List<
          BasePreset> presets = const [
      ], this.selectedPreset, this.player, this.map}) : _presets = presets;


  @override
  @JsonKey()
  final bool isRunning;
  @override
  @JsonKey()
  final bool showDebug;
  @override final ErrorResult? error;
  final List<BasePreset> _presets;

  @override
  @JsonKey()
  List<BasePreset> get presets {
    if (_presets is EqualUnmodifiableListView) return _presets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_presets);
  }

  @override final BasePreset? selectedPreset;
  @override final Player? player;
  @override final AreaMap? map;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DashboardStateCopyWith<_DashboardState> get copyWith =>
      __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _DashboardState &&
            (identical(other.isRunning, isRunning) ||
                other.isRunning == isRunning) &&
            (identical(other.showDebug, showDebug) ||
                other.showDebug == showDebug) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(other._presets, _presets) &&
            (identical(other.selectedPreset, selectedPreset) ||
                other.selectedPreset == selectedPreset) &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.map, map) || other.map == map));
  }


  @override
  int get hashCode =>
      Object.hash(
          runtimeType,
          isRunning,
          showDebug,
          error,
          const DeepCollectionEquality().hash(_presets),
          selectedPreset,
          player,
          map);

  @override
  String toString() {
    return 'DashboardState(isRunning: $isRunning, showDebug: $showDebug, error: $error, presets: $presets, selectedPreset: $selectedPreset, player: $player, map: $map)';
  }


}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res>
    implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(_DashboardState value,
      $Res Function(_DashboardState) _then) = __$DashboardStateCopyWithImpl;

  @override
  @useResult
  $Res call({
    bool isRunning, bool showDebug, ErrorResult? error, List<
        BasePreset> presets, BasePreset? selectedPreset, Player? player, AreaMap? map
  });


}

/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

  /// Create a copy of DashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call(
      {Object? isRunning = null, Object? showDebug = null, Object? error = freezed, Object? presets = null, Object? selectedPreset = freezed, Object? player = freezed, Object? map = freezed,}) {
    return _then(_DashboardState(
      isRunning: null == isRunning
          ? _self.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
      as bool,
      showDebug: null == showDebug
          ? _self.showDebug
          : showDebug // ignore: cast_nullable_to_non_nullable
      as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
      as ErrorResult?,
      presets: null == presets
          ? _self._presets
          : presets // ignore: cast_nullable_to_non_nullable
      as List<BasePreset>,
      selectedPreset: freezed == selectedPreset
          ? _self.selectedPreset
          : selectedPreset // ignore: cast_nullable_to_non_nullable
      as BasePreset?,
      player: freezed == player
          ? _self.player
          : player // ignore: cast_nullable_to_non_nullable
      as Player?,
      map: freezed == map
          ? _self.map
          : map // ignore: cast_nullable_to_non_nullable
      as AreaMap?,
    ));
  }


}

// dart format on
