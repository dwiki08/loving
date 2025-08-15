import 'package:flutter/material.dart';

import '../../model/packet.dart';
import 'log_card.dart';

class LogList extends StatelessWidget {
  const LogList({
    super.key,
    required List<Packet> packets,
    required ScrollController scrollController,
  }) : _packets = packets,
       _scrollController = scrollController;

  final List<Packet> _packets;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: _packets.length,
      itemBuilder: (context, index) {
        final msg = _packets[index];
        return LogCard(msg: msg);
      },
    );
  }
}
