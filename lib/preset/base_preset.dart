import 'package:flutter/material.dart';

import '../loving/command/general_cmd.dart';

abstract class BasePreset {
  final GeneralCmd? generalCmd;

  String get name;

  bool get isRunning => _isRunning;

  bool _isRunning = false;

  BasePreset({this.generalCmd});

  Future<void> start() async {
    _isRunning = true;
    generalCmd?.addLog('Starting \'$name\' preset...');
  }

  Future<void> stop() async {
    _isRunning = false;
    generalCmd?.addLog('\'$name\' is stopped.');
  }

  Widget options(BuildContext context);
}
