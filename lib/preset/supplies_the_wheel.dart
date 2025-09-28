import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/command/general_cmd.dart';
import 'package:loving/preset/base_preset.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../loving/command/map_cmd.dart';

final suppliesTheWheelProvider = Provider<SuppliesTheWheel>((ref) {
  final generalCmd = ref.read(generalCmdProvider);
  final mapCmd = ref.read(mapCmdProvider);
  return SuppliesTheWheel(generalCmd: generalCmd, mapCmd: mapCmd);
});

class SuppliesTheWheel extends BasePreset {
  final MapCmd mapCmd;

  SuppliesTheWheel({required super.generalCmd, required this.mapCmd});

  @override
  String get name => "Supplies The Wheel";

  @override
  Future<void> start() async {
    super.start();
    await mapCmd.joinMap(mapName: "escherion", roomNumber: 9099);
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
              child: Text("Supplies the Wheel Quest Farm"),
            ),
          ),
        ),
      ],
    );
  }
}
