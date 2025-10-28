import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../model/game/chat.dart';
import '../../../component/chat_list.dart';
import '../../../theme.dart';

class ChatBody extends HookConsumerWidget {
  const ChatBody({super.key, required this.chats, required this.onSendChat});

  final List<Chat> chats;
  final Function(String text) onSendChat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final textController = useTextEditingController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: textFieldDecoration(
                    context: context,
                    label: 'Type a message...',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final text = textController.text;
                  if (text.isNotEmpty) {
                    onSendChat(text);
                    textController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const SizedBox(height: 46, child: Icon(Icons.send)),
              ),
            ],
          ),
        ),
        Expanded(
          child: chats.isEmpty
              ? const Center(child: Text('No chats to show'))
              : ChatList(
                  chats: chats.toList()..take(100),
                  scrollController: scrollController,
                ),
        ),
      ],
    );
  }
}
