import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/preset/base_preset.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../ui/theme.dart';

final afkIdhqProvider = Provider<AfkIdhq>((ref) {
  return AfkIdhq(ref: ref);
});

class AfkIdhq extends BasePreset {
  AfkIdhq({required super.ref});

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
