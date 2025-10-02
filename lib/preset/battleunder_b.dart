import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/preset/base_preset.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../loving/handler/item_drop_handler.dart';

final battleUnderBProvider = Provider<BattleUnderB>((ref) {
  return BattleUnderB(ref: ref);
});

class BattleUnderB extends BasePreset {
  BattleUnderB({required super.ref});

  @override
  String get name => "Battle Under B";

  @override
  Future<void> start() async {
    super.start();

    ref.read(
      itemDropHandlerProvider(["Bone Dust", "Undead Essence", "Undead Energy"]),
    );

    List<int> skills = [0, 1, 2, 0, 3, 4];
    int i = 0;

    await mapCmd.joinMap(mapName: "battleunderb", roomNumber: 9099);

    while (isRunning) {
      await combatCmd.useSkill(index: skills[i]);
      await Future.delayed(const Duration(milliseconds: 100));
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
              child: Text("Test Bot"),
            ),
          ),
        ),
      ],
    );
  }
}
