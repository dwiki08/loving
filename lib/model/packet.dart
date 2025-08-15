import 'package:flutter/foundation.dart';
import 'package:loving/common/extension.dart';

enum PacketSender { server, client }

enum PacketType { json, xml, flash }

@immutable
class Packet {
  final String message;
  final PacketSender packetSender;
  final bool isDebug;
  final bool isLog;
  final String timestamp;

  const Packet({
    required this.message,
    required this.packetSender,
    this.isDebug = true,
    this.isLog = false,
    required this.timestamp,
  });

  PacketType getPacketType() {
    if (message.isValidJson) {
      return PacketType.json;
    } else if (message.isValidXml) {
      return PacketType.xml;
    } else {
      return PacketType.flash;
    }
  }
}
