import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/loving/command/base_cmd.dart';
import 'package:loving/loving/socket/socket_client.dart';

import '../../model/game/player.dart';

final playerCmdProvider = Provider<PlayerCmd>((ref) {
  final client = ref.read(socketProvider);
  return PlayerCmd(ref, client);
});

class PlayerCmd extends BaseCmd {
  PlayerCmd(super.ref, super.client);

  Player getPlayer() {
    return player;
  }

  Future<void> acceptDroppedItem(String itemName) async {
    log("acceptDroppedItem: $itemName");
    final item = player.getDroppedItemByName(itemName);
    if (item != null) {
      client.sendPacket('%xt%zm%getDrop%${player.userId}%${item.id}%');
      await delay();
    }
  }
}
