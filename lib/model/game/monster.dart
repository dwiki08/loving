import 'package:flutter/material.dart';
import 'package:loving/common/utils.dart';

@immutable
class Monster {
  final String monMapId;
  final String monId;
  final bool isAlive;
  final int currentHp;
  final int maxHp;
  final String? monName;
  final String? frame;

  const Monster({
    required this.monMapId,
    required this.monId,
    required this.isAlive,
    required this.currentHp,
    required this.maxHp,
    this.monName,
    this.frame,
  });

  String? get getMonName => monName == null ? monName : normalize(monName!);

  factory Monster.fromJson(Map<String, dynamic> json) {
    return Monster(
      monMapId: json['MonMapID'] as String,
      monId: json['MonID'] as String,
      isAlive: (json['intHP'] as int) > 0,
      currentHp: json['intHP'] as int,
      maxHp: json['intHPMax'] as int,
      monName: null,
      frame: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monMapId': monMapId,
      'monId': monId,
      'isAlive': isAlive,
      'currentHp': currentHp,
      'maxHp': maxHp,
      'monName': monName,
      'frame': frame,
    };
  }

  Monster copyWith({
    String? monMapId,
    String? monId,
    bool? isAlive,
    int? currentHp,
    int? maxHp,
    String? monName,
    String? frame,
  }) {
    return Monster(
      monMapId: monMapId ?? this.monMapId,
      monId: monId ?? this.monId,
      isAlive: isAlive ?? this.isAlive,
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      monName: monName ?? this.monName,
      frame: frame ?? this.frame,
    );
  }
}
