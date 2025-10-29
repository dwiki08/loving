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
    await questCmd.getQuest([407, 408, 409]);
    await questCmd.acceptQuest(407);
    await questCmd.acceptQuest(408);
    await questCmd.acceptQuest(409);
    stop();
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
