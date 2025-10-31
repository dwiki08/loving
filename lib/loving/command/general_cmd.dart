import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/packet.dart';
import '../socket/socket_client.dart';
import 'base_cmd.dart';

final generalCmdProvider = Provider<GeneralCmd>((ref) {
  final client = ref.read(socketProvider);
  return GeneralCmd(ref, client);
});

class GeneralCmd extends BaseCmd {
  GeneralCmd(super.ref, super.client);

  void addLog(String message) {
    client.addLog(message: message, packetSender: PacketSender.client);
  }

  Future<void> sendChat({required String message}) async {
    client.addLog(
      message: "Sending chat: $message",
      packetSender: PacketSender.client,
    );
    String packet = "%xt%zm%message%${areaMap.areaId}%$message%zone%";
    client.sendPacket(packet);
    await delay();
  }

  @override
  Future<void> leaveCombat() async {
    super.leaveCombat();
  }
}
