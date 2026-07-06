// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RevenueNotifier)
final revenueProvider = RevenueNotifierProvider._();

final class RevenueNotifierProvider
    extends $NotifierProvider<RevenueNotifier, AsyncValue<RevenueState>> {
  RevenueNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'revenueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$revenueNotifierHash();

  @$internal
  @override
  RevenueNotifier create() => RevenueNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<RevenueState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<RevenueState>>(value),
    );
  }
}

String _$revenueNotifierHash() => r'ed42c5a366219a2996ee35a8ee2572b69e2d7547';

abstract class _$RevenueNotifier extends $Notifier<AsyncValue<RevenueState>> {
  AsyncValue<RevenueState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<RevenueState>, AsyncValue<RevenueState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RevenueState>, AsyncValue<RevenueState>>,
              AsyncValue<RevenueState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
