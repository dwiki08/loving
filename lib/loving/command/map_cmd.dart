import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/loving/command/base_cmd.dart';

import '../../model/packet.dart';
import '../data/player_notifier.dart';
import '../socket/socket_client.dart';

final mapCmdProvider = Provider<MapCmd>((ref) {
  final client = ref.watch(socketProvider);
  return MapCmd(ref, client);
});

class MapCmd extends BaseCmd {
  MapCmd(super.ref, super.client);

  PlayerNotifier get _playerNotifier => ref.read(playerProvider.notifier);

  String currentMap() {
    return areaMap.name;
  }

  Future<void> joinMap({
    required String mapName,
    int? roomNumber,
    bool leaveCombatFirst = true,
  }) async {
    if (areaMap.name.toLowerCase() == mapName.toLowerCase()) return;
    if (leaveCombatFirst) await leaveCombat();

    client.addLog(
      message: "Joining map: $mapName",
      packetSender: PacketSender.client,
    );
    client.sendPacket(
      roomNumber != null
          ? "%xt%zm%cmd%1%tfer%${player.username}%$mapName-$roomNumber%"
          : "%xt%zm%cmd%1%tfer%${player.username}%$mapName%",
    );
    await waitFor(
      condition: () async =>
      areaMap.name.toLowerCase() == mapName.toLowerCase(),
    );
  }

  Future<void> joinHouse(
      {required String house, bool leaveCombatFirst = true}) async {
    if (leaveCombatFirst) await leaveCombat();
    client.addLog(
      message: "Joining house: $house",
      packetSender: PacketSender.client,
    );
    client.sendPacket("%xt%zm%house%1%$house%");
    await waitFor(condition: () async => areaMap.name.toLowerCase() == 'house');
  }

  Future<void> jumpToCell({required String cell, String pad = "Left"}) async {
    if (player.cell.toLowerCase() == cell.toLowerCase()) return;
    client.addLog(
      message: "Moving to cell: $cell pad: $pad",
      packetSender: PacketSender.client,
    );
    client.sendPacket("%xt%zm%moveToCell%${areaMap.areaId}%$cell%$pad%");
    _playerNotifier.update((player) => player.copyWith(cell: cell, pad: pad));
    await delay();
  }

  Future<void> walkTo({required int x, required int y}) async {
    if (player.posX == x && player.posY == y) return;
    client.addLog(
      message: "Walking to: $x, $y",
      packetSender: PacketSender.client,
    );
    client.sendPacket("%xt%zm%mv%${areaMap.areaId}%$x%$y%10%");
    _playerNotifier.update((player) => player.copyWith(posX: x, posY: y));
    await delay();
  }
}
