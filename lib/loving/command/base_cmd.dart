import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/loving/socket/socket_client.dart';
import 'package:loving/model/packet.dart';

import '../../model/game/area_map.dart';
import '../../model/game/player.dart';
import '../../services/bot_manager.dart';
import '../data/map_area_notifier.dart';
import '../data/player_notifier.dart';

abstract class BaseCmd {
  final Ref _ref;
  final SocketClient _client;

  BaseCmd(this._ref, this._client);

  static const defaultDelayInt = 700;
  static const defaultDelay = Duration(milliseconds: defaultDelayInt);

  @protected
  Ref get ref => _ref;

  @protected
  SocketClient get client => _client;

  @protected
  AreaMap get areaMap => ref.read(areaMapProvider);

  @protected
  Player get player => ref.read(playerProvider);

  Future<void> delay({int milliseconds = defaultDelayInt}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  Future<bool> waitFor({
    required Future<bool> Function() condition,
    Duration timeout = const Duration(seconds: 5),
    Duration pollInterval = const Duration(milliseconds: 100),
    String? msgWaitFor,
  }) async {
    if (msgWaitFor != null && !await condition()) {
      client.addLog(
        message: 'Waiting for $msgWaitFor',
        packetSender: PacketSender.client,
      );
    }

    final completer = Completer<bool>();
    final timer = Timer(timeout, () {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    Future<void> poll() async {
      if (completer.isCompleted) return;

      try {
        if (await condition()) {
          completer.complete(true);
        } else {
          Timer(pollInterval, poll);
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
    }

    poll();
    final result = await completer.future;
    timer.cancel();
    return result;
  }

  bool isBotRunning() {
    return ref.read(botManagerProvider).isRunning;
  }

  Future<bool> isPlayerReady() async {
    if (!isBotRunning()) {
      return false;
    }
    await waitFor(
      condition: () async =>
          ref.read(playerProvider).status != PlayerStatus.dead,
      timeout: Duration(seconds: 12),
      pollInterval: Duration(seconds: 1),
      msgWaitFor: 'player respawn',
    );
    return true;
  }

  @protected
  Future<void> leaveCombat() async {
    client.sendPacket(
      "%xt%zm%moveToCell%${areaMap.areaId}%${player.cell}%${player.pad}%",
    );
    await waitFor(
      condition: () async => player.status != PlayerStatus.inCombat,
    );
    await delay(milliseconds: 500);
  }
}
