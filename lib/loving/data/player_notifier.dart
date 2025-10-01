import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/game/aura.dart';
import '../../model/game/player.dart';
import '../../model/game/skill.dart';

final playerProvider = StateNotifierProvider<PlayerNotifier, Player>((ref) {
  return PlayerNotifier();
});

class PlayerNotifier extends StateNotifier<Player> {
  PlayerNotifier() : super(const Player());

  void clear() {
    state = const Player();
  }

  void update(Player Function(Player) updateFn) {
    state = updateFn(state);
  }

  void updateSkill(Skill Function(Skill) updateFn) {
    final skills = [...state.skills];
    for (final skill in skills) {
      final index = skills.indexOf(skill);
      skills[index] = updateFn(skill);
    }
    state = state.copyWith(skills: skills);
  }

  void addOrUpdateAura(List<Aura> auras) {
    final current = [...state.auras];
    for (final aura in auras) {
      final index = current.indexWhere((a) => a.name == aura.name);
      if (index != -1) {
        current[index] = aura;
      } else {
        current.add(aura);
      }
    }
    state = state.copyWith(auras: current);
  }

  void removeAura(String auraName) {
    state = state.copyWith(
      auras: state.auras.where((a) => a.name != auraName).toList(),
    );
  }

  void clearAuras() {
    state = state.copyWith(auras: []);
  }
}
