import 'package:flutter/material.dart';
import 'package:loving/model/game/area_player.dart';
import 'package:loving/model/game/monster.dart';

@immutable
class AreaMap {
  final String name;
  final int roomNumber;
  final String areaId;
  final List<Monster> monsters;
  final List<AreaPlayer> areaPlayers;

  const AreaMap({
    this.name = '',
    this.roomNumber = 1,
    this.areaId = '',
    this.monsters = const [],
    this.areaPlayers = const [],
  });

  Monster getMonster(int monMapId) {
    return monsters.firstWhere((element) => element.monMapId == monMapId);
  }

  List<Monster> getMonsters(String cell) {
    return monsters
        .where((element) => element.cell?.toLowerCase() == cell.toLowerCase())
        .toList();
  }

  AreaMap copyWith({
    String? name,
    int? roomNumber,
    String? areaId,
    List<Monster>? monsters,
    List<AreaPlayer>? areaPlayers,
  }) {
    return AreaMap(
      name: name ?? this.name,
      roomNumber: roomNumber ?? this.roomNumber,
      areaId: areaId ?? this.areaId,
      monsters: monsters ?? this.monsters,
      areaPlayers: areaPlayers ?? this.areaPlayers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'roomNumber': roomNumber,
      'areaId': areaId,
      'monsters': monsters.map((monster) => monster.toJson()).toList(),
      'areaPlayers': areaPlayers
          .map((areaPlayer) => areaPlayer.toJson())
          .toList(),
    };
  }
}
