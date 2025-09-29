import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/data/map_area_notifier.dart';
import 'package:loving/model/game/area_player.dart';

import '../../../model/game/aura.dart';
import '../../../model/game/item.dart';
import '../../../model/game/monster.dart';
import '../../../model/game/player.dart';
import '../../../model/packet.dart';
import '../../api/aqw_api.dart';
import '../../data/player_notifier.dart';
import '../socket_client.dart';

class JsonPacketHandler {
  final Ref _ref;

  JsonPacketHandler({required Ref ref}) : _ref = ref;

  PlayerNotifier get _playerNotifier => _ref.read(playerProvider.notifier);

  AreaMapNotifier get _areaMapNotifier => _ref.read(areaMapProvider.notifier);

  void handle(SocketClient socket, String msg) {
    final areaMap = _ref.read(areaMapProvider);
    final player = _ref.read(playerProvider);

    try {
      final jsonMsg = json.decode(msg) as Map<String, dynamic>;
      final data = jsonMsg["b"]?["o"];
      if (data == null) return;
      final cmd = data["cmd"];

      switch (cmd) {
        // on moved to new area map
        case 'moveToArea':
          final uoBranch = data["uoBranch"];
          if (uoBranch is List<dynamic>) {
            log("me: ${player.username.toLowerCase()}");
            for (final item in uoBranch) {
              log("item: $item");
              if (item["uoName"] == player.username.toLowerCase()) {
                _playerNotifier.update(
                  (player) => player.copyWith(
                    cell: item["strFrame"] as String? ?? player.cell,
                    pad: item["strPad"] as String? ?? player.pad,
                    posY: item["ty"] as int? ?? player.posY,
                    posX: item["tx"] as int? ?? player.posX,
                    maxHP: item["intHPMax"] as int? ?? player.maxHP,
                    currentHP: item["intHP"] as int? ?? player.currentHP,
                    status: PlayerStatus.alive,
                  ),
                );
              }
            }
          }

          _areaMapNotifier.update(
            (areaMap) => areaMap.copyWith(
              name: data["areaName"],
              areaId: data["areaId"].toString(),
              monsters: _processMonsterData(data),
              areaPlayers: _processPlayerData(data),
            ),
          );
          break;

        // on player spawned in the area
        case 'uotls':
          final unm = data['unm'];
          if (unm == player.username.toLowerCase()) {
            _playerNotifier.update(
              (player) => player.copyWith(
                maxHP: data['o']['intHPMax'] as int,
                currentMP: data['o']['intMP'] as int,
                status: stateToPlayerStatus(data['o']['intSate'] as int),
              ),
            );
          }
          _areaMapNotifier.updatePlayer(
            AreaPlayer.fromJson(data['o'] as Map<String, dynamic>),
          );
          break;

        // on monster spawned in the area
        case 'mtls':
          final monster = _areaMapNotifier.getMonster(data['id'] as int);
          final currentHp = data['o']['intHP'] as int;
          final status = data['o']['intState'] as int;
          _areaMapNotifier.updateMonster(
            monster.copyWith(isAlive: status > 0, currentHp: currentHp),
          );
          break;

        case 'ct':
          final anims = data["anims"]; // skill anims
          final a = data["a"]; // auras
          final m = data["m"] as Map<String, dynamic>?; // monsters
          final p = data["p"] as Map<String, dynamic>?; // players
          final sarsa = data["sarsa"]; // output damage and heal
          final sara = data["sara"]; // input damage and heal

          if (a != null) {
            a.forEach((action) {
              final tInf = action['tInf'] as String;
              final actionCmd = action['cmd'];

              // aura player
              if (tInf.startsWith("p:")) {
                final userId = tInf.substring(2);
                if (userId == socket.user.id) {
                  if (actionCmd.contains('aura+')) {
                    final jsonAuras = action['auras'] as List<dynamic>;
                    final auras =
                        jsonAuras.map((item) => Aura.fromJson(item)).toList();
                    _playerNotifier.addOrUpdateAura(auras);
                  }
                  if (actionCmd.contains('aura-')) {
                    final auraName = action['aura']['nam'] as String;
                    _playerNotifier.removeAura(auraName);
                  }
                }
              }

              // aura monster
              if (tInf.startsWith("m:")) {
                final monMapId = int.parse(tInf.substring(2));
                if (actionCmd.contains('aura+')) {
                  final jsonAuras = action['auras'] as List<dynamic>;
                  final auras =
                      jsonAuras.map((item) => Aura.fromJson(item)).toList();
                  _areaMapNotifier.addOrUpdateMonsterAura(monMapId, auras);
                }
                if (actionCmd.contains('aura-')) {
                  final auraName = action['aura']['nam'] as String;
                  _areaMapNotifier.removeMonsterAura(monMapId, auraName);
                }
              }
            });
          }

          if (m != null) {
            m.forEach((monMapId, monCondition) {
              final monster = _areaMapNotifier.getMonster(int.parse(monMapId));
              final condition = monCondition as Map<String, dynamic>;
              final currentHp =
                  (condition["intHP"] ?? monster.currentHp) as int;
              _areaMapNotifier.updateMonster(
                monster.copyWith(currentHp: currentHp, isAlive: currentHp > 0),
              );
              if (currentHp == 0) {
                _areaMapNotifier.clearMonsterAura(monster.monMapId);
              }
            });
          }

          if (p != null) {
            p.forEach((username, playerData) {
              final player = _areaMapNotifier.getPlayer(username);
              final data = playerData as Map<String, dynamic>;
              _areaMapNotifier.updatePlayer(
                player.copyWith(
                  currentHP: (data["intHP"] ?? player.currentHP) as int,
                  status: stateToPlayerStatus(
                    (data["intState"] ?? player.status.index) as int,
                  ),
                ),
              );
            });
          }

          break;

        case 'initUserData':
          break;

        case 'initUserDatas':
          for (final i in data['a'] as List) {
            final itemData = i['data'] as Map<String, dynamic>;
            final username = itemData['strUsername'] as String;
            final accessLevel = itemData['intAccessLevel'] as String;
            if (player.username.toLowerCase() == username.toLowerCase()) {
              final charId = itemData['CharID'] as String;
              final totalGold = itemData['intGold'] as double;
              _playerNotifier.update(
                (player) => player.copyWith(
                  charId: charId,
                  totalGold: totalGold,
                ),
              );
              _loadBankItems(charId, socket.loginInfo.sToken);
            }
          }
          if (socket.isInventoryLoaded == false) {
            socket.addLog(
              message: 'Retrieving inventory and bank...',
              packetSender: PacketSender.client,
            );
            socket.sendPacket(
              '%xt%zm%retrieveInventory%${areaMap.areaId}%${socket.user.id}%',
            );
            socket.isInventoryLoaded = true;
          }
          break;

        case 'loadInventoryBig':
          final List<Item> inventoryItems =
              (data['items'] as List)
                  .map((item) => Item.fromJson(item as Map<String, dynamic>))
                  .toList();
          _playerNotifier.update(
            (player) => player.copyWith(
              equipments:
                  inventoryItems.where((i) => i.isEquipped == true).toList(),
              inventoryItems: inventoryItems,
            ),
          );
          socket.addLog(
            message: 'Character load completed.',
            packetSender: PacketSender.server,
          );
          socket.isAllLoaded = true;
          break;
      }
    } catch (e) {
      log('JsonPacketHandler err: $e');
      socket.addDebug(
        message: 'JsonPacketHandler err: $e',
        packetSender: PacketSender.server,
      );
    }
  }

