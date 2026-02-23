import 'package:flutter/material.dart';
import 'package:loving/model/game/quest_data.dart';
import 'package:loving/model/game/skill.dart';

import '../../common/utils.dart';
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
  final int accessLevel;
  final String username;
  final List<Item> equipments;
  final String cell;
  final String pad;
  final int posX;
  final int posY;
  final List<Item> inventoryItems;
  final List<Item> tempInventoryItems;
  final List<Item> bankItems;
  final List<Item> droppedItems;
  final num totalGold;
  final int maxHP;
  final int currentHP;
  final int currentMP;
  final PlayerStatus status;
  final List<Aura> auras;
  final num skillCdr;
  final num skillManaCost;
  final List<Skill> skills;

  // list of accepted quest ids
  final List<int> questTracker;

  // list of loaded quest data from 'getQuests'
  final List<QuestData> loadedQuestData;

  const Player({
    this.charId = '',
    this.userId = -1,
    this.accessLevel = 0,
    this.username = '',
    this.equipments = const [],
    this.cell = '',
    this.pad = '',
    this.posX = 0,
    this.posY = 0,
    this.inventoryItems = const [],
    this.tempInventoryItems = const [],
    this.bankItems = const [],
    this.droppedItems = const [],
    this.totalGold = 0,
    this.maxHP = 0,
    this.currentHP = 0,
    this.currentMP = 100,
    this.status = PlayerStatus.alive,
    this.auras = const [],
    this.skillCdr = 1.0,
    this.skillManaCost = 1.0,
    this.skills = const [],
    this.questTracker = const [],
    this.loadedQuestData = const [],
  });

  QuestData? getLoadedQuestData(int questId) =>
      loadedQuestData.where((quest) => quest.questId == questId).firstOrNull;

  Item? getInventoryItem(int itemId) =>
      inventoryItems.where((item) => item.id == itemId).firstOrNull;

  Item? getInventoryItemByName(String itemName) =>
      inventoryItems.where((item) => item.name == itemName).firstOrNull;

  Item? getTempInventoryItem(int itemId) =>
      tempInventoryItems.where((item) => item.id == itemId).firstOrNull;

  Item? getTempInventoryItemByName(String itemName) =>
      tempInventoryItems.where((item) => item.name == itemName).firstOrNull;

  bool hasItem(int itemId, [int qty = 1]) {
    final invItem = getInventoryItem(itemId);
    final tempInvItem = getTempInventoryItem(itemId);
    final totalQty = (invItem?.qty ?? 0) + (tempInvItem?.qty ?? 0);
    return totalQty >= qty;
  }

  bool hasItemByName(String itemName, [int qty = 1]) {
    final invItem = getInventoryItemByName(itemName);
    final tempInvItem = getTempInventoryItemByName(itemName);
    final totalQty = (invItem?.qty ?? 0) + (tempInvItem?.qty ?? 0);
    return totalQty >= qty;
  }

  Item? getBankItem(int itemId) =>
      bankItems.where((item) => item.id == itemId).firstOrNull;

  Item? getBankItemByName(String itemName) =>
      bankItems.where((item) => item.name == itemName).firstOrNull;

  Item? getDroppedItem(int itemId) =>
      droppedItems.where((item) => item.id == itemId).firstOrNull;

  Item? getDroppedItemByName(String itemName) => droppedItems
      .where((item) => item.nameNormalize == normalize(itemName))
      .firstOrNull;

  Item? getEquipment(String itemName) => equipments
      .where((item) => item.nameNormalize == normalize(itemName))
      .firstOrNull;

  double get currentHPinPercent {
    if (maxHP == 0) return 0.0;
    return (currentHP / maxHP) * 100;
  }

  Player copyWith({
    String? charId,
    int? userId,
    int? accessLevel,
    String? username,
    List<Item>? equipments,
    String? cell,
    String? pad,
    int? posX,
    int? posY,
    List<Item>? inventoryItems,
    List<Item>? tempInventoryItems,
    List<Item>? bankItems,
    List<Item>? droppedItems,
    num? totalGold,
    int? maxHP,
    int? currentHP,
    int? currentMP,
    PlayerStatus? status,
    List<Aura>? auras,
    num? skillCdr,
    num? skillManaCost,
    List<Skill>? skills,
    List<int>? questTracker,
    List<QuestData>? loadedQuestData,
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
      droppedItems: droppedItems ?? this.droppedItems,
      totalGold: totalGold ?? this.totalGold,
      maxHP: maxHP ?? this.maxHP,
      currentHP: currentHP ?? this.currentHP,
      currentMP: currentMP ?? this.currentMP,
      status: status ?? this.status,
      auras: auras ?? this.auras,
      skillCdr: skillCdr ?? this.skillCdr,
      skillManaCost: skillManaCost ?? this.skillManaCost,
      skills: skills ?? this.skills,
      questTracker: questTracker ?? this.questTracker,
      loadedQuestData: loadedQuestData ?? this.loadedQuestData,
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
      'droppedItems': droppedItems.map((e) => e.toJson()).toList(),
      'totalGold': totalGold,
      'maxHP': maxHP,
      'currentHP': currentHP,
      'currentMP': currentMP,
      'skillCdr': skillCdr,
      'skillManaCost': skillManaCost,
      'status': status.name,
      'auras': auras.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
      'questTracker': questTracker,
      'loadedQuestData': loadedQuestData.map((e) => e.toJson()).toList(),
    };
  }
}
