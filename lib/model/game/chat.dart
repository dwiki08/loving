import 'package:flutter/foundation.dart';

enum ChatType { world, whisper, guild, party }

@immutable
class Chat {
  final String sender;
  final String message;
  final ChatType type;
  final String timestamp;

  const Chat({
    required this.message,
    required this.sender,
    required this.type,
    required this.timestamp,
  });
}
