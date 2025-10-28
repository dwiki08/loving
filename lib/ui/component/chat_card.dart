import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loving/model/game/chat.dart';

class ChatCard extends HookWidget {
  const ChatCard({super.key, required this.msg});

  final Chat msg;

  @override
  Widget build(BuildContext context) {
    Color typeColor;
    switch (msg.type) {
      case ChatType.world:
        typeColor =
            Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
        break;
      case ChatType.whisper:
        typeColor = Colors.purple;
        break;
      case ChatType.party:
        typeColor = Colors.yellow;
        break;
      case ChatType.guild:
        typeColor = Colors.orange;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: () {
          Clipboard.setData(
            ClipboardData(
              text: "[${msg.timestamp}] ${msg.sender} : ${msg.message}",
            ),
          );
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "[${msg.type.name.toUpperCase()}] ",
                    style: TextStyle(color: typeColor),
                  ),
                  Expanded(child: Text("${msg.sender} : ${msg.message}")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
