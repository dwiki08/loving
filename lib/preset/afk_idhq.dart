import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/command/general_cmd.dart';
import 'package:loving/preset/base_preset.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../loving/command/map_cmd.dart';
import '../ui/theme.dart';

final afkIdhqProvider = Provider<AfkIdhq>((ref) {
  final generalCmd = ref.read(generalCmdProvider);
  final mapCmd = ref.read(mapCmdProvider);
  return AfkIdhq(generalCmd: generalCmd, mapCmd: mapCmd);
});

class AfkIdhq extends BasePreset {
  final MapCmd mapCmd;

  AfkIdhq({required super.generalCmd, required this.mapCmd});

  final _xPosTextController = TextEditingController(text: '450');
  final _yPosTextController = TextEditingController(text: '500');

  @override
  String get name => "AFK IDHQ";

  @override
  Future<void> start() async {
    super.start();
    await mapCmd.joinHouse(house: 'idhq');
    await mapCmd.jumpToCell(cell: 'r1a');
    await mapCmd.walkTo(
      x: int.parse(_xPosTextController.text),
      y: int.parse(_yPosTextController.text),
    );
  }

  @override
  Widget options(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            enabled: !isRunning,
            controller: _xPosTextController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: textFieldDecoration(
              context: context,
              label: 'X position',
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            enabled: !isRunning,
            controller: _yPosTextController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            decoration: textFieldDecoration(
              context: context,
              label: 'Y position',
            ),
          ),
        ),
      ],
    );
  }
}
