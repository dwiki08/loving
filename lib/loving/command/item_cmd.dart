import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/game/player.dart';
import '../data/player_notifier.dart';
import '../socket/socket_client.dart';
import 'base_cmd.dart';

final itemCmdProvider = Provider<ItemCmd>((ref) {
  final client = ref.read(socketProvider);
  return ItemCmd(ref, client);
});

class ItemCmd extends BaseCmd {
  ItemCmd(super.ref, super.client);

  Player get _player => ref.read(playerProvider);
}
