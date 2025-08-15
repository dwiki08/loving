import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/game/chat.dart';
import '../../../component/chat_list.dart';
import '../../../theme.dart';

class ChatBody extends ConsumerStatefulWidget {
  const ChatBody({super.key, required this.chats, required this.onSendChat});

  final List<Chat> chats;
  final Function(String text) onSendChat;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatContentState();
}

class _ChatContentState extends ConsumerState<ChatBody> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: textFieldDecoration(
                    context: context,
                    label: 'Type a message...',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final text = _textController.text;
                  if (text.isNotEmpty) {
                    widget.onSendChat(text);
                    _textController.clear();
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
          child:
              widget.chats.isEmpty
                  ? const Center(child: Text('No chats to show'))
                  : ChatList(
                    chats: widget.chats.toList()..take(100),
                    scrollController: _scrollController,
                  ),
        ),
      ],
    );
  }
}
