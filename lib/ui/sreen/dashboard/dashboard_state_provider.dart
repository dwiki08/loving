import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/game/chat.dart';
import '../../../model/packet.dart';
import '../../../model/socket_state.dart';

class DashboardScreenState {
  final List<Packet> logs;
  final List<Packet> debugs;
  final List<Chat> chats;
  final SocketState socketState;
  final Timer? timer;
  final Duration duration;

  const DashboardScreenState({
    this.logs = const [],
    this.debugs = const [],
    this.chats = const [],
    this.socketState = SocketState.disconnected,
    this.timer,
    this.duration = Duration.zero,
  });

  DashboardScreenState copyWith({
    List<Packet>? logs,
    List<Packet>? debugs,
    List<Chat>? chats,
    SocketState? socketState,
    Timer? timer,
    Duration? duration,
  }) {
    return DashboardScreenState(
      logs: logs ?? this.logs,
      debugs: debugs ?? this.debugs,
      chats: chats ?? this.chats,
      socketState: socketState ?? this.socketState,
      timer: timer ?? this.timer,
      duration: duration ?? this.duration,
    );
  }
}

class DashboardScreenNotifier extends Notifier<DashboardScreenState> {
  @override
  DashboardScreenState build() {
    return const DashboardScreenState();
  }

  static const int _maxPackets = 100;

  void addLog(Packet packet) {
    final newList = [...state.logs, packet];
    if (newList.length > _maxPackets) {
      newList.removeAt(0);
    }
    state = state.copyWith(logs: newList);
  }

  void addDebug(Packet packet) {
    final newList = [...state.debugs, packet];
    if (newList.length > _maxPackets) {
      newList.removeAt(0);
    }
    state = state.copyWith(debugs: newList);
  }

  void addChat(Chat chat) {
    final newList = [...state.chats, chat];
    if (newList.length > _maxPackets) {
      newList.removeAt(0);
    }
    state = state.copyWith(chats: newList);
  }

  void updateSocketState(SocketState newState) {
    state = state.copyWith(socketState: newState);
  }

  void startTimer() {
    state.timer?.cancel();
    final newTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(
        duration: Duration(seconds: state.duration.inSeconds + 1),
      );
    });
    state = state.copyWith(timer: newTimer, duration: Duration.zero);
  }

  void stopTimer() {
    state.timer?.cancel();
    state = state.copyWith(timer: null, duration: Duration.zero);
  }

  void resetDuration() {
    state = state.copyWith(duration: Duration.zero);
  }

  void clear() {
    state.timer?.cancel();
    state = const DashboardScreenState();
  }
}

final dashboardScreenProvider =
    NotifierProvider<DashboardScreenNotifier, DashboardScreenState>(
      DashboardScreenNotifier.new,
    );
