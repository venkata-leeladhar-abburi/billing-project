// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topup_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TopupNotifier)
final topupProvider = TopupNotifierProvider._();

final class TopupNotifierProvider
    extends $NotifierProvider<TopupNotifier, AsyncValue<TopupState>> {
  TopupNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topupNotifierHash();

  @$internal
  @override
  TopupNotifier create() => TopupNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TopupState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TopupState>>(value),
    );
  }
}

String _$topupNotifierHash() => r'a7773e22883eb26cd0ff11325d1ac3e1dda50fcf';

abstract class _$TopupNotifier extends $Notifier<AsyncValue<TopupState>> {
  AsyncValue<TopupState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<TopupState>, AsyncValue<TopupState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TopupState>, AsyncValue<TopupState>>,
              AsyncValue<TopupState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
