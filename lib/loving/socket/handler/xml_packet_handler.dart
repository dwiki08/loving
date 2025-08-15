import 'package:loving/loving/socket/socket_client.dart';
import 'package:xml/xml.dart';

import '../../../model/packet.dart';

void handlePacketXml(SocketClient s, String message) {
  if (message.contains('<cross-domain-policy>')) {
    s.addLog(
      message: 'Connecting to server...',
      packetSender: PacketSender.client,
    );
    s.sendPacket(
      "<msg t='sys'>"
      "<body action='login' r='0'>"
      "<login z='zone_master'>"
      "<nick><![CDATA[SPIDER#0001~${s.loginInfo.username}~3.01]]></nick>"
      "<pword><![CDATA[${s.loginInfo.sToken}]]></pword>"
      "</login></body></msg>",
    );
  }
  if (message.contains('joinOK')) {
    if (!s.isClientReady()) {
      s.setUserData(
        _extractUsers(message).firstWhere(
          (user) =>
              user.username.toLowerCase() == s.loginInfo.username.toLowerCase(),
        ),
      );
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
