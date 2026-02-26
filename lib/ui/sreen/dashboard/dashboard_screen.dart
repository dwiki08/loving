import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/ui/component/logout_button.dart';
import 'package:loving/ui/sreen/dashboard/component/chat_body.dart';
import 'package:loving/ui/sreen/dashboard/component/log_body.dart';

import '../../../common/utils.dart';
import '../../../di/di_provider.dart';
import '../../../model/game/chat.dart';
import '../../../model/login_model.dart';
import '../../../model/packet.dart';
import '../../../model/socket_state.dart';
import '../../../services/bot_manager.dart';
import '../../component/socket_status_icon.dart';
import '../../theme.dart';
import 'component/debug_body.dart';
import 'dashboard_notifier.dart';
import 'dashboard_state_provider.dart';

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
    final tabController = useTabController(initialLength: 3);
    final dashboardScreenState = ref.watch(dashboardScreenProvider);

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
        ref.read(dashboardScreenProvider.notifier).updateSocketState(state);
        if (state == SocketState.connected) {
          ref.read(dashboardScreenProvider.notifier).startTimer();
        } else {
          ref.read(dashboardScreenProvider.notifier).stopTimer();
        }
      });
    });

    // Chat stream listener
    ref.listen<AsyncValue<Chat>>(socketChatProvider, (prev, next) {
      next.whenData((chat) {
        ref.read(dashboardScreenProvider.notifier).addChat(chat);
      });
    });

    // Packet stream listener
    ref.listen<AsyncValue<Packet>>(socketPacketProvider, (prev, next) {
      next.whenData((packet) {
        final showDebug = ref.watch(
          dashboardNotifierProvider.select((s) => s.showDebug),
        );

        if ((packet.isDebug && packet.packetSender == PacketSender.client) ||
            showDebug) {
          ref.read(dashboardScreenProvider.notifier).addDebug(packet);
        }
        if (packet.isLog) {
          ref.read(dashboardScreenProvider.notifier).addLog(packet);
        }
      });
    });

    final notifier = ref.read(dashboardNotifierProvider.notifier);
    final username = ref.watch(
      dashboardNotifierProvider.select((s) => s.player?.username),
    );

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
            Text('$server ${username != null ? ': $username' : ''}'),
            Row(
              children: [
                SocketStatusIcon(state: dashboardScreenState.socketState),
                const SizedBox(width: 8),
                Text(
                  formatDuration(dashboardScreenState.duration),
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
              // kill app
              await SystemNavigator.pop();
              exit(0);
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          LogBody(
            packets: dashboardScreenState.logs,
            presets: ref.watch(botManagerProvider.select((s) => s.presets)),
            isRunning: ref.watch(botManagerProvider.select((s) => s.isRunning)),
            selectedPreset: ref.watch(
              dashboardNotifierProvider.select((s) => s.selectedPreset),
            ),
            onSelectPreset: (preset) {
              notifier.selectPreset(preset);
            },
            onToggleStart: () {
              if (ref.read(botManagerProvider).isRunning) {
                notifier.stop();
              } else {
                notifier.start();
              }
            },
          ),
          ChatBody(
            chats: dashboardScreenState.chats,
            onSendChat: (text) {
              notifier.sendChat(text);
            },
          ),
          DebugBody(
            packets: dashboardScreenState.debugs,
            player: ref.watch(
              dashboardNotifierProvider.select((s) => s.player),
            ),
            map: ref.watch(dashboardNotifierProvider.select((s) => s.map)),
            showDebug: ref.watch(
              dashboardNotifierProvider.select((s) => s.showDebug),
            ),
            onToggleDebug: (b) {
              notifier.toggleDebug(b);
            },
          ),
        ],
      ),
    );
  }
}
