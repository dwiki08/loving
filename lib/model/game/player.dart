import 'package:flutter/material.dart';

import 'aura.dart';
import 'item.dart';

enum PlayerStatus { alive, dead, inCombat }

@immutable
class Player {
  final String charId;
  final String username;
  final List<Item> equipments;
  final String cell;
  final String pad;
  final int posX;
  final int posY;
  final List<Item> inventoryItems;
  final List<Item> tempInventoryItems;
  final List<Item> bankItems;
  final double totalGold;
  final int maxHP;
  final int currentHP;
  final int currentMP;
  final PlayerStatus status;
  final List<Aura> auras;

  const Player({
    this.charId = '',
    this.username = '',
    this.equipments = const [],
    this.cell = 'Blank',
    this.pad = 'Spawn',
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

  Player copyWith({
    String? charId,
    String? username,
    List<Item>? equipments,
    String? cell,
    String? pad,
    int? posX,
    int? posY,
    List<Item>? inventoryItems,
    List<Item>? tempInventoryItems,
    List<Item>? bankItems,
    double? totalGold,
    int? maxHP,
    int? currentHP,
    int? currentMP,
    PlayerStatus? status,
    List<Aura>? auras,
  }) {
    return Player(
      charId: charId ?? this.charId,
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
      'status': status.index,
      'auras': auras.map((e) => e.toJson()).toList(),
    };
  }
}
