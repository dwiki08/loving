import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/command/general_cmd.dart';
import 'package:loving/loving/command/player_cmd.dart';
import 'package:loving/preset/base_preset.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../loving/command/combat_cmd.dart';
import '../loving/command/map_cmd.dart';

final suppliesTheWheelProvider = Provider<SuppliesTheWheel>((ref) {
  return SuppliesTheWheel(
    generalCmd: ref.read(generalCmdProvider),
    mapCmd: ref.read(mapCmdProvider),
    combatCmd: ref.read(combatCmdProvider),
    playerCmd: ref.read(playerCmdProvider),
  );
});

class SuppliesTheWheel extends BasePreset {
  final MapCmd mapCmd;
  final CombatCmd combatCmd;
  final PlayerCmd playerCmd;

  SuppliesTheWheel({
    required super.generalCmd,
    required this.mapCmd,
    required this.combatCmd,
    required this.playerCmd,
  });

  @override
  String get name => "Supplies The Wheel";

  @override
  Future<void> start() async {
    super.start();

    final targetPriority = ["Staff of Inversion", "Escherion"];
    List<int> skills = [0, 1, 2, 0, 3, 4];
    int i = 0;

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
