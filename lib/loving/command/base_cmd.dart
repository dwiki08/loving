import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/socket/socket_client.dart';

abstract class BaseCmd {
  final Ref _ref;
  final SocketClient _client;

  final Duration defaultDelay = const Duration(milliseconds: 500);

  BaseCmd(this._ref, this._client);

  @protected
  Ref get ref => _ref;

  @protected
  SocketClient get client => _client;

  Future<void> delay() async => Future.delayed(defaultDelay);
}
