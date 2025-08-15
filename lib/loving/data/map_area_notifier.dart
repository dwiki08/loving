import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/game/area_map.dart';

final areaMapProvider = StateNotifierProvider<AreaMapNotifier, AreaMap>((ref) {
  return AreaMapNotifier();
});

class AreaMapNotifier extends StateNotifier<AreaMap> {
  AreaMapNotifier() : super(const AreaMap());

  void update(AreaMap areaMap) {
    state = areaMap;
  }

  void clear() {
    state = const AreaMap();
  }

  void setAreaId(String areaId) {
    state = state.copyWith(areaId: areaId);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }
}
