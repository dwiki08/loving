import 'package:loving/model/login_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../loving/api/aqw_api.dart';

part 'login_notifier.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  AsyncValue<LoginModel?> build() => const AsyncValue.data(null);

  Future<void> login({
    required String username,
    required String password,
    required String server,
  }) async {
    state = const AsyncValue.loading();

    final api = ref.read(aqwApiProvider);

    final result = await api.getLoginInfo(
      username: username,
      password: password,
    );
    result.fold(
      (e) {
        state = AsyncValue.error(e, StackTrace.current);
        return;
      },
      (m) {
        state = AsyncValue.data(m);
      },
    );
  }
}
