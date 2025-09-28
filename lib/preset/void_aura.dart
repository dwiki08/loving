import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/command/general_cmd.dart';
import 'package:loving/preset/base_preset.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../loving/command/map_cmd.dart';

final voidAuraProvider = Provider<VoidAura>((ref) {
  final generalCmd = ref.read(generalCmdProvider);
  final mapCmd = ref.read(mapCmdProvider);
  return VoidAura(generalCmd: generalCmd, mapCmd: mapCmd);
});

class VoidAura extends BasePreset {
  final MapCmd mapCmd;

  VoidAura({required super.generalCmd, required this.mapCmd});

  final _xPosTextController = TextEditingController(text: '450');
  final _yPosTextController = TextEditingController(text: '500');

  @override
  String get name => "Void Aura";

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
    return Column(
      children: [
        Card(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Text("Void Aura - Non Member Farming"),
            ),
          ),
        ),
      ],
    );
  }
}
