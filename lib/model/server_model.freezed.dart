// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServerModel {

 String get sName; String get sIP; int get iPort;
/// Create a copy of ServerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerModelCopyWith<ServerModel> get copyWith => _$ServerModelCopyWithImpl<ServerModel>(this as ServerModel, _$identity);

  /// Serializes this ServerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerModel&&(identical(other.sName, sName) || other.sName == sName)&&(identical(other.sIP, sIP) || other.sIP == sIP)&&(identical(other.iPort, iPort) || other.iPort == iPort));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sName,sIP,iPort);

@override
String toString() {
  return 'ServerModel(sName: $sName, sIP: $sIP, iPort: $iPort)';
}


}

/// @nodoc
abstract mixin class $ServerModelCopyWith<$Res>  {
  factory $ServerModelCopyWith(ServerModel value, $Res Function(ServerModel) _then) = _$ServerModelCopyWithImpl;
@useResult
$Res call({
 String sName, String sIP, int iPort
});




}
/// @nodoc
class _$ServerModelCopyWithImpl<$Res>
    implements $ServerModelCopyWith<$Res> {
  _$ServerModelCopyWithImpl(this._self, this._then);

  final ServerModel _self;
  final $Res Function(ServerModel) _then;

/// Create a copy of ServerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sName = null,Object? sIP = null,Object? iPort = null,}) {
  return _then(_self.copyWith(
sName: null == sName ? _self.sName : sName // ignore: cast_nullable_to_non_nullable
as String,sIP: null == sIP ? _self.sIP : sIP // ignore: cast_nullable_to_non_nullable
as String,iPort: null == iPort ? _self.iPort : iPort // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerModel].
extension ServerModelPatterns on ServerModel {
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

  TResult Function( _ServerModel value)? $default,{required TResult orElse(),}){
  final _that = this;
  switch (_that) {
  case _ServerModel() when $default != null:
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

  @optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerModel value) $default,){
  final _that = this;
  switch (_that) {
  case _ServerModel():
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

  @optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerModel value)? $default,){
  final _that = this;
  switch (_that) {
  case _ServerModel() when $default != null:
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

  @optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sName, String sIP, int iPort)? $default,{required TResult orElse(),}) {final _that = this;
  switch (_that) {
  case _ServerModel() when $default != null:
  return $default(_that.sName,_that.sIP,_that.iPort);case _:
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

  @optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sName, String sIP, int iPort) $default,) {final _that = this;
  switch (_that) {
  case _ServerModel():
  return $default(_that.sName,_that.sIP,_that.iPort);case _:
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

  @optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sName, String sIP, int iPort)? $default,) {final _that = this;
  switch (_that) {
  case _ServerModel() when $default != null:
  return $default(_that.sName,_that.sIP,_that.iPort);case _:
  return null;

  }
  }

}

/// @nodoc
@JsonSerializable()

class _ServerModel implements ServerModel {
  const _ServerModel({required this.sName, required this.sIP, required this.iPort});
  factory _ServerModel.fromJson(Map<String, dynamic> json) => _$ServerModelFromJson(json);

@override final  String sName;
@override final  String sIP;
@override final  int iPort;

/// Create a copy of ServerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerModelCopyWith<_ServerModel> get copyWith => __$ServerModelCopyWithImpl<_ServerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerModel&&(identical(other.sName, sName) || other.sName == sName)&&(identical(other.sIP, sIP) || other.sIP == sIP)&&(identical(other.iPort, iPort) || other.iPort == iPort));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sName,sIP,iPort);

@override
String toString() {
  return 'ServerModel(sName: $sName, sIP: $sIP, iPort: $iPort)';
}


}

/// @nodoc
abstract mixin class _$ServerModelCopyWith<$Res> implements $ServerModelCopyWith<$Res> {
  factory _$ServerModelCopyWith(_ServerModel value, $Res Function(_ServerModel) _then) = __$ServerModelCopyWithImpl;
@override @useResult
$Res call({
 String sName, String sIP, int iPort
});




}
/// @nodoc
class __$ServerModelCopyWithImpl<$Res>
    implements _$ServerModelCopyWith<$Res> {
  __$ServerModelCopyWithImpl(this._self, this._then);

  final _ServerModel _self;
  final $Res Function(_ServerModel) _then;

/// Create a copy of ServerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sName = null,Object? sIP = null,Object? iPort = null,}) {
  return _then(_ServerModel(
sName: null == sName ? _self.sName : sName // ignore: cast_nullable_to_non_nullable
as String,sIP: null == sIP ? _self.sIP : sIP // ignore: cast_nullable_to_non_nullable
as String,iPort: null == iPort ? _self.iPort : iPort // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
