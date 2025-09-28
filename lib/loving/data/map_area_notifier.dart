import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/game/area_map.dart';
import '../../model/game/area_player.dart';
import '../../model/game/aura.dart';
import '../../model/game/monster.dart';

final areaMapProvider = StateNotifierProvider<AreaMapNotifier, AreaMap>((ref) {
  return AreaMapNotifier();
});

class AreaMapNotifier extends StateNotifier<AreaMap> {
  AreaMapNotifier() : super(const AreaMap());

  void clear() {
    state = const AreaMap();
  }

  void update(AreaMap Function(AreaMap) updateFn) {
    state = updateFn(state);
  }

  void setMonsters(List<Monster> monsters) {
    update((areaMap) => areaMap.copyWith(monsters: monsters));
  }

  Monster getMonster(int monMapId) {
    return state.monsters.firstWhere((element) => element.monMapId == monMapId);
  }

  void updateMonster(Monster monster) {
    final index = state.monsters.indexWhere(
      (element) => element.monMapId == monster.monMapId,
    );
    if (index != -1) {
      state.monsters[index] = monster;
    }
  }

  void addOrUpdateMonsterAura(int monMapId, List<Aura> auras) {
    final monster = getMonster(monMapId);
    final current = [...monster.auras];
    for (final aura in auras) {
      final index = current.indexWhere((a) => a.name == aura.name);
      if (index != -1) {
        current[index] = aura;
      } else {
        current.add(aura);
      }
    }
    updateMonster(monster.copyWith(auras: current));
  }

  void removeMonsterAura(int monMapId, String auraName) {
    final monster = getMonster(monMapId);
    updateMonster(
      monster.copyWith(
        auras: monster.auras.where((a) => a.name != auraName).toList(),
      ),
    );
  }

  void clearMonsterAura(int monMapId) {
    final monster = getMonster(monMapId);
    updateMonster(monster.copyWith(auras: []));
  }

  AreaPlayer getPlayer(String userName) {
    return state.areaPlayers.firstWhere(
      (element) => element.username.toLowerCase() == userName,
    );
  }

  void updatePlayer(AreaPlayer player) {
    final index = state.areaPlayers.indexWhere(
      (element) => element.id == player.id,
    );
    if (index != -1) {
      state.areaPlayers[index] = player;
    } else {
      state.areaPlayers.add(player);
    }
  }

  void removePlayer(String userName) {
    state.areaPlayers.removeWhere(
      (element) => element.username.toLowerCase() == userName,
    );
  }
}
