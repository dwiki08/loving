import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/model/game/area_map.dart';

import '../../model/game/player.dart';
import '../data/map_area_notifier.dart';
import '../data/player_notifier.dart';
import '../socket/socket_client.dart';
import 'base_cmd.dart';

final questCmdProvider = Provider<QuestCmd>((ref) {
  final client = ref.read(socketProvider);
  return QuestCmd(ref, client);
});

class QuestCmd extends BaseCmd {
  QuestCmd(super.ref, super.client);

  Player get _player => ref.read(playerProvider);

  AreaMap get _areaMap => ref.read(areaMapProvider);

  // %xt%zm%getQuests%103078%407%408%409%445%446%
  Future<void> getQuest(List<int> questIds) async {
    // log('getQuests: $questIds');
    client.sendPacket(
      '%xt%zm%getQuests%${_areaMap.areaId}%${questIds.join('%')}%',
    );
    await delay();
  }

  // %xt%zm%acceptQuest%103078%408%
  Future<void> acceptQuest(int questId) async {
    // load quest data first
    if (!_player.loadedQuestData.any((e) => e.questId == questId)) {
      await getQuest([questId]);
      await delay(); // to make sure
    }

    // log('acceptQuest: $questId');
    client.sendPacket('%xt%zm%acceptQuest%${_areaMap.areaId}%$questId%');
    await delay();
  }

  // %xt%zm%tryQuestComplete%110210%236%-1%false%1%wvz%
  Future<void> tryCompleteQuest({
    required int questId,
    int itemId = -1,
    int qty = 1,
  }) async {
    client.sendPacket(
      '%xt%zm%tryQuestComplete%${_areaMap.areaId}%$questId%$itemId%false%$qty%wvz%',
    );
    await delay();
  }
}
