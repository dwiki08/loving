import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/loving/data/player_notifier.dart';
import 'package:loving/model/packet.dart';

import '../../../../loving/data/map_area_notifier.dart';
import '../../../../model/game/area_map.dart';
import '../../../../model/game/player.dart';
import '../../../component/log_list.dart';

class DebugBody extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final showPlayer = useState(false);
    final showMap = useState(false);

    Widget debugCard(Object jsonObj) {
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

    Widget debugCardList() {
      final player = ref.watch(playerProvider);
      final map = ref.watch(areaMapProvider);
      return Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Visibility(
              visible: showPlayer.value,
              child: debugCard(player.toJson()),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Visibility(
              visible: showMap.value,
              child: debugCard(map.toJson()),
            ),
          ),
        ],
      );
    }

    if (packets.isEmpty) {
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
                  value: showDebug,
                  onChanged: (b) {
                    onToggleDebug(b);
                  },
                ),
                const Text("Debug"),
                const Expanded(child: SizedBox()),
                TextButton(
                  onPressed: () {
                    showPlayer.value = !showPlayer.value;
                    showMap.value = false;
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
                    showMap.value = !showMap.value;
                    showPlayer.value = false;
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
          debugCardList(),
          Expanded(
            child: LogList(
              packets: packets.reversed.toList()..take(100),
              scrollController: scrollController,
            ),
          ),
        ],
      );
    }
  }
}
