import 'package:flutter/material.dart';
import 'package:loving/model/game/player.dart';

@immutable
class AreaPlayer {
  final String username;
  final int id;
  final String cell;
  final String pad;
  final PlayerStatus status;
  final int maxHP;
  final int currentHP;

  const AreaPlayer({
    this.username = '',
    this.id = 0,
    this.cell = '',
    this.pad = '',
    this.status = PlayerStatus.alive,
    this.maxHP = 0,
    this.currentHP = 1,
  });

  double getHPinPercentage() {
    if (maxHP == 0) return 0.0;
    return (currentHP / maxHP) * 100;
  }

  AreaPlayer copyWith({
    String? username,
    int? id,
    String? cell,
    String? pad,
    PlayerStatus? status,
    int? maxHP,
    int? currentHP,
  }) {
    return AreaPlayer(
      username: username ?? this.username,
      id: id ?? this.id,
      cell: cell ?? this.cell,
      pad: pad ?? this.pad,
      status: status ?? this.status,
      maxHP: maxHP ?? this.maxHP,
      currentHP: currentHP ?? this.currentHP,
    );
  }

  factory AreaPlayer.fromJson(Map<String, dynamic> json) {
    return AreaPlayer(
      username: json['strUsername'],
      id: json['entID'],
      cell: json['strFrame'],
      pad: json['strPad'],
      status: stateToPlayerStatus(json['intState'] as int? ?? 1),
      maxHP: json['intHPMax'],
      currentHP: json['intHP'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'id': id,
      'cell': cell,
      'pad': pad,
      'status': status.name,
      'maxHP': maxHP,
      'currentHP': currentHP,
    };
  }
}
