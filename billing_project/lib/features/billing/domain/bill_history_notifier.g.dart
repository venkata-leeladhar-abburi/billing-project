// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_history_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BillHistoryNotifier)
final billHistoryProvider = BillHistoryNotifierProvider._();

final class BillHistoryNotifierProvider
    extends
        $NotifierProvider<BillHistoryNotifier, AsyncValue<BillHistoryState>> {
  BillHistoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'billHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$billHistoryNotifierHash();

  @$internal
  @override
  BillHistoryNotifier create() => BillHistoryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<BillHistoryState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<BillHistoryState>>(value),
    );
  }
}

String _$billHistoryNotifierHash() =>
    r'363ef9bc68df1855892bf7912a15fb3eeee1042c';

abstract class _$BillHistoryNotifier
    extends $Notifier<AsyncValue<BillHistoryState>> {
  AsyncValue<BillHistoryState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<BillHistoryState>, AsyncValue<BillHistoryState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<BillHistoryState>,
                AsyncValue<BillHistoryState>
              >,
              AsyncValue<BillHistoryState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
