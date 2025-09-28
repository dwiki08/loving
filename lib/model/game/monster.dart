import 'package:flutter/material.dart';
import 'package:loving/common/utils.dart';

import 'aura.dart';

@immutable
class Monster {
  final int monMapId;
  final String monId;
  final bool isAlive;
  final int currentHp;
  final int maxHp;
  final String? monName;
  final String? frame;
  final List<Aura> auras;

  const Monster({
    this.monMapId = -1,
    this.monId = '',
    this.isAlive = false,
    this.currentHp = 0,
    this.maxHp = 0,
    this.monName,
    this.frame,
    this.auras = const [],
  });

  String? get getMonName => monName == null ? monName : normalize(monName!);

  factory Monster.fromJson(Map<String, dynamic> json) {
    return Monster(
      monMapId: json['MonMapID'] as int,
      monId: json['MonID'] as String,
      isAlive: (json['intHP'] as int) > 0,
      currentHp: json['intHP'] as int,
      maxHp: json['intHPMax'] as int,
      monName: null,
      frame: null,
      auras: [],
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
      'auras': auras.map((aura) => aura.toJson()).toList(),
    };
  }

  Monster copyWith({
    int? monMapId,
    String? monId,
    bool? isAlive,
    int? currentHp,
    int? maxHp,
    String? monName,
    String? frame,
    List<Aura>? auras,
  }) {
    return Monster(
      monMapId: monMapId ?? this.monMapId,
      monId: monId ?? this.monId,
      isAlive: isAlive ?? this.isAlive,
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      monName: monName ?? this.monName,
      frame: frame ?? this.frame,
      auras: auras ?? this.auras,
    );
  }
}
