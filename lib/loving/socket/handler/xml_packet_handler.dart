import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/socket/socket_client.dart';
import 'package:xml/xml.dart';

import '../../../model/packet.dart';
import '../../data/player_notifier.dart';

class XmlPacketHandler {
  final Ref _ref;

  XmlPacketHandler({required Ref ref}) : _ref = ref;

  PlayerNotifier get _playerNotifier => _ref.read(playerProvider.notifier);

  void handle(SocketClient socket, String msg) {
    if (msg.contains('<cross-domain-policy>')) {
      socket.addLog(
        message: 'Connecting to server...',
        packetSender: PacketSender.client,
      );
      socket.sendPacket(
        "<msg t='sys'>"
        "<body action='login' r='0'>"
        "<login z='zone_master'>"
        "<nick><![CDATA[SPIDER#0001~${socket.loginInfo.username}~3.01]]></nick>"
        "<pword><![CDATA[${socket.loginInfo.sToken}]]></pword>"
        "</login></body></msg>",
      );
    }
    if (msg.contains('joinOK')) {
      if (!socket.isClientReady()) {
        final user = _extractUsers(msg).firstWhere((user) {
          return user.username.toLowerCase() ==
              socket.loginInfo.username.toLowerCase();
        });
        _playerNotifier.update(
          (player) => player.copyWith(userId: int.parse(user.id)),
        );
        socket.setUserData(user);
      }
    }
  }

  List<User> _extractUsers(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final userElements = document.findAllElements('u');

    final users = <User>[];

    for (final u in userElements) {
      final id = u.getAttribute('i');
      final nameElement = u.getElement('n');
      final username = nameElement?.innerText;

      if (id != null && username != null) {
        users.add(User(id: id, username: username));
      }
    }
    return users;
  }
}
