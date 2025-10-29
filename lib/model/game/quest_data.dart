import 'package:collection/collection.dart';

import 'item.dart';

class QuestData {
  final Rewards rewards;
  final int value;
  final Map<String, ReqItem> reqItems;
  final List<TurnInItem> reqTurnInItems;
  final int slot;
  final int level;
  final int reqRep;
  final String description;
  final int questId;
  final bool upgrade;
  final String name;

  QuestData({
    required this.rewards,
    required this.value,
    required this.reqItems,
    required this.reqTurnInItems,
    required this.slot,
    required this.level,
    required this.reqRep,
    required this.description,
    required this.questId,
    required this.upgrade,
    required this.name,
  });

  factory QuestData.empty() => QuestData(
    rewards: Rewards(itemsS: {}),
    value: 0,
    reqItems: {},
    reqTurnInItems: [],
    slot: 0,
    level: 0,
    reqRep: 0,
    description: '',
    questId: 0,
    upgrade: false,
    name: '',
  );

  bool isReqFulfilled(List<Item> playerItems) {
    final result = reqTurnInItems.every((reqItem) {
      final item = playerItems.firstWhereOrNull((i) => i.id == reqItem.itemId);
      // log(
      //   "isReqFulfilled: qid:$questId | ${item?.name} (${item?.qty} >= ${reqItem.quantity})",
      // );
      return item != null && item.qty >= reqItem.quantity;
    });
    return result;
  }

  factory QuestData.fromJson(Map<String, dynamic> json) => QuestData(
    rewards: Rewards.fromJson(json["oRewards"]),
    value: json["iValue"],
    reqItems: Map.from(
      json["oItems"],
    ).map((k, v) => MapEntry<String, ReqItem>(k, ReqItem.fromJson(v))),
    reqTurnInItems: List<TurnInItem>.from(
      json["turnin"].map((x) => TurnInItem.fromJson(x)),
    ),
    slot: json["iSlot"],
    level: json["iLvl"],
    reqRep: json["iReqRep"],
    description: json["sDesc"],
    questId: json["QuestID"],
    upgrade: json["bUpg"] == 1,
    name: json["sName"],
  );

  Map<String, dynamic> toJson() => {
    "oRewards": rewards.toJson(),
    "iValue": value,
    "oItems": Map.from(
      reqItems,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "turnin": List<dynamic>.from(reqTurnInItems.map((x) => x.toJson())),
    "iSlot": slot,
    "iLvl": level,
    "iReqRep": reqRep,
    "sDesc": description,
    "QuestID": questId,
    "bUpg": upgrade ? 1 : 0,
    "sName": name,
  };
}

class ReqItem {
  final int itemId;
  final String type;
  final int qsValue;
  final dynamic reqQuests;
  final bool temp;
  final int stack;
  final String name;

  ReqItem({
    required this.itemId,
    required this.type,
    required this.qsValue,
    required this.reqQuests,
    required this.temp,
    required this.stack,
    required this.name,
  });

  factory ReqItem.fromJson(Map<String, dynamic> json) => ReqItem(
    itemId: json["ItemID"],
    type: json["sType"],
    qsValue: json["iQSValue"],
    reqQuests: json["sReqQuests"],
    temp: json["bTemp"] == 1,
    stack: json["iStk"],
    name: json["sName"],
  );

  Map<String, dynamic> toJson() => {
    "ItemID": itemId,
    "sType": type,
    "iQSValue": qsValue,
    "sReqQuests": reqQuests,
    "bTemp": temp ? 1 : 0,
    "iStk": stack,
    "sName": name,
  };
}

class TurnInItem {
  final int itemId;
  final int questId;
  final int quantity;

  TurnInItem({
    required this.itemId,
    required this.questId,
    required this.quantity,
  });

  factory TurnInItem.fromJson(Map<String, dynamic> json) => TurnInItem(
    itemId: json["ItemID"],
    questId: json["QuestID"],
    quantity: json["iQty"],
  );

  Map<String, dynamic> toJson() => {
    "ItemID": itemId,
    "QuestID": questId,
    "iQty": quantity,
  };
}

class Rewards {
  final Map<String, Item> itemsS;

  Rewards({required this.itemsS});

  factory Rewards.fromJson(Map<String, dynamic> json) => Rewards(
    itemsS: Map.from(
      json["itemsS"],
    ).map((k, v) => MapEntry<String, Item>(k, Item.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "itemsS": Map.from(
      itemsS,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class RewardItem {
  final int rate;
  final int itemId;
  final int questId;
  final int type;
  final int quantity;

  RewardItem({
    required this.rate,
    required this.itemId,
    required this.questId,
    required this.type,
    required this.quantity,
  });

  factory RewardItem.fromJson(Map<String, dynamic> json) => RewardItem(
    rate: json["iRate"],
    itemId: json["ItemID"],
    questId: json["QuestID"],
    type: json["iType"],
    quantity: json["iQty"],
  );

  Map<String, dynamic> toJson() => {
    "iRate": rate,
    "ItemID": itemId,
    "QuestID": questId,
    "iType": type,
    "iQty": quantity,
  };
}
