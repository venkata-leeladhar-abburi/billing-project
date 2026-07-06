// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plans_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlansNotifier)
final plansProvider = PlansNotifierProvider._();

final class PlansNotifierProvider
    extends $NotifierProvider<PlansNotifier, AsyncValue<PlansState>> {
  PlansNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plansNotifierHash();

  @$internal
  @override
  PlansNotifier create() => PlansNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<PlansState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<PlansState>>(value),
    );
  }
}

String _$plansNotifierHash() => r'fd468b6474695e22ded9c1b626dbe7642b7f0d05';

abstract class _$PlansNotifier extends $Notifier<AsyncValue<PlansState>> {
  AsyncValue<PlansState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PlansState>, AsyncValue<PlansState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlansState>, AsyncValue<PlansState>>,
              AsyncValue<PlansState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
