import 'package:flutter/material.dart';

import '../../common/utils.dart';

enum TargetType {
  monster("m"),
  player("p"),
  self("p");

  final String value;

  const TargetType(this.value);
}

@immutable
class Skill {
  final int index; // 0, 1, 2, 3, 4
  final String ref; // aa, a1, a2, a3, a4
  final String name;
  final String strl;
  final int mana;
  final Duration cooldown; // fixed milliseconds
  final TargetType targetType;
  final int tgtMax;
  final DateTime nextUsage;

  const Skill({
    required this.index,
    required this.ref,
    required this.name,
    required this.strl,
    required this.mana,
    required this.cooldown,
    required this.targetType,
    required this.tgtMax,
    required this.nextUsage,
  });

  int get remainingCooldown {
    return nextUsage
        .difference(DateTime.now())
        .inMilliseconds
        .clamp(0, cooldown.inMilliseconds);
  }

  Skill copyWith({
    int? index,
    String? ref,
    String? name,
    String? strl,
    int? mana,
    Duration? cooldown,
    TargetType? targetType,
    int? tgtMax,
    DateTime? nextUsage,
  }) {
    return Skill(
      index: index ?? this.index,
      ref: ref ?? this.ref,
      name: name ?? this.name,
      strl: strl ?? this.strl,
      mana: mana ?? this.mana,
      cooldown: cooldown ?? this.cooldown,
      targetType: targetType ?? this.targetType,
      tgtMax: tgtMax ?? this.tgtMax,
      nextUsage: nextUsage ?? this.nextUsage,
    );
  }

  factory Skill.fromJson(int index, Map<String, dynamic> json) {
    final cooldown = Duration(milliseconds: json['cd'] as int);
    var tgt = TargetType.monster;
    switch (json['tgt'] as String) {
      case 'h':
        tgt = TargetType.monster;
        break;
      case 'f':
        tgt = TargetType.player;
        break;
      case 's':
        tgt = TargetType.self;
        break;
    }
    return Skill(
      index: index,
      ref: json['ref'] as String,
      name: json['nam'] as String,
      strl: json['strl'] as String? ?? '',
      mana: json['mp'] as int,
      cooldown: cooldown,
      targetType: tgt,
      tgtMax: (json['tgtMax'] as int?) ?? 1,
      nextUsage: DateTime.now().subtract(cooldown),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'ref': ref,
      'name': name,
      'strl': strl,
      'mana': mana,
      'cooldown': cooldown.inMilliseconds,
      'targetType': targetType.name,
      'tgtMax': tgtMax,
      'nextUsage': getTimestamp(dateTime: nextUsage),
      'remainingCooldown': remainingCooldown,
    };
  }
}
