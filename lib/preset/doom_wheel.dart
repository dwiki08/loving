import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'base_preset.dart';

final doomWheelProvider = Provider<DoomWheel>((ref) {
  return DoomWheel(ref: ref);
});

class DoomWheel extends BasePreset {
  DoomWheel({required super.ref});

  @override
  String get name => "Doom Wheel";

  @override
  Future<void> start() async {
    super.start();
    final player = playerCmd.getPlayer();

    await mapCmd.joinMap(mapName: "doom");

    // unbank Gear of Doom if any
    if (player.getBankItemByName("Gear of Doom") != null) {
      await playerCmd.moveItemToInventory("Gear of Doom");
      await generalCmd.delay(milliseconds: 2000);
    }

    // weekly spin
    if (player.getInventoryItemByName("Gear of Doom")?.qty == 3) {
      await questCmd.acceptQuest(3076);
      await questCmd.tryCompleteQuest(questId: 3076);
      await generalCmd.delay(milliseconds: 2000);
    }

    // daily spin MEMBER
    if (player.accessLevel > 10) {
      await questCmd.acceptQuest(3075);
      await questCmd.tryCompleteQuest(questId: 3075);
      await generalCmd.delay(milliseconds: 2000);
    }

    // check if you got EIoDA
    if (player.getInventoryItemByName("Epic Item of Digital Awesomeness") !=
        null) {
      generalCmd.addLog(
        "You have \"Epic Item of Digital Awesomeness\" in your inventory.",
      );
    }

    stop();
  }

  @override
  Widget options(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Text("Weekly and Daily Spin for Doom Wheel"),
        ),
      ),
    );
  }
}
