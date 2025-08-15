import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loving/loving/data/map_area_notifier.dart';
import 'package:loving/loving/data/player_notifier.dart';
import 'package:loving/model/login_model.dart';
import 'package:loving/preset/base_preset.dart';

import '../../../loving/socket/socket_client.dart';
import '../../../preset/afk_idhq.dart';
import 'dashboard_state.dart';

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    return DashboardState(presets: [ref.read(afkIdhqProvider)]);
  }

  void sendChat(String text) async {
    ref.read(socketProvider).sendChat(text);
  }

  Future<void> connect(String server, LoginModel loginModel) async {
    await ref
        .read(socketProvider)
        .connectToServer(server: server, loginModel: loginModel);

    while (!ref.read(socketProvider).isClientReady()) {
      await Future.delayed(Duration(microseconds: 200));
    }

    state = state.copyWith(
      player: ref.read(playerProvider),
      map: ref.read(areaMapProvider),
    );

    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> disconnect() async {
    await ref.read(socketProvider).close();
  }

  void toggleDebug(bool b) {
    state = state.copyWith(showDebug: b);
  }

  void selectPreset(BasePreset? preset) {
    state = state.copyWith(selectedPreset: preset);
  }

  Future<void> start() async {
    state = state.copyWith(isRunning: true);
    state.selectedPreset?.start();
  }

  Future<void> stop() async {
    state = state.copyWith(isRunning: false);
    state.selectedPreset?.stop();
  }
}
