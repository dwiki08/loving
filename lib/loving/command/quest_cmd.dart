import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/game/player.dart';
import '../data/player_notifier.dart';
import '../socket/socket_client.dart';
import 'base_cmd.dart';

final questCmdProvider = Provider<QuestCmd>((ref) {
  final client = ref.read(socketProvider);
  return QuestCmd(ref, client);
});

class QuestCmd extends BaseCmd {
  QuestCmd(super.ref, super.client);

  Player get _player => ref.read(playerProvider);
}
