// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CancellationListNotifier)
final cancellationListProvider = CancellationListNotifierProvider._();

final class CancellationListNotifierProvider
    extends
        $NotifierProvider<
          CancellationListNotifier,
          AsyncValue<CancellationListState>
        > {
  CancellationListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cancellationListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cancellationListNotifierHash();

  @$internal
  @override
  CancellationListNotifier create() => CancellationListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CancellationListState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CancellationListState>>(
        value,
      ),
    );
  }
}

String _$cancellationListNotifierHash() =>
    r'2c1d3eeb57095ff067289ece5351b2dc02f60319';

abstract class _$CancellationListNotifier
    extends $Notifier<AsyncValue<CancellationListState>> {
  AsyncValue<CancellationListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<CancellationListState>,
              AsyncValue<CancellationListState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CancellationListState>,
                AsyncValue<CancellationListState>
              >,
              AsyncValue<CancellationListState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
