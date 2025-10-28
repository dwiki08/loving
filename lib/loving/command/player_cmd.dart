import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/loving/command/base_cmd.dart';
import 'package:loving/loving/socket/socket_client.dart';

import '../../model/game/player.dart';
import '../data/player_notifier.dart';

final playerCmdProvider = Provider<PlayerCmd>((ref) {
  final client = ref.read(socketProvider);
  return PlayerCmd(ref, client);
});

class PlayerCmd extends BaseCmd {
  PlayerCmd(super.ref, super.client);

  Player get _player => ref.read(playerProvider);

  Player getPlayer() {
    return _player;
  }

  Future<void> acceptDroppedItem(String itemName) async {
    final item = _player.getDroppedItemByName(itemName);
    if (item != null) {
      client.sendPacket('%xt%zm%getDrop%${_player.userId}%${item.id}%');
      await delay();
    }
  }
}
