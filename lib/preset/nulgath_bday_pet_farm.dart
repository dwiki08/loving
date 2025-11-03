import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/preset/base_preset.dart';

import '../loving/handler/item_drop_handler.dart';
import '../loving/handler/quest_completion_handler.dart';

final nulgathBdayFarmProvider = Provider<NulgathBirthdayPetFarm>((ref) {
  return NulgathBirthdayPetFarm(ref: ref);
});

class NulgathBirthdayPetFarm extends BasePreset {
  NulgathBirthdayPetFarm({required super.ref});

  var completionCount = 0;

  @override
  String get name => "Nulgath B'day Farm";

  @override
  Future<void> start() async {
    super.start();

    final roomNumber = 9099;
    final questList = [6697];
    final dropList = [
      "Unidentified 13",
      "Tainted Gem",
      "Dark Crystal Shard",
      "Diamond of Nulgath",
      "Voucher of Nulgath",
      "Voucher of Nulgath (non-mem)",
      "Totem of Nulgath",
      "Gem of Nulgath",
      "Fiend Token",
      "Blood Gem of the Archfiend",
      "Archfiend's Birthday Cake",
      "Fiendish Caladbolg",
      "Essence of Nulgath",
      "Unidentified 10",
    ];
    final multi = 1;

    // register quest completion handler
    ref.read(questCompletionHandlerProvider(questList));

    // register item drop handler
    ref.read(itemDropHandlerProvider(dropList));

    while (isRunning) {
      await mapCmd.joinMap(mapName: 'mobius', roomNumber: roomNumber);
      await mapCmd.jumpToCell(cell: 'Slugfit', pad: 'Bottom');
      await killForItem("Cyclops Horn", 3 * multi, ['Cyclops Warlord']);
      await killForItem("Slugfit Horn", 5 * multi, ['Slugfit']);
      if (!isRunning) break;

      await mapCmd.joinMap(mapName: 'tercessuinotlim', roomNumber: roomNumber);
      await mapCmd.jumpToCell(cell: 'm2', pad: 'Left');
      await killForItem("Makai Fang", 5 * multi);
      await mapCmd.jumpToCell(cell: 'Swindle', pad: 'Left');
      if (!isRunning) break;

      await mapCmd.joinMap(mapName: 'hydra', roomNumber: roomNumber);
      await mapCmd.jumpToCell(cell: 'Rune2', pad: 'Left');
      await killForItem("Imp Flame", 3 * multi);
      if (!isRunning) break;

      await mapCmd.joinMap(mapName: 'greenguardwest', roomNumber: roomNumber);
      await mapCmd.jumpToCell(cell: 'West12', pad: 'Up');
      await killForItem("Wereboar Tusk", 2 * multi);
      if (!isRunning) break;

      await questCmd.tryCompleteQuest(questId: 6697);
      await generalCmd.delay(milliseconds: 3000);

      completionCount += multi;
      await updateNotificationStatus('Completed: $completionCount times');
    }

    stop();
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
              child: Column(
                children: [
                  Text("Nulgath Bday Gift Pet Quest Farm"),
                  Text("Completion : $completionCount times"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
