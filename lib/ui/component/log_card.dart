import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loving/common/extension.dart';
import 'package:xml/xml.dart';

import '../../model/packet.dart';

class LogCard extends StatefulWidget {
  const LogCard({super.key, required this.msg});

  final Packet msg;

  @override
  State<LogCard> createState() => _LogCardState();
}

class _LogCardState extends State<LogCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
      color:
          widget.msg.packetSender == PacketSender.server
              ? null
              : Color(0xFFEDE2F7),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: widget.msg.message));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "[${widget.msg.timestamp}]",
                style: const TextStyle(color: Colors.blue),
              ),
              Text(
                formattedMessage(widget.msg.message),
                style: const TextStyle(fontSize: 14),
                maxLines: isExpanded ? null : 3,
                overflow:
                    isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
