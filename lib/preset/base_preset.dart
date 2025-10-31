import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/loving/command/combat_cmd.dart';
import 'package:loving/loving/command/player_cmd.dart';
import 'package:loving/loving/command/quest_cmd.dart';

import '../loving/command/general_cmd.dart';
import '../loving/command/map_cmd.dart';
import '../loving/data/player_notifier.dart';

abstract class BasePreset {
  final Ref ref;

  String get name;

  bool get isRunning => _isRunning;

  bool _isRunning = false;

  BasePreset({required this.ref});

  GeneralCmd get generalCmd => ref.read(generalCmdProvider);

  PlayerCmd get playerCmd => ref.read(playerCmdProvider);

  MapCmd get mapCmd => ref.read(mapCmdProvider);

  CombatCmd get combatCmd => ref.read(combatCmdProvider);

  QuestCmd get questCmd => ref.read(questCmdProvider);

  Future<void> start() async {
    _isRunning = true;
    generalCmd.addLog('Starting \'$name\' preset...');
  }

  Future<void> stop() async {
    _isRunning = false;
    await generalCmd.leaveCombat();
    generalCmd.addLog('\'$name\' is stopped.');
  }

  Future<void> killForItem(
    String itemName,
    int qty, [
    List<String> targetPriority = const ['*'],
    List<int> skills = const [0, 1, 2, 0, 3, 4],
  ]) async {
    if (ref.read(playerProvider).hasItemByName(itemName, qty)) {
      return;
    }

    int i = 0;
    while (isRunning) {
      if (ref.read(playerProvider).hasItemByName(itemName, qty)) {
        return;
      }
      await combatCmd.useSkill(
        index: skills[i],
        targetPriority: targetPriority,
      );
      i = (i + 1) % skills.length;
    }
  }

  Widget options(BuildContext context);
}
