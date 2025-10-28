import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/common/extension.dart';
import 'package:loving/loving/socket/handler/flash_packet_handler.dart';
import 'package:loving/loving/socket/handler/xml_packet_handler.dart';
import 'package:loving/model/game/chat.dart';
import 'package:loving/model/packet.dart';

import '../../common/utils.dart';
import '../../model/login_model.dart';
import '../../model/socket_state.dart';
import '../data/map_area_notifier.dart';
import '../data/player_notifier.dart';
import 'handler/json_packet_handler.dart';

final socketProvider = Provider<SocketClient>((ref) {
  final service = SocketClient(
    ref: ref,
    jsonPacketHandler: JsonPacketHandler(ref: ref),
    flashPacketHandler: FlashPacketHandler(ref: ref),
    xmlPacketHandler: XmlPacketHandler(ref: ref),
  );
  ref.onDispose(() => service.close());
  return service;
});

class User {
  final String id;
  final String username;

  User({required this.id, required this.username});
}

class SocketClient {
  final Ref _ref;
  final JsonPacketHandler _jsonPacketHandler;
  final FlashPacketHandler _flashPacketHandler;
  final XmlPacketHandler _xmlPacketHandler;

  SocketClient({
    required Ref ref,
    required JsonPacketHandler jsonPacketHandler,
    required FlashPacketHandler flashPacketHandler,
    required XmlPacketHandler xmlPacketHandler,
  }) : _ref = ref,
       _jsonPacketHandler = jsonPacketHandler,
       _flashPacketHandler = flashPacketHandler,
       _xmlPacketHandler = xmlPacketHandler;

  late final Socket _socket;
  late final LoginModel _loginModel;
  late final User _user;
  late final _streamPackets = StreamController<Packet>.broadcast();
  late final _streamChats = StreamController<Chat>.broadcast();
  late final _connectionStateController =
      StreamController<SocketState>.broadcast();

  PlayerNotifier get _playerNotifier => _ref.read(playerProvider.notifier);

  AreaMapNotifier get _areaMapNotifier => _ref.read(areaMapProvider.notifier);

  LoginModel get loginInfo => _loginModel;

  User get user => _user;

  Stream<Packet> get packetStream => _streamPackets.stream;

  Stream<Chat> get chatStream => _streamChats.stream;

  Stream<SocketState> get connectionStateStream =>
      _connectionStateController.stream;

  bool isCharacterLoadComplete = false;

  void setUserData(User user) {
    _user = user;
  }

  void log(String msg) {
    dev.log('socket: $msg');
  }

  void sendPacket(String packet) {
    _socket.add(utf8.encode("$packet\u0000"));
    addDebug(message: packet, packetSender: PacketSender.client);
    log('Sent: $packet');
  }

  Future<void> close() async {
    _playerNotifier.clear();
    _areaMapNotifier.clear();
    await _socket.flush();
    await _socket.close();
  }

  Future<void> connectToServer({
    required String server,
    required LoginModel loginModel,
  }) async {
    final playerNotifier = _ref.read(playerProvider.notifier);
    try {
      final serverModel = loginModel.servers.firstWhere(
        (s) => s.sName == server,
      );
      final hostname = serverModel.sIP;
      final port = serverModel.iPort;

      // connecting to socket
      _connectionStateController.add(SocketState.connecting);
      _socket = await Socket.connect(hostname, port);
      _loginModel = loginModel;

      // connected to socket
      _connectionStateController.add(SocketState.connected);
      playerNotifier.update((player) {
        return player.copyWith(username: loginModel.username);
      });

      // listening to socket buffer
      final buffer = StringBuffer();
      _socket.listen(
        (data) {
          buffer.write(utf8.decode(data));
          final messages = buffer.toString().split('\u0000');
          for (var message in messages) {
            if (message.trim().isEmpty) continue;
            if (message.isValidJson) {
              _jsonPacketHandler.handle(this, message);
            }
            if (message.isValidXml) {
              _xmlPacketHandler.handle(this, message);
            }
            if (message.startsWith('%')) {
              _flashPacketHandler.handle(this, message);
            }
            addDebug(message: message, packetSender: PacketSender.server);
          }
          buffer
            ..clear()
            ..write(messages.last);
        },
        onError: (error) {
          addDebug(
            message: 'Socket error: $error',
            packetSender: PacketSender.server,
            isLog: true,
          );
          _connectionStateController.add(SocketState.error);
          _connectionStateController.add(SocketState.disconnected);
        },
        onDone: () {
          log("Socket connection closed");
        },
      );
    } catch (e) {
      _connectionStateController.add(SocketState.error);
      _connectionStateController.add(SocketState.disconnected);
      rethrow;
    }
  }

  void addChat(Chat chat) {
    _streamChats.add(chat);
  }

  void addLog({
    required String message,
    required PacketSender packetSender,
    bool isDebug = false,
  }) {
    _streamPackets.add(
      Packet(
        message: message,
        packetSender: packetSender,
        isLog: true,
        isDebug: isDebug,
        timestamp: getTimestamp(),
      ),
    );
  }

  void addDebug({
    required String message,
    required PacketSender packetSender,
    bool isLog = false,
  }) {
    _streamPackets.add(
      Packet(
        message: message,
        packetSender: packetSender,
        isLog: isLog,
        isDebug: true,
        timestamp: getTimestamp(),
      ),
    );
  }
}
