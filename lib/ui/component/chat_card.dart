import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loving/model/game/chat.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({super.key, required this.msg});

  final Chat msg;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    Color typeColor;
    switch (widget.msg.type) {
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
              text:
                  "[${widget.msg.timestamp}] ${widget.msg.sender} : ${widget.msg.message}",
            ),
          );
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
              Row(
                children: [
                  Text(
                    "[${widget.msg.type.name.toUpperCase()}] ",
                    style: TextStyle(color: typeColor),
                  ),
                  Text("${widget.msg.sender}: "),
                  Text(widget.msg.message),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
