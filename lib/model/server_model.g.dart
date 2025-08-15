// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerModel _$ServerModelFromJson(Map<String, dynamic> json) => _ServerModel(
  sName: json['sName'] as String,
  sIP: json['sIP'] as String,
  iPort: (json['iPort'] as num).toInt(),
);

Map<String, dynamic> _$ServerModelToJson(_ServerModel instance) =>
    <String, dynamic>{
      'sName': instance.sName,
      'sIP': instance.sIP,
      'iPort': instance.iPort,
    };
