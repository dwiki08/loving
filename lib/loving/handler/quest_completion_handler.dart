import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/loving/command/quest_cmd.dart';

import '../../model/game/player.dart';
import '../data/player_notifier.dart';

// Handling by periodic timer
/*final periodicTimerProvider = StreamProvider.autoDispose((ref) {
  log("periodicTimerProvider tick...");
  return Stream.periodic(const Duration(seconds: 2));
});

final questCompletionHandlerProvider = Provider.family<void, List<int>>((
  ref,
  questList,
) {
  log("questHandler start... $questList");
  ref.listen(periodicTimerProvider, (previousTick, nextTick) {
    final player = ref.read(playerProvider);
    final items = player.inventoryItems + player.tempInventoryItems;

    // request accept quest if not in tracker
    for (final questId in questList) {
      if (!player.questTracker.contains(questId)) {
        ref.read(questCmdProvider).acceptQuest(questId);
      }
    }

    // try to complete quest in tracker when req fulfilled
    for (final questId in player.questTracker) {
      final questData = player.loadedQuestData.firstWhereOrNull(
        (q) => q.questId == questId,
      );
      if (questData != null) {
        if (questData.isReqFulfilled(items)) {
          ref.read(questCmdProvider).tryCompleteQuest(questId: questId);
        }
      }
    }
  });
});*/

// Handling by Player state update
final questCompletionHandlerProvider = Provider.family<void, List<int>>((
  ref,
  questList,
) {
  playerStateSelector(Player player) => (
    player.inventoryItems,
    player.tempInventoryItems,
    player.questTracker,
    player.loadedQuestData,
    player.status,
  );

  ref.listen(playerProvider.select(playerStateSelector), (
    previousState,
    nextState,
  ) {
    final newInventory = nextState.$1;
    final newTempInventory = nextState.$2;
    final newQuestTracker = nextState.$3;
    final newLoadedQuestData = nextState.$4;
    final items = newInventory + newTempInventory;

    // request accept quest if not in tracker
    for (final questId in questList) {
      // ref.read(questCmdProvider).acceptQuest(questId);
      if (!newQuestTracker.contains(questId)) {
        ref.read(questCmdProvider).acceptQuest(questId);
      }
    }

    // try to complete quest in tracker when req fulfilled
    for (final questId in newQuestTracker) {
      final questData = newLoadedQuestData.firstWhereOrNull(
        (q) => q.questId == questId,
      );
      if (questData != null) {
        if (questData.isReqFulfilled(items)) {
          ref.read(questCmdProvider).tryCompleteQuest(questId: questId);
        }
      }
    }
  });
});
