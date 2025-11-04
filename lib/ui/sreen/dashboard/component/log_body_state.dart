import 'package:hooks_riverpod/hooks_riverpod.dart';

class LogBodyState {
  final bool hideOptions;

  const LogBodyState({this.hideOptions = true});

  LogBodyState copyWith({bool? hideOptions}) {
    return LogBodyState(hideOptions: hideOptions ?? this.hideOptions);
  }
}

class LogBodyNotifier extends Notifier<LogBodyState> {
  @override
  LogBodyState build() {
    return const LogBodyState();
  }

  void toggleHideOptions() {
    state = state.copyWith(hideOptions: !state.hideOptions);
  }

  void setHideOptions(bool hide) {
    state = state.copyWith(hideOptions: hide);
  }
}

final logBodyProvider = NotifierProvider<LogBodyNotifier, LogBodyState>(
  LogBodyNotifier.new,
);
