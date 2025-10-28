import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/game/player.dart';
import '../command/player_cmd.dart';
import '../data/player_notifier.dart';

final itemDropHandlerProvider = Provider.family<void, List<String>>((
  ref,
  whitelist,
) {
  ref.listen<Player>(playerProvider, (previous, next) {
    final prevItems = previous?.droppedItems ?? [];
    final newItems = next.droppedItems.where(
      (item) => !prevItems.any((prev) => prev.id == item.id),
    );

    for (var item in newItems) {
      if (whitelist.contains(item.name)) {
        log("Dropped: ${item.name}");
        ref.read(playerCmdProvider).acceptDroppedItem(item.name);
      }
    }
  });
});
