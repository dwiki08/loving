import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/game/aura.dart';
import '../../model/game/item.dart';
import '../../model/game/player.dart';

final playerProvider = StateNotifierProvider<PlayerNotifier, Player>((ref) {
  return PlayerNotifier();
});

class PlayerNotifier extends StateNotifier<Player> {
  PlayerNotifier() : super(const Player());

  void update(Player player) {
    state = player;
  }

  void clear() {
    state = const Player();
  }

  void setCharId(String charId) {
    state = state.copyWith(charId: charId);
  }

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  void setCellPad({required String cell, required String pad}) {
    state = state.copyWith(cell: cell, pad: pad);
  }

  void setPosition({required int posX, required int posY}) {
    state = state.copyWith(posX: posX, posY: posY);
  }

  void setEquipments(List<Item> equipments) {
    state = state.copyWith(equipments: equipments);
  }

  void setInventoryItems(List<Item> inventoryItems) {
    state = state.copyWith(inventoryItems: inventoryItems);
  }

  void setTempInventoryItems(List<Item> tempInventoryItems) {
    state = state.copyWith(tempInventoryItems: tempInventoryItems);
  }

  void setBankItems(List<Item> bankItems) {
    state = state.copyWith(bankItems: bankItems);
  }

  void setTotalGold(double totalGold) {
    state = state.copyWith(totalGold: totalGold);
  }

  void setMaxHP(int maxHP) {
    state = state.copyWith(maxHP: maxHP);
  }

  void setCurrentHP(int currentHP) {
    state = state.copyWith(currentHP: currentHP);
  }

  void setCurrentMP(int currentMP) {
    state = state.copyWith(currentMP: currentMP);
  }

  void setStatus(PlayerStatus status) {
    state = state.copyWith(status: status);
  }

  void setAuras(List<Aura> auras) {
    state = state.copyWith(auras: auras);
  }
}
