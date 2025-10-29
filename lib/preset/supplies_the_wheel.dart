import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/preset/base_preset.dart';

import '../loving/handler/item_drop_handler.dart';
import '../loving/handler/quest_completion_handler.dart';

final suppliesTheWheelProvider = Provider<SuppliesTheWheel>((ref) {
  return SuppliesTheWheel(ref: ref);
});

class SuppliesTheWheel extends BasePreset {
  SuppliesTheWheel({required super.ref});

  @override
  String get name => "Supplies The Wheel";

  @override
  Future<void> start() async {
    super.start();

    final questList = [2857];
    final dropList = [
      "Unidentified 19",
      "Unidentified 13",
      "Tainted Gem",
      "Dark Crystal Shard",
      "Diamond of Nulgath",
      "Voucher of Nulgath",
      "Voucher of Nulgath (non-mem)",
      "Random Weapon of Nulgath",
      "Gem of Nulgath",
      "Relic of Chaos",
    ];
    final targetPriority = ["Staff of Inversion", "Escherion"];
    List<int> skills = [0, 1, 2, 0, 3, 4];
    int i = 0;

    // register quest completion handler
    ref.read(questCompletionHandlerProvider(questList));

    // register item drop handler
    ref.read(itemDropHandlerProvider(dropList));

    await mapCmd.joinMap(mapName: "escherion", roomNumber: 9099);
    await mapCmd.jumpToCell(cell: "Boss");

    while (isRunning) {
      await combatCmd.useSkill(
        index: skills[i],
        targetPriority: targetPriority,
      );

      i++;
      if (i >= skills.length) {
        i = 0;
      }
    }
  }

  @override
  Widget options(BuildContext context) {
    return Column(
      children: [
        Card(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Text("Supplies the Wheel Quest Farm"),
            ),
          ),
        ),
      ],
    );
  }
}
