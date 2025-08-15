import 'package:flutter/material.dart';
import 'package:loving/model/game/chat.dart';

import 'chat_card.dart';

class ChatList extends StatelessWidget {
  const ChatList({
    super.key,
    required List<Chat> chats,
    required ScrollController scrollController,
  }) : _chats = chats,
       _scrollController = scrollController;

  final List<Chat> _chats;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final msg = _chats.reversed.toList()[index];
        return ChatCard(msg: msg);
      },
    );
  }
}
