import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_model.freezed.dart';
part 'server_model.g.dart';

@freezed
abstract class ServerModel with _$ServerModel {
  const factory ServerModel({
    required String sName,
    required String sIP,
    required int iPort
  }) = _ServerModel;

  factory ServerModel.fromJson(Map<String, dynamic> json) => _$ServerModelFromJson(json);
}
