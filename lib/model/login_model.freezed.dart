// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginModel {

 String get username; String get sToken; String get userid; List<ServerModel> get servers;
/// Create a copy of LoginModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginModelCopyWith<LoginModel> get copyWith => _$LoginModelCopyWithImpl<LoginModel>(this as LoginModel, _$identity);

  /// Serializes this LoginModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginModel&&(identical(other.username, username) || other.username == username)&&(identical(other.sToken, sToken) || other.sToken == sToken)&&(identical(other.userid, userid) || other.userid == userid)&&const DeepCollectionEquality().equals(other.servers, servers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,sToken,userid,const DeepCollectionEquality().hash(servers));

@override
String toString() {
  return 'LoginModel(username: $username, sToken: $sToken, userid: $userid, servers: $servers)';
}


}

/// @nodoc
abstract mixin class $LoginModelCopyWith<$Res>  {
  factory $LoginModelCopyWith(LoginModel value, $Res Function(LoginModel) _then) = _$LoginModelCopyWithImpl;
@useResult
$Res call({
 String username, String sToken, String userid, List<ServerModel> servers
});




}
/// @nodoc
class _$LoginModelCopyWithImpl<$Res>
    implements $LoginModelCopyWith<$Res> {
  _$LoginModelCopyWithImpl(this._self, this._then);

  final LoginModel _self;
  final $Res Function(LoginModel) _then;

/// Create a copy of LoginModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? sToken = null,Object? userid = null,Object? servers = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,sToken: null == sToken ? _self.sToken : sToken // ignore: cast_nullable_to_non_nullable
as String,userid: null == userid ? _self.userid : userid // ignore: cast_nullable_to_non_nullable
as String,servers: null == servers ? _self.servers : servers // ignore: cast_nullable_to_non_nullable
as List<ServerModel>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LoginModel implements LoginModel {
  const _LoginModel({required this.username, required this.sToken, required this.userid, required final  List<ServerModel> servers}): _servers = servers;
  factory _LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);

@override final  String username;
@override final  String sToken;
@override final  String userid;
 final  List<ServerModel> _servers;
@override List<ServerModel> get servers {
  if (_servers is EqualUnmodifiableListView) return _servers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_servers);
}


/// Create a copy of LoginModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginModelCopyWith<_LoginModel> get copyWith => __$LoginModelCopyWithImpl<_LoginModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginModel&&(identical(other.username, username) || other.username == username)&&(identical(other.sToken, sToken) || other.sToken == sToken)&&(identical(other.userid, userid) || other.userid == userid)&&const DeepCollectionEquality().equals(other._servers, _servers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,sToken,userid,const DeepCollectionEquality().hash(_servers));

@override
String toString() {
  return 'LoginModel(username: $username, sToken: $sToken, userid: $userid, servers: $servers)';
}


}

/// @nodoc
abstract mixin class _$LoginModelCopyWith<$Res> implements $LoginModelCopyWith<$Res> {
  factory _$LoginModelCopyWith(_LoginModel value, $Res Function(_LoginModel) _then) = __$LoginModelCopyWithImpl;
@override @useResult
$Res call({
 String username, String sToken, String userid, List<ServerModel> servers
});




}
/// @nodoc
class __$LoginModelCopyWithImpl<$Res>
    implements _$LoginModelCopyWith<$Res> {
  __$LoginModelCopyWithImpl(this._self, this._then);

  final _LoginModel _self;
  final $Res Function(_LoginModel) _then;

/// Create a copy of LoginModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? sToken = null,Object? userid = null,Object? servers = null,}) {
  return _then(_LoginModel(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,sToken: null == sToken ? _self.sToken : sToken // ignore: cast_nullable_to_non_nullable
as String,userid: null == userid ? _self.userid : userid // ignore: cast_nullable_to_non_nullable
as String,servers: null == servers ? _self._servers : servers // ignore: cast_nullable_to_non_nullable
as List<ServerModel>,
  ));
}


}

// dart format on
