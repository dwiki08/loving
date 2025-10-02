import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/command/combat_cmd.dart';
import 'package:loving/loving/command/player_cmd.dart';
import 'package:loving/loving/command/quest_cmd.dart';

import '../loving/command/general_cmd.dart';
import '../loving/command/map_cmd.dart';

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

  Widget options(BuildContext context);
}
