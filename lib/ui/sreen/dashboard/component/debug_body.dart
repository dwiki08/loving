import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/data/player_notifier.dart';
import 'package:loving/model/packet.dart';

import '../../../../loving/data/map_area_notifier.dart';
import '../../../../model/game/area_map.dart';
import '../../../../model/game/player.dart';
import '../../../component/log_list.dart';

class DebugBody extends ConsumerStatefulWidget {
  final Player? player;
  final AreaMap? map;
  final List<Packet> packets;
  final bool showDebug;
  final Function(bool) onToggleDebug;

  const DebugBody({
    super.key,
    required this.packets,
    required this.player,
    required this.map,
    required this.showDebug,
    required this.onToggleDebug,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DebugBodyState();
}

class _DebugBodyState extends ConsumerState<DebugBody> {
  final ScrollController _scrollController = ScrollController();
  bool _showPlayer = false;
  bool _showMap = false;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _debugCard(Object jsonObj) {
    final screenHeight = MediaQuery.of(context).size.height;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.5),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: JsonViewer(jsonObj),
            ),
          ),
        ),
      ),
    );
  }

  Widget _debugCardList() {
    final player = ref.watch(playerProvider);
    final map = ref.watch(areaMapProvider);
    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Visibility(
            visible: _showPlayer,
            child: _debugCard(player.toJson()),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Visibility(visible: _showMap, child: _debugCard(map.toJson())),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.packets.isEmpty) {
      return const Center(child: Text('Waiting socket client to connect...'));
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Switch(
                  activeColor: Colors.blue[300],
                  inactiveThumbColor: Colors.black38,
                  value: widget.showDebug,
                  onChanged: (b) {
                    widget.onToggleDebug(b);
                  },
                ),
                const Text("Debug"),
                const Expanded(child: SizedBox()),
                TextButton(
                  onPressed: () {
                    _showPlayer = !_showPlayer;
                    _showMap = false;
                  },
                  child: const Text(
                    "Player",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showMap = !_showMap;
                    _showPlayer = false;
                  },
                  child: const Text(
                    "Map",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _debugCardList(),
          Expanded(
            child: LogList(
              packets: widget.packets.reversed.toList()..take(100),
              scrollController: _scrollController,
            ),
          ),
        ],
      );
    }
  }
}
