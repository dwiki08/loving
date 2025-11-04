import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/loving/data/map_area_notifier.dart';
import 'package:loving/loving/data/player_notifier.dart';
import 'package:loving/model/login_model.dart';
import 'package:loving/preset/base_preset.dart';

import '../../../services/bot_manager.dart';
import 'dashboard_state.dart';

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    return const DashboardState();
  }

  void updateGameData() {
    state = state.copyWith(
      player: ref.read(playerProvider),
      map: ref.read(areaMapProvider),
    );
  }

  void toggleDebug(bool b) {
    state = state.copyWith(showDebug: b);
  }

  void selectPreset(BasePreset? preset) {
    state = state.copyWith(selectedPreset: preset);
  }

  Future<void> connect(String server, LoginModel loginModel) async {
    await ref.read(botManagerProvider.notifier).connect(server, loginModel);
    updateGameData();
  }

  Future<void> disconnect() async {
    await ref.read(botManagerProvider.notifier).disconnect();
  }

  void sendChat(String text) {
    ref.read(botManagerProvider.notifier).sendChat(text);
  }

  Future<void> start() async {
    final selectedPreset = state.selectedPreset;
    if (selectedPreset != null) {
      await ref.read(botManagerProvider.notifier).startBot(selectedPreset);
    }
  }

  Future<void> stop() async {
    await ref.read(botManagerProvider.notifier).stopBot();
  }
}
