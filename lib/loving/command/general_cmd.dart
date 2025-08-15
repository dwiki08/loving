import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/socket/socket_client.dart';

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

  Player get _player => _ref.read(playerProvider);

  PlayerNotifier get _playerNotifier => _ref.read(playerProvider.notifier);

  void addLog(String message) {
    _client.addLog(message: message, packetSender: PacketSender.client);
  }

  Future<void> sendChat({required String message}) async {
    _client.addLog(
      message: "Sending chat: $message",
      packetSender: PacketSender.client,
    );
    _client.sendChat(message);
    await Future.delayed(defaultDelay);
  }
}
