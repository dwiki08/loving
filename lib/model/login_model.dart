import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving/model/server_model.dart';

part 'login_model.freezed.dart';
part 'login_model.g.dart';

@freezed
abstract class LoginModel with _$LoginModel {
  const factory LoginModel({
    required String username,
    required String sToken,
    required String userid,
    required List<ServerModel> servers,
  }) = _LoginModel;

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
}