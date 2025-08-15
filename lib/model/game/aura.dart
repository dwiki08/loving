import 'package:freezed_annotation/freezed_annotation.dart';

part 'aura.freezed.dart';
part 'aura.g.dart';

@freezed
abstract class Aura with _$Aura {
  const factory Aura(String name,
      String count,) = _Aura;

  factory Aura.fromJson(Map<String, dynamic> json) => _$AuraFromJson(json);
}