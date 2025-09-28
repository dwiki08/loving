import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/utils.dart';
import '../../model/game/area_map.dart';
import '../../model/game/player.dart';
import '../../model/packet.dart';
import '../data/map_area_notifier.dart';
import '../data/player_notifier.dart';
import '../socket/socket_client.dart';

final mapCmdProvider = Provider<MapCmd>((ref) {
  final client = ref.watch(socketProvider);
  return MapCmd(ref, client);
});

class MapCmd {
  final Ref _ref;
  final SocketClient _socketClient;

  MapCmd(this._ref, this._socketClient);

  Player get _player => _ref.read(playerProvider);

  AreaMap get _map => _ref.read(areaMapProvider);

  PlayerNotifier get _playerNotifier => _ref.read(playerProvider.notifier);

  AreaMapNotifier get _areaMapNotifier => _ref.read(areaMapProvider.notifier);

  String currentMap() {
    return _map.name;
  }

  Future<void> joinMap({required String mapName, int? roomNumber}) async {
    _socketClient.addLog(
      message: "Joining map: $mapName",
      packetSender: PacketSender.client,
    );
    _socketClient.sendPacket(
      roomNumber != null
          ? "%xt%zm%cmd%1%tfer%${_player.username}%$mapName-$roomNumber%"
          : "%xt%zm%cmd%1%tfer%${_player.username}%$mapName%",
    );
    await Future.delayed(Duration(seconds: 3));
  }

  Future<void> joinHouse({required String house}) async {
    _socketClient.addLog(
      message: "Joining house: $house",
      packetSender: PacketSender.client,
    );
    _socketClient.sendPacket("%xt%zm%house%1%$house%");
    await Future.delayed(Duration(seconds: 3));
  }

  Future<void> jumpToCell({required String cell, String pad = "Left"}) async {
    _socketClient.addLog(
      message: "Moving to cell: $cell pad: $pad",
      packetSender: PacketSender.client,
    );
    _socketClient.sendPacket("%xt%zm%moveToCell%${_map.areaId}%$cell%$pad%");
    _playerNotifier.update((player) => player.copyWith(cell: cell, pad: pad));
    await Future.delayed(defaultDelay);
  }

  Future<void> walkTo({required int x, required int y}) async {
    _socketClient.addLog(
      message: "Walking to: $x, $y",
      packetSender: PacketSender.client,
    );
    _socketClient.sendPacket("%xt%zm%mv%${_map.areaId}%$x%$y%10%");
    _playerNotifier.update((player) => player.copyWith(posX: x, posY: y));
    await Future.delayed(defaultDelay);
  }
}
