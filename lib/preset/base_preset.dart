import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/loving/command/combat_cmd.dart';
import 'package:loving/loving/command/player_cmd.dart';
import 'package:loving/loving/command/quest_cmd.dart';

import '../loving/command/general_cmd.dart';
import '../loving/command/map_cmd.dart';
import '../loving/data/player_notifier.dart';
import '../loving/socket/socket_client.dart';
import '../model/socket_state.dart';
import '../services/notification_service.dart';

abstract class BasePreset {
  final Ref ref;

  String get name;

  bool get isRunning => _isRunning;

  bool _isRunning = false;

  static const int _notificationId = 1001;

  final NotificationService _notificationService = NotificationService();

  StreamSubscription<SocketState>? _socketStateSubscription;

  BasePreset({required this.ref});

  SocketClient get socket => ref.read(socketProvider);

  GeneralCmd get generalCmd => ref.read(generalCmdProvider);

  PlayerCmd get playerCmd => ref.read(playerCmdProvider);

  MapCmd get mapCmd => ref.read(mapCmdProvider);

  CombatCmd get combatCmd => ref.read(combatCmdProvider);

  QuestCmd get questCmd => ref.read(questCmdProvider);

  Future<void> start() async {
    _isRunning = true;
    generalCmd.addLog('Starting \'$name\' preset...');

    // Create local notification if bot is running in background
    await _notificationService.initialize();
    await _notificationService.requestPermissions();

    await _notificationService.showNotification(
      id: _notificationId,
      title: name,
      body: 'Bot is currently running...',
      payload: '',
    );
  }

  Future<void> stop() async {
    _isRunning = false;

    // Cancel socket state subscription to prevent memory leaks
    await _socketStateSubscription?.cancel();
    _socketStateSubscription = null;

    await generalCmd.leaveCombat();
    generalCmd.addLog('\'$name\' is stopped.');

    // Cancel the running notification
    await _notificationService.cancelNotification(_notificationId);
  }

  Future<void> updateNotificationStatus(
    String body, [
    String payload = '',
  ]) async {
    if (_isRunning) {
      await _notificationService.updateNotification(
        id: _notificationId,
        title: name,
        body: body,
        payload: payload,
      );
    }
  }

  Future<void> showNotificationError(String error) async {
    await _notificationService.showErrorNotification(
      id: _notificationId + 1,
      title: 'Bot Error',
      body: '$name preset error: $error',
      payload: name,
    );
  }

  Future<void> killForItem(
    String itemName,
    int qty, [
    List<String> targetPriority = const ['*'],
    List<int> skills = const [0, 1, 2, 0, 3, 4],
  ]) async {
    if (ref.read(playerProvider).hasItemByName(itemName, qty)) {
      return;
    }

    int i = 0;
    while (isRunning) {
      if (ref.read(playerProvider).hasItemByName(itemName, qty)) {
        return;
      }
      await combatCmd.useSkill(
        index: skills[i],
        targetPriority: targetPriority,
      );
      i = (i + 1) % skills.length;
    }
  }

  Widget options(BuildContext context);
}
