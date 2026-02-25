import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../di/di_provider.dart';
import '../loving/command/general_cmd.dart';
import '../loving/data/map_area_notifier.dart';
import '../loving/data/player_notifier.dart';
import '../loving/socket/socket_client.dart';
import '../model/login_model.dart';
import '../model/socket_state.dart';
import '../preset/afk_idhq.dart';
import '../preset/base_preset.dart';
import '../preset/battleunder_b.dart';
import '../preset/doom_wheel.dart';
import '../preset/nulgath_bday_pet_farm.dart';
import '../preset/supplies_the_wheel.dart';
import '../preset/void_aura.dart';

class BotManagerState {
  final BasePreset? currentRunningPreset;
  final List<BasePreset> presets;
  final bool isRunning;

  const BotManagerState({
    this.currentRunningPreset,
    this.presets = const [],
    this.isRunning = false,
  });

  BotManagerState copyWith({
    BasePreset? currentRunningPreset,
    List<BasePreset>? presets,
    bool? isRunning,
  }) {
    return BotManagerState(
      currentRunningPreset: currentRunningPreset ?? this.currentRunningPreset,
      presets: presets ?? this.presets,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class BotManager extends Notifier<BotManagerState> {
  @override
  BotManagerState build() {
    final presets = [
      ref.read(doomWheelProvider),
      ref.read(nulgathBdayFarmProvider),
      ref.read(battleUnderBProvider),
      ref.read(afkIdhqProvider),
      ref.read(voidAuraProvider),
      ref.read(suppliesTheWheelProvider),
    ];

    return BotManagerState(presets: presets);
  }

  bool get isRunning => state.isRunning;

  List<BasePreset> get presets => state.presets;

  BasePreset? get currentRunningPreset => state.currentRunningPreset;

  Future<void> connect(String server, LoginModel loginModel) async {
    // connect to socket
    await ref
        .read(socketProvider)
        .connectToServer(server: server, loginModel: loginModel);

    // waiting for character load complete
    while (!ref.read(socketProvider).isCharacterLoadComplete) {
      await Future.delayed(Duration(microseconds: 200));
    }

    // Set up socket disconnect listener
    ref.listen<AsyncValue<SocketState>>(socketConnectionStateProvider, (
      prev,
      next,
    ) {
      next.whenData((socketState) {
        if (socketState == SocketState.disconnected) {
          final generalCmd = ref.read(generalCmdProvider);
          generalCmd.addLog('Disconnected from socket server.');
          stopBot();
        }
      });
    });
  }

  Future<void> disconnect() async {
    await stopBot();
    ref.read(socketProvider).sendPacket("%xt%zm%cmd%1%logout%");
    ref.read(playerProvider.notifier).clear();
    ref.read(areaMapProvider.notifier).clear();
    ref.invalidate(socketProvider);
  }

  /// Start the selected preset
  Future<void> startBot(BasePreset preset) async {
    state = state.copyWith(currentRunningPreset: preset, isRunning: true);
    await preset.start();
  }

  /// Stop the currently running bot
  Future<void> stopBot() async {
    await state.currentRunningPreset!.stop();
    state = state.copyWith(currentRunningPreset: null, isRunning: false);
  }

  /// Send chat message
  void sendChat(String text) {
    final generalCmd = ref.read(generalCmdProvider);
    generalCmd.sendChat(message: text);
  }
}

final botManagerProvider = NotifierProvider<BotManager, BotManagerState>(
  BotManager.new,
);
