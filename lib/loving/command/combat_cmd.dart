import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/data/map_area_notifier.dart';
import 'package:loving/loving/data/player_notifier.dart';
import 'package:loving/loving/socket/socket_client.dart';
import 'package:loving/model/game/area_map.dart';

import '../../model/game/player.dart';
import '../../model/game/skill.dart';
import 'base_cmd.dart';

final combatCmdProvider = Provider<CombatCmd>((ref) {
  final client = ref.read(socketProvider);
  return CombatCmd(ref, client);
});

class CombatCmd extends BaseCmd {
  CombatCmd(super.ref, super.client);

  Player get _player => ref.read(playerProvider);

  AreaMap get _areaMap => ref.read(areaMapProvider);

  int _reloadTimeMs = 0;

  Future<void> _executeSkill(Skill skill, List<int> ids) async {
    if (ids.isEmpty) return;
    var exe = ids
        .map((id) {
          return "${skill.ref}>${skill.targetType.value}:$id";
        })
        .join(",");
    client.sendPacket("%xt%zm%gar%1%0%$exe%wvz%");
    await Future.delayed(const Duration(milliseconds: 200));
  }

  List<int> _prioritizedMonsterIds(List<String> targetPriority) {
    // Get monsters in current cell
    final currentCell = _player.cell;
    final monsters =
        _areaMap
            .getMonsters(currentCell)
            .where((monster) => monster.isAlive)
            .toList();

    // Sorting monster by priority
    final sortedMonsters = [...monsters];
    final normalizedPriority =
        targetPriority.map((e) => e.toLowerCase()).toList();
    sortedMonsters.sort((a, b) {
      String aKey = a.getMonName.toLowerCase();
      String bKey = b.getMonName.toLowerCase();

      if (normalizedPriority.any((p) => p.startsWith("id."))) {
        aKey = "id.${a.monMapId}";
        bKey = "id.${b.monMapId}";
      }

      final aIndex = normalizedPriority.indexOf(aKey);
      final bIndex = normalizedPriority.indexOf(bKey);

      final safeA = aIndex == -1 ? normalizedPriority.length : aIndex;
      final safeB = bIndex == -1 ? normalizedPriority.length : bIndex;

      return safeA.compareTo(safeB);
    });

    return sortedMonsters.map((e) => e.monMapId).toList();
  }

  List<int> _currentCellPlayerIds() {
    final currentCell = _player.cell;
    final myId = _player.userId;
    final players =
        _areaMap.areaPlayers
            .where((element) => element.cell == currentCell)
            .toList();
    final playerIds =
        players
            .map((e) => e.id)
            .where((id) => id != myId) // Filter out myId
            .toList();
    playerIds.insert(0, myId); // Add myId to the beginning
    return playerIds;
  }

  /// Uses a skill based on the provided parameters.
  ///
  /// [index] The index of the skill to use (0 - 5).
  /// [targetPriority] A list of strings defining target priority.
  ///   - Format `['Staff of Inversion','Escherion']` to prioritize by monster name.
  ///   - Format `['id.5','id.3']` to prioritize by monMapId.
  /// [reloadDelay] The delay in milliseconds before the skill can be used again (default is 500ms).
  Future<void> useSkill({
    required int index,
    List<String> targetPriority = const [],
    int reloadDelay = 700,
  }) async {
    if (index < 0 || index > 5) {
      return;
    }

    final skill = _player.skills[index];
    if (skill.remainingCooldown > 0 ||
        skill.mana * _player.skillCdr > _player.currentMP) {
      return;
    }

    if (index != 0 && _reloadTimeMs > DateTime.now().millisecondsSinceEpoch) {
      await Future.delayed(
        Duration(
          milliseconds: _reloadTimeMs - DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }

    List<int> ids = [];
    switch (skill.targetType) {
      case TargetType.monster:
        ids = _prioritizedMonsterIds(targetPriority);
        break;
      case TargetType.player:
        ids = _currentCellPlayerIds();
        break;
      case TargetType.self:
        ids = [_player.userId];
        break;
    }

    final targetIds = ids.take(skill.tgtMax).toList();
    await _executeSkill(skill, targetIds);

    _reloadTimeMs = DateTime.now().millisecondsSinceEpoch + reloadDelay;
  }
}
