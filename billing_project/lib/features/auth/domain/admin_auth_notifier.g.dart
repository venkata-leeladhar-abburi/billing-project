// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminAuthNotifier)
final adminAuthProvider = AdminAuthNotifierProvider._();

final class AdminAuthNotifierProvider
    extends $NotifierProvider<AdminAuthNotifier, AsyncValue<String>> {
  AdminAuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminAuthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminAuthNotifierHash();

  @$internal
  @override
  AdminAuthNotifier create() => AdminAuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<String>>(value),
    );
  }
}

String _$adminAuthNotifierHash() => r'022eca8ac23167b9bdc743511edb3f378820f2a3';

abstract class _$AdminAuthNotifier extends $Notifier<AsyncValue<String>> {
  AsyncValue<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, AsyncValue<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, AsyncValue<String>>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
