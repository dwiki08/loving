import 'package:flutter/material.dart';
import 'package:loving/model/game/monster.dart';

@immutable
class AreaMap {
  final String name;
  final String areaId;
  final List<Monster> monsters;

  const AreaMap({this.name = '', this.areaId = '', this.monsters = const []});

  AreaMap copyWith({String? name, String? areaId, List<Monster>? monsters}) {
    return AreaMap(
      name: name ?? this.name,
      areaId: areaId ?? this.areaId,
      monsters: monsters ?? this.monsters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'areaId': areaId,
      'monsters': monsters.map((monster) => monster.toJson()).toList(),
    };
  }
}
