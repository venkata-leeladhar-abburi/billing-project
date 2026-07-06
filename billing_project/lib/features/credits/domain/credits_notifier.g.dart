// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credits_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreditsNotifier)
final creditsProvider = CreditsNotifierProvider._();

final class CreditsNotifierProvider
    extends $NotifierProvider<CreditsNotifier, AsyncValue<CreditsState>> {
  CreditsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'creditsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$creditsNotifierHash();

  @$internal
  @override
  CreditsNotifier create() => CreditsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CreditsState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CreditsState>>(value),
    );
  }
}

String _$creditsNotifierHash() => r'8f6b18c8bf0ad41620f5fc5f2124fd2daa5cc38a';

abstract class _$CreditsNotifier extends $Notifier<AsyncValue<CreditsState>> {
  AsyncValue<CreditsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CreditsState>, AsyncValue<CreditsState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CreditsState>, AsyncValue<CreditsState>>,
              AsyncValue<CreditsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
