import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/data/map_area_notifier.dart';
import 'package:loving/loving/socket/socket_client.dart';
import 'package:loving/model/game/area_map.dart';

import '../../model/game/player.dart';
import '../data/player_notifier.dart';

final playerCmdProvider = Provider<PlayerCmd>((ref) {
  final client = ref.read(socketProvider);
  return PlayerCmd(ref, client);
});

class PlayerCmd {
  final Ref _ref;
  final SocketClient _client;

  PlayerCmd(this._ref, this._client);

  Player get _player => _ref.read(playerProvider);

  AreaMap get _areaMap => _ref.read(areaMapProvider);

  Player getPlayer() {
    return _player;
  }
}
