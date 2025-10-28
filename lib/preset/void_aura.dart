import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/preset/base_preset.dart';

final voidAuraProvider = Provider<VoidAura>((ref) {
  return VoidAura(ref: ref);
});

class VoidAura extends BasePreset {
  VoidAura({required super.ref});

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
