import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/loving/command/base_cmd.dart';

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

class MapCmd extends BaseCmd {
  MapCmd(super.ref, super.client);

  Player get _player => ref.read(playerProvider);

  AreaMap get _map => ref.read(areaMapProvider);

  PlayerNotifier get _playerNotifier => ref.read(playerProvider.notifier);

  String currentMap() {
    return _map.name;
  }

  Future<void> joinMap({required String mapName, int? roomNumber}) async {
    if (_map.name.toLowerCase() == mapName.toLowerCase()) return;
    client.addLog(
      message: "Joining map: $mapName",
      packetSender: PacketSender.client,
    );
    client.sendPacket(
      roomNumber != null
          ? "%xt%zm%cmd%1%tfer%${_player.username}%$mapName-$roomNumber%"
          : "%xt%zm%cmd%1%tfer%${_player.username}%$mapName%",
    );
    await waitFor(
      condition: () async => _map.name.toLowerCase() == mapName.toLowerCase(),
    );
  }

  Future<void> joinHouse({required String house}) async {
    client.addLog(
      message: "Joining house: $house",
      packetSender: PacketSender.client,
    );
    client.sendPacket("%xt%zm%house%1%$house%");
    await waitFor(
      condition: () async => _map.name.toLowerCase() == 'house',
    );
  }

  Future<void> jumpToCell({required String cell, String pad = "Left"}) async {
    if (_player.cell.toLowerCase() == cell.toLowerCase()) return;
    client.addLog(
      message: "Moving to cell: $cell pad: $pad",
      packetSender: PacketSender.client,
    );
    client.sendPacket("%xt%zm%moveToCell%${_map.areaId}%$cell%$pad%");
    _playerNotifier.update((player) => player.copyWith(cell: cell, pad: pad));
    await delay();
  }

  Future<void> walkTo({required int x, required int y}) async {
    if (_player.posX == x && _player.posY == y) return;
    client.addLog(
      message: "Walking to: $x, $y",
      packetSender: PacketSender.client,
    );
    client.sendPacket("%xt%zm%mv%${_map.areaId}%$x%$y%10%");
    _playerNotifier.update((player) => player.copyWith(posX: x, posY: y));
    await delay();
  }
}
