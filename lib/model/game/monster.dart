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
  final String? cell;
  final List<Aura> auras;

  const Monster({
    this.monMapId = -1,
    this.monId = '',
    this.isAlive = false,
    this.currentHp = 0,
    this.maxHp = 0,
    this.monName,
    this.cell,
    this.auras = const [],
  });

  String get getMonName => normalize(monName ?? '');

  factory Monster.fromJson(Map<String, dynamic> json) {
    return Monster(
      monMapId: safeParseInt(json['MonMapID']),
      monId: json['MonID'] as String,
      isAlive: safeParseInt(json['intHP']) > 0,
      currentHp: safeParseInt(json['intHP']),
      maxHp: safeParseInt(json['intHPMax']),
      monName: null,
      cell: null,
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
      'cell': cell,
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
    String? cell,
    List<Aura>? auras,
  }) {
    return Monster(
      monMapId: monMapId ?? this.monMapId,
      monId: monId ?? this.monId,
      isAlive: isAlive ?? this.isAlive,
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      monName: monName ?? this.monName,
      cell: cell ?? this.cell,
      auras: auras ?? this.auras,
    );
  }
}
