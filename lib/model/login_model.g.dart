// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => _LoginModel(
  username: json['username'] as String,
  sToken: json['sToken'] as String,
  userid: json['userid'] as String,
  servers:
      (json['servers'] as List<dynamic>)
          .map((e) => ServerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$LoginModelToJson(_LoginModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'sToken': instance.sToken,
      'userid': instance.userid,
      'servers': instance.servers,
    };
