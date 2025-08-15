import 'package:flutter/material.dart';

abstract class BasePreset {
  String get name;

  bool get isRunning => _isRunning;

  bool _isRunning = false;

  Future<void> start() async {
    _isRunning = true;
  }

  Future<void> stop() async {
    _isRunning = false;
  }

  Widget options(BuildContext context);
}
