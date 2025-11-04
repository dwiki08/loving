import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving/model/error_result.dart';
import 'package:loving/model/game/area_map.dart';

import '../../../model/game/player.dart';
import '../../../preset/base_preset.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(false) bool showDebug,
    ErrorResult? error,
    BasePreset? selectedPreset,
    Player? player,
    AreaMap? map,
  }) = _DashboardState;
}
