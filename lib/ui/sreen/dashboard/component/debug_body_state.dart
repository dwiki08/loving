import 'package:hooks_riverpod/hooks_riverpod.dart';

class DebugBodyState {
  final bool showPlayer;
  final bool showMap;

  const DebugBodyState({this.showPlayer = false, this.showMap = false});

  DebugBodyState copyWith({bool? showPlayer, bool? showMap}) {
    return DebugBodyState(
      showPlayer: showPlayer ?? this.showPlayer,
      showMap: showMap ?? this.showMap,
    );
  }
}

class DebugBodyNotifier extends Notifier<DebugBodyState> {
  @override
  DebugBodyState build() {
    return const DebugBodyState();
  }

  void toggleShowPlayer() {
    state = state.copyWith(showPlayer: !state.showPlayer);
  }

  void toggleShowMap() {
    state = state.copyWith(showMap: !state.showMap);
  }
}

final debugBodyProvider = NotifierProvider<DebugBodyNotifier, DebugBodyState>(
  DebugBodyNotifier.new,
);
