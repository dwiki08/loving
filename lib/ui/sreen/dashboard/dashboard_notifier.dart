import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loving/loving/command/general_cmd.dart';
import 'package:loving/loving/data/map_area_notifier.dart';
import 'package:loving/loving/data/player_notifier.dart';
import 'package:loving/model/login_model.dart';
import 'package:loving/preset/base_preset.dart';
import 'package:loving/preset/battleunder_b.dart';
import 'package:loving/preset/supplies_the_wheel.dart';
import 'package:loving/preset/void_aura.dart';

import '../../../loving/socket/socket_client.dart';
import '../../../preset/afk_idhq.dart';
import '../../../preset/nulgath_bday_pet_farm.dart';
import 'dashboard_state.dart';

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);

class DashboardNotifier extends Notifier<DashboardState> {
  GeneralCmd get _generalCmd => ref.read(generalCmdProvider);

  @override
  DashboardState build() {
    return DashboardState(
      presets: [
        ref.read(nulgathBdayFarmProvider),
        ref.read(battleUnderBProvider),
        ref.read(afkIdhqProvider),
        ref.read(voidAuraProvider),
        ref.read(suppliesTheWheelProvider),
      ],
    );
  }

  void sendChat(String text) async {
    _generalCmd.sendChat(message: text);
  }

  Future<void> connect(String server, LoginModel loginModel) async {
    // connect to socket
    await ref
        .read(socketProvider)
        .connectToServer(server: server, loginModel: loginModel);

    // waiting for character load complete
    while (!ref.read(socketProvider).isCharacterLoadComplete) {
      await Future.delayed(Duration(microseconds: 200));
    }

    // set player and map data
    state = state.copyWith(
      player: ref.read(playerProvider),
      map: ref.read(areaMapProvider),
    );

    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> disconnect() async {
    ref.invalidate(socketProvider);
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
