import 'package:flutter/material.dart';

import '../../common/utils.dart';

enum ItemType {
  class_('ar'),
  armor('co'),
  cape('ba'),
  helm('he'),
  weapon('Weapon'),
  floorItem('hi'),
  pet('pe'),
  house('ho'),
  misc('None');

  final String value;

  const ItemType(this.value);

  static ItemType fromString(String value) {
    return ItemType.values.firstWhere(
      (it) => it.value == value,
      orElse: () => ItemType.misc,
    );
  }
}

enum ScrollType {
  scroll('scroll'),
  elixir('elixir'),
  potion('potion');

  final String value;

  const ScrollType(this.value);
}

@immutable
class Item {
  final int id;
  final String name;
  final ItemType type;
  final int qty;
  final bool isAcs;
  final bool isTemp;
  final int cost;
  final bool isEquipped;
  final num charItemId; // server response can be 'int' and 'double'
  final String? shopItemId;
  final int? enhPatternId;

  const Item({
    required this.id,
    required this.name,
    required this.type,
    required this.qty,
    required this.isAcs,
    required this.isTemp,
    required this.cost,
    required this.isEquipped,
    required this.charItemId,
    required this.shopItemId,
    required this.enhPatternId,
  });

  String get nameNormalize => normalize(name);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['ItemID'],
      name: json['sName'],
      type: ItemType.fromString(json['sES']),
      qty: json['iQty'],
      isAcs: json['bCoins'] == 1,
      isTemp: json['bTemp'] == 1,
      cost: json['iCost'],
      isEquipped: json['bEquip'] == 1,
      charItemId: json['CharItemID'],
      // shopItemId: json['ShopItemID'] as String?,
      // enhPatternId: json['EnhPatternID'] as int?,
      shopItemId: null,
      enhPatternId: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'qty': qty,
      'isAcs': isAcs,
      'isTemp': isTemp,
      'cost': cost,
      'isEquipped': isEquipped,
      'charItemId': charItemId,
      'shopItemId': shopItemId,
      'enhPatternId': enhPatternId,
      // 'shopItemId': shopItemId,
      // 'enhPatternId': enhPatternId,
    };
  }
}
