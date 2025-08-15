import 'package:flutter/material.dart';

import 'item.dart';

@immutable
class Shop {
  final String shopId;
  final String shopName;
  final List<Item> items;
  final bool isMember;

  const Shop({
    required this.shopId,
    required this.shopName,
    required this.items,
    required this.isMember,
  });

  Item? getItem(String itemName) {
    try {
      return items.firstWhere((item) => item.name == itemName);
    } catch (e) {
      return null;
    }
  }

  factory Shop.fromJson(Map<String, dynamic> json) {
    final itemsList =
        (json['items'] as List)
            .map((itemJson) => Item.fromJson(itemJson as Map<String, dynamic>))
            .toList();

    return Shop(
      shopId: json['ShopID'].toString(),
      shopName: json['sName'] as String,
      items: itemsList,
      isMember: json['bUpgrd'] == '1',
    );
  }
}
