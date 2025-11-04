import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/server_list.dart';

class LoginFormState {
  final ServerList selectedServer;
  final bool isPasswordVisible;

  const LoginFormState({
    this.selectedServer = ServerList.alteon,
    this.isPasswordVisible = false,
  });

  LoginFormState copyWith({
    ServerList? selectedServer,
    bool? isPasswordVisible,
  }) {
    return LoginFormState(
      selectedServer: selectedServer ?? this.selectedServer,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}

class LoginFormNotifier extends Notifier<LoginFormState> {
  @override
  LoginFormState build() {
    return const LoginFormState();
  }

  void setSelectedServer(ServerList server) {
    state = state.copyWith(selectedServer: server);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }
}

final loginFormProvider = NotifierProvider<LoginFormNotifier, LoginFormState>(
  LoginFormNotifier.new,
);
