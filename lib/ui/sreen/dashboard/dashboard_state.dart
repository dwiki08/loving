import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving/model/error_result.dart';
import 'package:loving/model/game/area_map.dart';
import 'package:loving/preset/base_preset.dart';

import '../../../model/game/player.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(false) bool isRunning,
    @Default(false) bool showDebug,
    ErrorResult? error,
    @Default([]) List<BasePreset> presets,
    BasePreset? selectedPreset,
    Player? player,
    AreaMap? map,
  }) = _DashboardState;
}
