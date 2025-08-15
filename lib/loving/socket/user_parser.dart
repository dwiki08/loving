import 'package:xml/xml.dart';

class UserParser {
  final String username;
  List<String> userIds = [];
  String? usernameId;

  UserParser(this.username);

  void extractUserIds(String xmlMessage) {
    final root = XmlDocument.parse(xmlMessage);
    userIds.clear();
    usernameId = null;

    final users = root.findAllElements('u');

    for (final user in users) {
      final userId = user.getAttribute('i');
      if (userId != null) {
        userIds.add(userId);

        final nameElement = user.getElement('n');
        final name = nameElement?.innerText;

        if (name != null && name.toLowerCase() == username.toLowerCase()) {
          usernameId = userId;
        }
      }
    }
  }
}
