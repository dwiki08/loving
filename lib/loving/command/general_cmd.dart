import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/loving/data/map_area_notifier.dart';
import 'package:loving/model/game/area_map.dart';

import '../../model/game/player.dart';
import '../../model/packet.dart';
import '../data/player_notifier.dart';
import '../socket/socket_client.dart';
import 'base_cmd.dart';

final generalCmdProvider = Provider<GeneralCmd>((ref) {
  final client = ref.read(socketProvider);
  return GeneralCmd(ref, client);
});

class GeneralCmd extends BaseCmd {
  GeneralCmd(super.ref, super.client);

  AreaMap get _areaMap => ref.read(areaMapProvider);

  Player get _player => ref.read(playerProvider);

  void addLog(String message) {
    client.addLog(message: message, packetSender: PacketSender.client);
  }

  Future<void> sendChat({required String message}) async {
    client.addLog(
      message: "Sending chat: $message",
      packetSender: PacketSender.client,
    );
    String packet = "%xt%zm%message%${_areaMap.areaId}%$message%zone%";
    client.sendPacket(packet);
    await delay();
  }

  Future<void> leaveCombat() async {
    client.sendPacket(
      "%xt%zm%moveToCell%${_areaMap.areaId}%${_player.cell}%${_player.pad}%",
    );
    await Future.delayed(Duration(seconds: 1));
  }
}
