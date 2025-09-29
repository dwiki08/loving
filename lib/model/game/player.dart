import 'package:flutter/material.dart';

import 'aura.dart';
import 'item.dart';

enum PlayerStatus {
  dead, //0
  alive, //1
  inCombat, //2
}

PlayerStatus stateToPlayerStatus(int state) {
  switch (state) {
    case 0:
      return PlayerStatus.dead;
    case 1:
      return PlayerStatus.alive;
    case 2:
      return PlayerStatus.inCombat;
    default:
      return PlayerStatus.alive;
  }
}

@immutable
class Player {
  final String charId;
  final int userId;
  final String username;
  final List<Item> equipments;
  final String cell;
  final String pad;
  final int posX;
  final int posY;
  final List<Item> inventoryItems;
  final List<Item> tempInventoryItems;
  final List<Item> bankItems;
  final num totalGold;
  final int maxHP;
  final int currentHP;
  final int currentMP;
  final PlayerStatus status;
  final List<Aura> auras;

  const Player({
    this.charId = '',
    this.userId = -1,
    this.username = '',
    this.equipments = const [],
    this.cell = '',
    this.pad = '',
    this.posX = 0,
    this.posY = 0,
    this.inventoryItems = const [],
    this.tempInventoryItems = const [],
    this.bankItems = const [],
    this.totalGold = 0,
    this.maxHP = 0,
    this.currentHP = 0,
    this.currentMP = 0,
    this.status = PlayerStatus.alive,
    this.auras = const [],
  });

  double getHPinPercentage() {
    if (maxHP == 0) return 0.0;
    return (currentHP / maxHP) * 100;
  }

  Player copyWith({
    String? charId,
    int? userId,
    String? username,
    List<Item>? equipments,
    String? cell,
    String? pad,
    int? posX,
    int? posY,
    List<Item>? inventoryItems,
    List<Item>? tempInventoryItems,
    List<Item>? bankItems,
    num? totalGold,
    int? maxHP,
    int? currentHP,
    int? currentMP,
    PlayerStatus? status,
    List<Aura>? auras,
  }) {
    return Player(
      charId: charId ?? this.charId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      equipments: equipments ?? this.equipments,
      cell: cell ?? this.cell,
      pad: pad ?? this.pad,
      posX: posX ?? this.posX,
      posY: posY ?? this.posY,
      inventoryItems: inventoryItems ?? this.inventoryItems,
      tempInventoryItems: tempInventoryItems ?? this.tempInventoryItems,
      bankItems: bankItems ?? this.bankItems,
      totalGold: totalGold ?? this.totalGold,
      maxHP: maxHP ?? this.maxHP,
      currentHP: currentHP ?? this.currentHP,
      currentMP: currentMP ?? this.currentMP,
      status: status ?? this.status,
      auras: auras ?? this.auras,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'charId': charId,
      'userId': userId,
      'username': username,
      'equipments': equipments.map((e) => e.toJson()).toList(),
      'cell': cell,
      'pad': pad,
      'posX': posX,
      'posY': posY,
      'inventoryItems': inventoryItems.map((e) => e.toJson()).toList(),
      'tempInventoryItems': tempInventoryItems.map((e) => e.toJson()).toList(),
      'bankItems': bankItems.map((e) => e.toJson()).toList(),
      'totalGold': totalGold,
      'maxHP': maxHP,
      'currentHP': currentHP,
      'currentMP': currentMP,
      'status': status.name,
      'auras': auras.map((e) => e.toJson()).toList(),
    };
  }
}
