import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/socket/socket_client.dart';

import '../../../common/utils.dart';
import '../../../model/game/chat.dart';
import '../../../model/packet.dart';
import '../../data/map_area_notifier.dart';

class FlashPacketHandler {
  final Ref _ref;

  FlashPacketHandler({required Ref ref}) : _ref = ref;

  AreaMapNotifier get _areaMapNotifier => _ref.read(areaMapProvider.notifier);

  void handle(SocketClient s, String msg) {
    final areaMap = _ref.read(areaMapProvider);

    if (msg.contains("%xt%loginResponse%-1%true%")) {
      s.addLog(
        message: 'Joining battleon...',
        packetSender: PacketSender.client,
      );
      s.sendPacket("%xt%zm%firstJoin%1%");
      s.sendPacket("%xt%zm%cmd%1%ignoreList%\$clearAll%");
    }
    if (msg.contains('You joined')) {
      s.sendPacket("%xt%zm%retrieveUserDatas%${areaMap.areaId}%${s.user.id}%");
    }
    if (msg.contains('%server%')) {
      s.addLog(message: msg.split('%')[4], packetSender: PacketSender.server);
    }
    if (msg.contains('warning')) {
      s.addLog(message: msg.split('%')[4], packetSender: PacketSender.server);
    }
    if (msg.contains('mvts')) {
      // %xt%uotls%-1%sulcata2%mvts:-1,px:500,py:375,strPad:Left,bResting:false,mvtd:0,tx:0,ty:0,strFrame:r1a%
    }
    if (msg.contains('exitArea')) {
      // %xt%exitArea%-1%23344%username%
      _areaMapNotifier.removePlayer(msg.split('%')[5]);
    }
    if (msg.contains("chatm")) {
      final parts = msg.split('%');
      if (parts.length >= 6) {
        String text = parts[4]
            .replaceAll("zone~", "")
            .replaceAll("guild~", "")
            .replaceAll("whisper~", "")
            .replaceAll("party~", "");
        String sender = parts[5];
        ChatType type = ChatType.world;
        switch (parts[4]) {
          case "zone~":
            type = ChatType.world;
            break;
          case "guild~":
            type = ChatType.guild;
            break;
          case "whisper~":
            type = ChatType.whisper;
            break;
          case "party~":
            type = ChatType.party;
            break;
        }
        s.addChat(
          Chat(
            sender: sender,
            message: text,
            type: type,
            timestamp: getTimestamp(),
          ),
        );
      }
    }
  }
}
