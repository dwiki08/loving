import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/model/game/chat.dart';
import 'package:loving/model/packet.dart';
import 'package:loving/ui/component/logout_button.dart';
import 'package:loving/ui/sreen/dashboard/component/chat_body.dart';
import 'package:loving/ui/sreen/dashboard/component/log_body.dart';

import '../../../di/di_provider.dart';
import '../../../model/login_model.dart';
import '../../../model/socket_state.dart';
import '../../theme.dart';
import '../login/login_screen.dart';
import 'component/debug_body.dart';
import 'dashboard_notifier.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({
    super.key,
    required this.server,
    required this.loginModel,
  });

  final String server;
  final LoginModel loginModel;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final List<Packet> _logs = [];
  final List<Packet> _debugs = [];
  final List<Chat> _chats = [];

  SocketState _socketState = SocketState.disconnected;
  Timer? _timer;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref
          .read(dashboardNotifierProvider.notifier)
          .connect(widget.server, widget.loginModel);
    });

    ref.listenManual<AsyncValue<SocketState>>(socketConnectionStateProvider, (
      prev,
      next,
    ) {
      next.whenData((packet) {
        setState(() {
          _socketState = packet;
          if (packet == SocketState.connected) {
            _startTimer();
          } else {
            _stopTimer();
          }
        });
      });
    });

    ref.listenManual<AsyncValue<Chat>>(socketChatProvider, (prev, next) {
      next.whenData((packet) {
        setState(() {
          _chats.add(packet);
        });
      });
    });

    ref.listenManual<AsyncValue<Packet>>(socketPacketProvider, (prev, next) {
      next.whenData((packet) {
        setState(() {
          if ((packet.isDebug && packet.packetSender == PacketSender.client) ||
              ref.watch(dashboardNotifierProvider).showDebug) {
            _debugs.add(packet);
          }
          if (packet.isLog) {
            _logs.add(packet);
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _duration = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _duration = Duration(seconds: _duration.inSeconds + 1);
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatDuration(Duration duration) {
    return duration.toString().split('.').first.padLeft(8, "0");
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(dashboardNotifierProvider.notifier);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Loving - ${ref.watch(dashboardNotifierProvider).player?.username}',
              ),
              Row(
                children: [
                  _socketStatusIcon(_socketState),
                  const SizedBox(width: 8),
                  Text(
                    _formatDuration(_duration),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black45,
            tabs: const [
              Tab(text: 'Log', icon: Icon(Icons.info_outline)),
              Tab(text: 'Chat', icon: Icon(Icons.chat_outlined)),
              Tab(text: 'Debug', icon: Icon(Icons.bug_report_outlined)),
            ],
          ),
          actions: [
            LogoutButton(
              onConfirm: () async {
                await notifier.disconnect();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            LogBody(
              packets: _logs,
              presets: ref.watch(dashboardNotifierProvider).presets,
              isRunning: ref.watch(dashboardNotifierProvider).isRunning,
              selectedPreset:
                  ref.watch(dashboardNotifierProvider).selectedPreset,
              onSelectPreset: (preset) {
                notifier.selectPreset(preset);
              },
              onToggleStart: () {
                if (ref.read(dashboardNotifierProvider).isRunning) {
                  notifier.stop();
                } else {
                  notifier.start();
                }
              },
            ),
            ChatBody(
              chats: _chats,
              onSendChat: (text) {
                notifier.sendChat(text);
              },
            ),
            DebugBody(
              packets: _debugs,
              player: ref.watch(dashboardNotifierProvider).player,
              map: ref.watch(dashboardNotifierProvider).map,
              showDebug: ref.watch(dashboardNotifierProvider).showDebug,
              onToggleDebug: (b) {
                notifier.toggleDebug(b);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _socketStatusIcon(SocketState state) {
    Color color;
    switch (state) {
      case SocketState.connecting:
        color = Colors.orange;
        break;
      case SocketState.connected:
        color = Colors.green;
        break;
      case SocketState.disconnected:
        color = Colors.red;
        break;
      case SocketState.error:
        color = Colors.red;
    }
    return Container(
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(Icons.circle, color: color, size: 12),
    );
  }
}
