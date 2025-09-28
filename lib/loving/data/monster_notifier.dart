import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/model/game/monster.dart';

final monstersProvider = StateNotifierProvider<MonsterNotifier, List<Monster>>((
  ref,
) {
  return MonsterNotifier();
});

class MonsterNotifier extends StateNotifier<List<Monster>> {
  MonsterNotifier() : super([]);

  void clear() {
    state = [];
  }

  void set(List<Monster> monsters) {
    state = monsters;
  }

  void update(Monster monster) {
    final index = state.indexWhere(
      (element) => element.monMapId == monster.monMapId,
    );
    if (index != -1) {
      state[index] = monster;
    }
  }
}