  void _loadBankItems(String charId, String token) {
    final api = _ref.read(aqwApiProvider);
    api.getBankItems(charId, token).then((result) {
      result.fold(
            (e) {
          log('loadBankItems err: ${e.message}');
        },
            (items) {
          _playerNotifier.update((player) => player.copyWith(bankItems: items));
        },
      );
    });
  }

  List<AreaPlayer> _processPlayerData(Map<String, dynamic> data) {
    final List<AreaPlayer> areaPlayers = [];
    final uoBranch = data['uoBranch'] as List?;
    for (final item in uoBranch ?? []) {
      final uo = item as Map<String, dynamic>;
      final areaPlayer = AreaPlayer.fromJson(uo);
      areaPlayers.add(areaPlayer);
    }
    return areaPlayers;
  }

  // generated by Gemini
  List<Monster> _processMonsterData(Map<String, dynamic> data) {
    // 1. Ekstrak list dari data, pastikan tidak null
    final monBranch = data['monBranch'] as List?;
    final monDef = data['mondef'] as List?;
    final monMap = data['monmap'] as List?;

    // Jika salah satu data penting tidak ada, kembalikan list kosong
    if (monBranch == null || monDef == null || monMap == null) {
      return [];
    }

    // 2. Buat "kamus" untuk pencarian cepat nama dan frame.
    // Ini jauh lebih efisien daripada nested loop.
    final nameMap = {
      for (var def in monDef)
        (def['MonID'] as String): (def['strMonName'] as String),
    };

    final frameMap = {
      for (var map in monMap)
        (map['MonMapID'] as String): (map['strFrame'] as String),
    };

    // 3. Buat list Monster awal dari monBranch
    List<Monster> monsters =
        monBranch
            .map((item) => Monster.fromJson(item as Map<String, dynamic>))
            .toList();

    // 4. "Perbarui" monster dengan nama dan frame menggunakan copyWith
    // Proses ini membuat list baru berdasarkan list sebelumnya
    List<Monster> finalMonsters =
        monsters.map((monster) {
          // Cari nama dan frame di "kamus"
          final newName = nameMap[monster.monId];
          final newFrame = frameMap[monster.monMapId.toString()];

          // Buat instance baru dengan data yang diperbarui
          return monster.copyWith(monName: newName, frame: newFrame);
        }).toList();

    return finalMonsters;
  }
}
