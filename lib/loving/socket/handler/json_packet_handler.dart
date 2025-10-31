import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/loving/data/map_area_notifier.dart';
import 'package:loving/model/game/area_player.dart';

import '../../../model/game/aura.dart';
import '../../../model/game/item.dart';
import '../../../model/game/monster.dart';
import '../../../model/game/player.dart';
import '../../../model/game/quest_data.dart';
import '../../../model/game/skill.dart';
import '../../../model/packet.dart';
import '../../api/aqw_api.dart';
import '../../data/player_notifier.dart';
import '../socket_client.dart';

class JsonPacketHandler {
  final Ref _ref;

  JsonPacketHandler({required Ref ref}) : _ref = ref;

  PlayerNotifier get _playerNotifier => _ref.read(playerProvider.notifier);

  AreaMapNotifier get _areaMapNotifier => _ref.read(areaMapProvider.notifier);

  bool isInventoryLoaded = false;

  void handle(SocketClient socket, String msg) {
    final areaMap = _ref.read(areaMapProvider);
    final player = _ref.read(playerProvider);

    final jsonMsg = json.decode(msg) as Map<String, dynamic>;
    final data = jsonMsg["b"]?["o"];
    if (data == null) return;
    final cmd = data["cmd"];
    // log('JsonPacketHandler cmd: $cmd');

    try {
      switch (cmd) {
        // on moved to new area map
        case 'moveToArea':
          final uoBranch = data["uoBranch"];
          if (uoBranch is List<dynamic>) {
            for (final item in uoBranch) {
              if (item["uoName"] == player.username.toLowerCase()) {
                _playerNotifier.update(
                  (player) => player.copyWith(
                    cell: item["strFrame"] as String? ?? player.cell,
                    pad: item["strPad"] as String? ?? player.pad,
                    status: PlayerStatus.alive,
                  ),
                );
              }
            }
          }

          _areaMapNotifier.update(
            (areaMap) => areaMap.copyWith(
              name: data["strMapName"],
              roomNumber: int.parse((data["areaName"] as String).split('-')[1]),
              areaId: data["areaId"].toString(),
              monsters: _processMonsterData(data),
              areaPlayers: _processPlayerData(data),
            ),
          );
          break;

        // on player spawned in the area
        case 'uotls':
          final unm = data['unm'] as String?;
          if (unm == player.username.toLowerCase()) {
            _playerNotifier.update(
              (player) => player.copyWith(
                maxHP: (data['o']['intHPMax'] as int?) ?? player.maxHP,
                currentHP: (data['o']['intHP'] as int?) ?? player.currentHP,
                currentMP: (data['o']['intMP'] as int?) ?? player.currentMP,
              ),
            );
          } else {
            // add new area player data
            if (data['o']['strUsername'] != null) {
              _areaMapNotifier.addOrUpdatePlayer(
                AreaPlayer.fromJson(data['o'] as Map<String, dynamic>),
              );
            }

            // update area player data
            final areaPlayer = areaMap.areaPlayers
                .where((element) => element.username == unm)
                .firstOrNull;
            if (areaPlayer != null) {
              _areaMapNotifier.addOrUpdatePlayer(
                areaPlayer.copyWith(
                  maxHP: (data['o']['intHPMax'] as int?) ?? player.maxHP,
                  currentHP: (data['o']['intHP'] as int?) ?? player.currentHP,
                ),
              );
            }
          }
          break;

        // on monster spawned in the area
        case 'mtls':
          final monster = areaMap.getMonster(data['id'] as int);
          final currentHp = data['o']['intHP'] as int;
          final status = data['o']['intState'] as int;
          _areaMapNotifier.updateMonster(
            monster.copyWith(isAlive: status > 0, currentHp: currentHp),
          );
          break;

        case 'stu':
          _playerNotifier.update((player) {
            final sta = data['sta'];
            final cdr = sta?['\$tha'] as num? ?? player.skillCdr;
            final manaCost = sta?['\$cmc'] as num? ?? player.skillManaCost;
            return player.copyWith(
              skillCdr: cdr < 0.5 ? 0.5 : cdr, // set max CDR to 50%
              skillManaCost: manaCost,
            );
          });
          break;

        case 'sAct':
          final skillsJson = data["actions"]["active"] as List<dynamic>;
          final skills = skillsJson
              .mapIndexed((index, item) => Skill.fromJson(index, item))
              .toList();
          _playerNotifier.update((player) {
            return player.copyWith(skills: skills);
          });
          break;

        case 'ct':
          final anims = data["anims"]; // skill anims
          final a = data["a"]; // auras
          final m = data["m"] as Map<String, dynamic>?; // monsters
          final p = data["p"] as Map<String, dynamic>?; // players
          final sarsa = data["sarsa"]; // output damage and heal
          final sara = data["sara"]; // input damage and heal

          // skill animations
          if (anims != null) {
            anims.forEach((anim) {
              final cInf = anim['cInf'] as String;
              final strl = anim['strl'] as String?;
              if (cInf.startsWith("p:") && strl != null) {
                final userId = cInf.substring(2);
                if (int.parse(userId) == player.userId) {
                  _playerNotifier.updateSkill((skill) {
                    final cd = (skill.cooldown.inMilliseconds * player.skillCdr)
                        .toInt();
                    final nextUsage = DateTime.now().add(
                      Duration(milliseconds: cd),
                    );
                    return skill.strl == strl
                        ? skill.copyWith(nextUsage: nextUsage)
                        : skill;
                  });
                }
              }
            });
          }

          // update auras
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
                    final auras = jsonAuras
                        .map((item) => Aura.fromJson(item))
                        .toList();
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
                  final auras = jsonAuras
                      .map((item) => Aura.fromJson(item))
                      .toList();
                  _areaMapNotifier.addOrUpdateMonsterAura(monMapId, auras);
                }
                if (actionCmd.contains('aura-')) {
                  final auraName = action['aura']['nam'] as String;
                  _areaMapNotifier.removeMonsterAura(monMapId, auraName);
                }
              }
            });
          }

          // update monsters data
          if (m != null) {
            m.forEach((monMapId, monCondition) {
              final monster = areaMap.getMonster(int.parse(monMapId));
              final condition = monCondition as Map<String, dynamic>;
              final currentHp = condition["intHP"] ?? monster.currentHp;
              _areaMapNotifier.updateMonster(
                monster.copyWith(currentHp: currentHp, isAlive: currentHp > 0),
              );
              if (currentHp == 0) {
                _areaMapNotifier.clearMonsterAura(monster.monMapId);
              }
            });
          }

          // update players data
          if (p != null) {
            p.forEach((username, playerData) {
              final areaPlayer = _areaMapNotifier.getPlayer(username);
              final data = playerData as Map<String, dynamic>;
              _areaMapNotifier.addOrUpdatePlayer(
                areaPlayer.copyWith(
                  currentHP: (data["intHP"] ?? areaPlayer.currentHP) as int,
                  status: stateToPlayerStatus(
                    (data["intState"] ?? areaPlayer.status.index) as int,
                  ),
                ),
              );
              if (username.toLowerCase() == player.username.toLowerCase()) {
                _playerNotifier.update(
                  (player) => player.copyWith(
                    currentHP: playerData["intHP"] ?? player.currentHP,
                    currentMP: playerData["intMP"] ?? player.currentMP,
                    status: stateToPlayerStatus(
                      playerData["intState"] ?? player.status.index,
                    ),
                  ),
                );
              }
            });
          }
          break;

        case 'clearAuras':
          _playerNotifier.clearAuras();
          break;

        case 'getQuests':
          final quests = data['quests'] as Map<String, dynamic>;
          List<QuestData> questList = quests.values.map((questJson) {
            return QuestData.fromJson(questJson as Map<String, dynamic>);
          }).toList();
          _playerNotifier.update((player) {
            return player.copyWith(loadedQuestData: questList);
          });
          // log("quests: ${prettyJson(questList)}");
          break;

        // {"t":"xt","b":{"r":-1,"o":{"cmd":"acceptQuest","bSuccess":1,"QuestID":409,"msg":"success"}}}
        case 'acceptQuest':
          _playerNotifier.update((player) {
            final acceptedQuest = data['QuestID'] as int;
            if (player.questTracker.contains(acceptedQuest)) {
              return player;
            }
            return player.copyWith(
              questTracker: [...player.questTracker, acceptedQuest],
            );
          });
          break;

        // {"t":"xt","b":{"r":-1,"o":{"cmd":"turnIn","sItems":"38236:5,38238:5,38239:3,42574:3,42575:2"}}}
        case 'turnIn':
          final itemData = data['sItems'] as String;
          itemData.split(',').forEach((item) {
            final itemId = item.split(':')[0];
            final itemQty = int.parse(item.split(':')[1]);
            _playerNotifier.decreaseItemQty(int.parse(itemId), itemQty);
          });
          break;

        // {"t":"xt","b":{"r":-1,"o":{"cmd":"ccqr","rewardObj":{"iCP":0,"intGold":500,"intExp":500,"typ":"q","intCoins":0},"bSuccess":1,"QuestID":181,"sName":"Summoning Complete"}}}
        case 'ccqr':
          final questId = data['QuestID'] as int;
          final questName = data['sName'] as String;
          final isQuestCompleted = data['bSuccess'] == 1;
          final msg = data['msg'] as String?;
          if (isQuestCompleted) {
            _playerNotifier.update((player) {
              final newTracker = List<int>.from(player.questTracker);
              newTracker.remove(questId);
              return player.copyWith(questTracker: newTracker);
            });
            socket.addLog(
              message: "Completion success: $questId | $questName",
              packetSender: PacketSender.server,
            );
          } else {
            socket.addLog(
              message: "Completion failed: $questId | $msg",
              packetSender: PacketSender.server,
            );
          }
          break;

        // any items dropped
        case 'dropItem':
          final items = data['items'] as Map<String, dynamic>;
          items.forEach((key, value) {
            final item = Item.fromJson(value as Map<String, dynamic>);
            _playerNotifier.addDroppedItem(item);
          });
          break;

        // accepting dropped items
        case 'getDrop':
          if (data['bSuccess'] == 1) {
            final itemId = data['ItemID'] as int;
            final item = player.getDroppedItem(itemId);
            if (item != null) {
              if (data['bBank'] == 1) {
                _playerNotifier.addBankItem(item);
                _playerNotifier.removeDroppedItem(item);
              } else {
                _playerNotifier.addInventoryItem(item);
                _playerNotifier.removeDroppedItem(item);
              }
            }
          }
          break;

        // adding items to inventory, temporary inventory or bank
        case 'addItems':
          final items = data['items'] as Map<String, dynamic>;
          items.forEach((key, value) {
            final isInBank = value['bBank'] == 1;
            if (isInBank) {
              final item = player.getBankItem(int.parse(key));
              if (item != null) {
                log(
                  "update bank item: ${item.name} | qtyNow:${value["iQtyNow"]}",
                );
                _playerNotifier.addBankItem(
                  item.copyWith(qty: value["iQtyNow"]),
                );
              }
            } else {
              final item = player.getInventoryItem(int.parse(key));
              final tempItem = player.getTempInventoryItem(int.parse(key));
              if (item != null) {
                _playerNotifier.addInventoryItem(
                  item.copyWith(
                    qty: value["iQtyNow"],
                  ), // TODO update qtyNow, not add
                );
              } else if (tempItem != null) {
                _playerNotifier.addTempInventoryItem(
                  tempItem.copyWith(qty: value["iQty"]),
                );
              } else {
                var newItem = Item.fromJson(value as Map<String, dynamic>);
                if (newItem.qty < 1) {
                  newItem = newItem.copyWith(qty: 1);
                }
                if (newItem.isTemp) {
                  _playerNotifier.addTempInventoryItem(newItem);
                } else {
                  _playerNotifier.addInventoryItem(newItem);
                }
              }
            }
          });
          break;

        case 'initUserData':
          break;

        case 'initUserDatas':
          var myCharId = '';
          for (final i in data['a'] as List) {
            final itemData = i['data'] as Map<String, dynamic>;
            final username = itemData['strUsername'] as String;
            final accessLevel = itemData['intAccessLevel'] as String;
            final charId = itemData['CharID'] as String;
            final totalGold = itemData['intGold'];
            if (player.username.toLowerCase() == username.toLowerCase()) {
              _playerNotifier.update(
                (player) =>
                    player.copyWith(charId: charId, totalGold: totalGold),
              );
              myCharId = charId;
            }
          }
          if (isInventoryLoaded == false) {
            socket.addLog(
              message: 'Retrieving inventory and bank...',
              packetSender: PacketSender.client,
            );
            // retrieve inventory items
            socket.sendPacket(
              '%xt%zm%retrieveInventory%${areaMap.areaId}%${socket.user.id}%',
            );
            // retrieve bank items
            _loadBankItems(myCharId, socket.loginInfo.sToken);
            isInventoryLoaded = true;
          }
          break;

        case 'loadInventoryBig':
          final List<Item> inventoryItems = (data['items'] as List)
              .map((item) => Item.fromJson(item as Map<String, dynamic>))
              .toList();
          _playerNotifier.update(
            (player) => player.copyWith(
              equipments: inventoryItems
                  .where((i) => i.isEquipped == true)
                  .toList(),
              inventoryItems: inventoryItems,
            ),
          );
          socket.addLog(
            message: 'Character load completed.',
            packetSender: PacketSender.server,
          );
          socket.isCharacterLoadComplete = true;
          break;

        case 'playerDeath':
          socket.addLog(message: 'DEATH', packetSender: PacketSender.server);
          _playerNotifier.update(
            (player) => player.copyWith(status: PlayerStatus.dead),
          );
          break;
      }
    } catch (e, s) {
      log('JsonPacketHandler err: $e');
      log('JsonPacketHandler trace: $s');
      log('JsonPacketHandler data: $data');
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
          log('loadBankItems success with ${items.length} items');
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
    List<Monster> monsters = monBranch
        .map((item) => Monster.fromJson(item as Map<String, dynamic>))
        .toList();

    // 4. "Perbarui" monster dengan nama dan frame menggunakan copyWith
    // Proses ini membuat list baru berdasarkan list sebelumnya
    List<Monster> finalMonsters = monsters.map((monster) {
      // Cari nama dan frame di "kamus"
      final newName = nameMap[monster.monId];
      final newFrame = frameMap[monster.monMapId.toString()];

      // Buat instance baru dengan data yang diperbarui
      return monster.copyWith(monName: newName, cell: newFrame);
    }).toList();

    return finalMonsters;
  }
}
