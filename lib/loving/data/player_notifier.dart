import 'package:hooks_riverpod/legacy.dart';
import 'package:loving/model/game/item.dart';

import '../../model/game/aura.dart';
import '../../model/game/player.dart';
import '../../model/game/skill.dart';

final playerProvider = StateNotifierProvider<PlayerNotifier, Player>((ref) {
  return PlayerNotifier();
});

// class to update Player data
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

  void decreaseItemQty(int itemId, int qty) {
    final current = [...state.inventoryItems];
    final index = current.indexWhere((i) => i.id == itemId);
    if (index != -1) {
      final curr = current[index];
      final newQty = curr.qty - qty;
      if (newQty <= 0) {
        current.removeAt(index);
      } else {
        current[index] = curr.copyWith(qty: newQty);
      }
    }
    state = state.copyWith(inventoryItems: current);

    final tempCurrent = [...state.tempInventoryItems];
    final tempIndex = tempCurrent.indexWhere((i) => i.id == itemId);
    if (tempIndex != -1) {
      final tempCurr = tempCurrent[tempIndex];
      final tempNewQty = tempCurr.qty - qty;
      if (tempNewQty <= 0) {
        tempCurrent.removeAt(tempIndex);
      } else {
        tempCurrent[tempIndex] = tempCurr.copyWith(qty: tempNewQty);
      }
    }
    state = state.copyWith(tempInventoryItems: tempCurrent);
  }

  void addInventoryItem(Item item) {
    final current = [...state.inventoryItems];
    final index = current.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      // just update the item qty
      final curr = current[index];
      current[index] = curr.copyWith(qty: curr.qty + item.qty);
    } else {
      current.add(item);
    }
    state = state.copyWith(inventoryItems: current);
  }

  void removeInventoryItem(Item item) {
    final current = [...state.inventoryItems];
    final index = current.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      current.removeAt(index);
    }
    state = state.copyWith(inventoryItems: current);
  }

  void addTempInventoryItem(Item item) {
    final current = [...state.tempInventoryItems];
    final index = current.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      // just update the item qty
      final curr = current[index];
      current[index] = curr.copyWith(qty: curr.qty + item.qty);
    } else {
      current.add(item);
    }
    state = state.copyWith(tempInventoryItems: current);
  }

  void removeTempInventoryItem(Item item) {
    final current = [...state.tempInventoryItems];
    final index = current.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      current.removeAt(index);
    }
    state = state.copyWith(tempInventoryItems: current);
  }

  void addBankItem(Item item) {
    final current = [...state.bankItems];
    final index = current.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      // just update the item qty
      final curr = current[index];
      current[index] = curr.copyWith(qty: curr.qty + item.qty);
    } else {
      current.add(item);
    }
    state = state.copyWith(bankItems: current);
  }

  void removeBankItem(Item item) {
    final current = [...state.bankItems];
    final index = current.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      current.removeAt(index);
    }
    state = state.copyWith(bankItems: current);
  }

  void addDroppedItem(Item item) {
    final current = [...state.droppedItems];
    final index = current.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      // just update the item qty
      final curr = current[index];
      current[index] = curr.copyWith(qty: curr.qty + item.qty);
    } else {
      current.add(item);
    }
    state = state.copyWith(droppedItems: current);
  }

  void removeDroppedItem(Item item) {
    final current = [...state.droppedItems];
    final index = current.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      current.removeAt(index);
    }
    state = state.copyWith(droppedItems: current);
  }
}
