import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../loving/socket/socket_client.dart';
import '../model/game/chat.dart';
import '../model/packet.dart';
import '../model/socket_state.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final socketConnectionStateProvider = StreamProvider<SocketState>((ref) {
  final service = ref.watch(socketProvider);
  return service.connectionStateStream;
});

final socketPacketProvider = StreamProvider<Packet>((ref) {
  final service = ref.watch(socketProvider);
  return service.packetStream;
});

final socketChatProvider = StreamProvider<Chat>((ref) {
  final service = ref.watch(socketProvider);
  return service.chatStream;
});
