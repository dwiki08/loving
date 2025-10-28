import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/preset/base_preset.dart';

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
