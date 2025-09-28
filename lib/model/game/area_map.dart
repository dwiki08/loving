import 'package:flutter/material.dart';
import 'package:loving/model/game/area_player.dart';
import 'package:loving/model/game/monster.dart';

@immutable
class AreaMap {
  final String name;
  final String areaId;
  final List<Monster> monsters;
  final List<AreaPlayer> areaPlayers;

  const AreaMap({
    this.name = '',
    this.areaId = '',
    this.monsters = const [],
    this.areaPlayers = const [],
  });

  AreaMap copyWith({
    String? name,
    String? areaId,
    List<Monster>? monsters,
    List<AreaPlayer>? areaPlayers,
  }) {
    return AreaMap(
      name: name ?? this.name,
      areaId: areaId ?? this.areaId,
      monsters: monsters ?? this.monsters,
      areaPlayers: areaPlayers ?? this.areaPlayers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'areaId': areaId,
      'monsters': monsters.map((monster) => monster.toJson()).toList(),
      'areaPlayers':
          areaPlayers.map((areaPlayer) => areaPlayer.toJson()).toList(),
    };
  }
}
