import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loving/common/extension.dart';
import 'package:xml/xml.dart';

import '../../model/packet.dart';

class LogCard extends HookWidget {
  const LogCard({super.key, required this.msg});

  final Packet msg;

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);
    String formattedMessage(String message) {
      if (message.isValidJson) {
        var jsonObject = json.decode(message);
        return const JsonEncoder.withIndent('  ').convert(jsonObject);
      } else if (message.isValidXml) {
        var xmlDocument = XmlDocument.parse(message);
        return xmlDocument.toXmlString(pretty: true);
      } else {
        return message;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: msg.packetSender == PacketSender.server ? Color(0xFFEDE2F7) : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          isExpanded.value = !isExpanded.value;
        },
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: msg.message));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "[${msg.timestamp}]",
                style: const TextStyle(color: Colors.blue),
              ),
              Text(
                formattedMessage(msg.message),
                style: const TextStyle(fontSize: 14),
                maxLines: isExpanded.value ? null : 3,
                overflow: isExpanded.value
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
