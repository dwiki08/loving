// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginNotifier)
const loginProvider = LoginNotifierProvider._();

final class LoginNotifierProvider
    extends $NotifierProvider<LoginNotifier, AsyncValue<LoginModel?>> {
  const LoginNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginNotifierHash();

  @$internal
  @override
  LoginNotifier create() => LoginNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<LoginModel?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<LoginModel?>>(value),
    );
  }
}

String _$loginNotifierHash() => r'045067ee8ea07fed4f8ba490ab9b339e2af64c03';

abstract class _$LoginNotifier extends $Notifier<AsyncValue<LoginModel?>> {
  AsyncValue<LoginModel?> build();

  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<LoginModel?>, AsyncValue<LoginModel?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LoginModel?>, AsyncValue<LoginModel?>>,
              AsyncValue<LoginModel?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
