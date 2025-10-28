import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/model/game/chat.dart';
import 'package:loving/model/packet.dart';
import 'package:loving/ui/component/logout_button.dart';
import 'package:loving/ui/sreen/dashboard/component/chat_body.dart';
import 'package:loving/ui/sreen/dashboard/component/log_body.dart';

import '../../../common/utils.dart';
import '../../../di/di_provider.dart';
import '../../../model/login_model.dart';
import '../../../model/socket_state.dart';
import '../../component/socket_status_icon.dart';
import '../../theme.dart';
import '../login/login_screen.dart';
import 'component/debug_body.dart';
import 'dashboard_notifier.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({
    super.key,
    required this.server,
    required this.loginModel,
  });

  final String server;
  final LoginModel loginModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = useState<List<Packet>>([]);
    final debugs = useState<List<Packet>>([]);
    final chats = useState<List<Chat>>([]);

    final socketState = useState(SocketState.disconnected);
    final timer = useState<Timer?>(null);
    final duration = useState(Duration.zero);

    final tabController = useTabController(initialLength: 3);

    // Initialize connection
    useEffect(() {
      Future.microtask(() async {
        await ref
            .read(dashboardNotifierProvider.notifier)
            .connect(server, loginModel);
      });
      return null;
    }, []);

    // Socket state listener
    ref.listen<AsyncValue<SocketState>>(socketConnectionStateProvider, (
      prev,
      next,
    ) {
      next.whenData((state) {
        socketState.value = state;
        if (state == SocketState.connected) {
          // Start new timer and duration counting
          timer.value?.cancel();
          duration.value = Duration.zero;
          timer.value = Timer.periodic(const Duration(seconds: 1), (_) {
            duration.value = Duration(seconds: duration.value.inSeconds + 1);
          });
        } else {
          timer.value?.cancel();
        }
      });
    });

    // Chat stream listener
    ref.listen<AsyncValue<Chat>>(socketChatProvider, (prev, next) {
      next.whenData((chat) {
        chats.value = [...chats.value, chat];
      });
    });

    // Packet stream listener
    ref.listen<AsyncValue<Packet>>(socketPacketProvider, (prev, next) {
      next.whenData((packet) {
        final showDebug = ref.watch(dashboardNotifierProvider).showDebug;

        if ((packet.isDebug && packet.packetSender == PacketSender.client) ||
            showDebug) {
          debugs.value = [...debugs.value, packet];
        }
        if (packet.isLog) {
          logs.value = [...logs.value, packet];
        }
      });
    });

    // Timer cleanup on dispose
    useEffect(() {
      return () {
        timer.value?.cancel();
      };
    }, []);

    final notifier = ref.read(dashboardNotifierProvider.notifier);
    final username = ref.watch(dashboardNotifierProvider).player?.username;

    useEffect(() {
      tabController.addListener(() {
        if (!tabController.indexIsChanging) {
          FocusScope.of(context).unfocus();
        }
      });

      return () {
        tabController.dispose();
      };
    }, [tabController]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Loving ${username != null ? ': $username' : ''}'),
            Row(
              children: [
                SocketStatusIcon(state: socketState.value),
                const SizedBox(width: 8),
                Text(
                  formatDuration(duration.value),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: tabController,
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
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          LogBody(
            packets: logs.value,
            presets: ref.watch(dashboardNotifierProvider).presets,
            isRunning: ref.watch(dashboardNotifierProvider).isRunning,
            selectedPreset: ref.watch(dashboardNotifierProvider).selectedPreset,
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
            chats: chats.value,
            onSendChat: (text) {
              notifier.sendChat(text);
            },
          ),
          DebugBody(
            packets: debugs.value,
            player: ref.watch(dashboardNotifierProvider).player,
            map: ref.watch(dashboardNotifierProvider).map,
            showDebug: ref.watch(dashboardNotifierProvider).showDebug,
            onToggleDebug: (b) {
              notifier.toggleDebug(b);
            },
          ),
        ],
      ),
    );
  }
}
