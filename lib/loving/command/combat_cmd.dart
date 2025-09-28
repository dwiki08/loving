import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/data/map_area_notifier.dart';
import 'package:loving/loving/socket/socket_client.dart';
import 'package:loving/model/game/area_map.dart';

final combatCmdProvider = Provider<CombatCmd>((ref) {
  final client = ref.read(socketProvider);
  return CombatCmd(ref, client);
});

class CombatCmd {
  final Ref _ref;
  final SocketClient _client;

  CombatCmd(this._ref, this._client);

  AreaMap get _areaMap => _ref.read(areaMapProvider);
}
