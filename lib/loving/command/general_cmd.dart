import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/data/map_area_notifier.dart';
import 'package:loving/loving/socket/socket_client.dart';
import 'package:loving/model/game/area_map.dart';

import '../../common/utils.dart';
import '../../model/game/player.dart';
import '../../model/packet.dart';
import '../data/player_notifier.dart';

final generalCmdProvider = Provider<GeneralCmd>((ref) {
  final client = ref.read(socketProvider);
  return GeneralCmd(ref, client);
});

class GeneralCmd {
  final Ref _ref;
  final SocketClient _client;

  GeneralCmd(this._ref, this._client);

  AreaMap get _areaMap => _ref.read(areaMapProvider);

  Player get _player => _ref.read(playerProvider);

  void addLog(String message) {
    _client.addLog(message: message, packetSender: PacketSender.client);
  }

  Future<void> sendChat({required String message}) async {
    _client.addLog(
      message: "Sending chat: $message",
      packetSender: PacketSender.client,
    );
    String packet = "%xt%zm%message%${_areaMap.areaId}%$message%zone%";
    _client.sendPacket(packet);
    await Future.delayed(defaultDelay);
  }

  Future<void> leaveCombat() async {
    _client.sendPacket(
      "%xt%zm%moveToCell%${_areaMap.areaId}%${_player.cell}%${_player.pad}%",
    );
    await Future.delayed(Duration(seconds: 1));
  }
}
