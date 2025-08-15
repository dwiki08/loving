// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aura.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Aura {

  String get name;

  String get count;

  /// Create a copy of Aura
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuraCopyWith<Aura> get copyWith =>
      _$AuraCopyWithImpl<Aura>(this as Aura, _$identity);

  /// Serializes this Aura to a JSON map.
  Map<String, dynamic> toJson();


  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Aura &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, count);

  @override
  String toString() {
    return 'Aura(name: $name, count: $count)';
  }


}

/// @nodoc
abstract mixin class $AuraCopyWith<$Res> {
  factory $AuraCopyWith(Aura value,
      $Res Function(Aura) _then) = _$AuraCopyWithImpl;

  @useResult
  $Res call({
    String name, String count
  });


}

/// @nodoc
class _$AuraCopyWithImpl<$Res>
    implements $AuraCopyWith<$Res> {
  _$AuraCopyWithImpl(this._self, this._then);

  final Aura _self;
  final $Res Function(Aura) _then;

  /// Create a copy of Aura
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? count = null,}) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
      as String,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
      as String,
    ));
  }

}


/// @nodoc
@JsonSerializable()
class _Aura implements Aura {
  const _Aura(this.name, this.count);

  factory _Aura.fromJson(Map<String, dynamic> json) => _$AuraFromJson(json);

  @override final String name;
  @override final String count;

  /// Create a copy of Aura
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuraCopyWith<_Aura> get copyWith =>
      __$AuraCopyWithImpl<_Aura>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuraToJson(this,);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Aura &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, count);

  @override
  String toString() {
    return 'Aura(name: $name, count: $count)';
  }


}

/// @nodoc
abstract mixin class _$AuraCopyWith<$Res> implements $AuraCopyWith<$Res> {
  factory _$AuraCopyWith(_Aura value,
      $Res Function(_Aura) _then) = __$AuraCopyWithImpl;

  @override
  @useResult
  $Res call({
    String name, String count
  });


}

/// @nodoc
class __$AuraCopyWithImpl<$Res>
    implements _$AuraCopyWith<$Res> {
  __$AuraCopyWithImpl(this._self, this._then);

  final _Aura _self;
  final $Res Function(_Aura) _then;

  /// Create a copy of Aura
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? name = null, Object? count = null,}) {
    return _then(_Aura(
      null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
      as String, null == count
        ? _self.count
        : count // ignore: cast_nullable_to_non_nullable
    as String,
    ));
  }


}

// dart format on
