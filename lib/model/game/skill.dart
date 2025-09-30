import 'package:flutter/material.dart';

import '../../common/utils.dart';

enum TargetType { monster, player, self }

@immutable
class Skill {
  final int index; // 0, 1, 2, 3, 4
  final String ref; // aa, a1, a2, a3, a4
  final String name;
  final int mana;
  final Duration cooldown; // fixed milliseconds
  final TargetType targetType;
  final int tgtMax;
  final DateTime lastUsage;

  const Skill({
    required this.index,
    required this.ref,
    required this.name,
    required this.mana,
    required this.cooldown,
    required this.targetType,
    required this.tgtMax,
    required this.lastUsage,
  });

  int get remainingCooldown {
    final remaining =
        lastUsage.add(cooldown).difference(DateTime.now()).inMilliseconds;
    return remaining < 0 ? 0 : remaining;
  }

  bool get isAvailable {
    return remainingCooldown <= 0;
  }

  Skill copyWith({
    int? index,
    String? ref,
    String? name,
    int? mana,
    Duration? cooldown,
    TargetType? targetType,
    int? tgtMax,
    DateTime? lastUsage,
  }) {
    return Skill(
      index: index ?? this.index,
      ref: ref ?? this.ref,
      name: name ?? this.name,
      mana: mana ?? this.mana,
      cooldown: cooldown ?? this.cooldown,
      targetType: targetType ?? this.targetType,
      tgtMax: tgtMax ?? this.tgtMax,
      lastUsage: lastUsage ?? this.lastUsage,
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
      mana: json['mp'] as int,
      cooldown: cooldown,
      targetType: tgt,
      tgtMax: (json['tgtMax'] as int?) ?? 1,
      lastUsage: DateTime.now().subtract(cooldown),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'ref': ref,
      'name': name,
      'mana': mana,
      'cooldown': cooldown.inMilliseconds,
      'targetType': targetType.name,
      'tgtMax': tgtMax,
      'lastUsage': getTimestamp(dateTime: lastUsage),
      'remainingCooldown': remainingCooldown,
      'isAvailable': isAvailable,
    };
  }
}
