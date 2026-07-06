// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_message_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BulkMessageNotifier)
final bulkMessageProvider = BulkMessageNotifierProvider._();

final class BulkMessageNotifierProvider
    extends
        $NotifierProvider<BulkMessageNotifier, AsyncValue<BulkMessageState>> {
  BulkMessageNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bulkMessageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bulkMessageNotifierHash();

  @$internal
  @override
  BulkMessageNotifier create() => BulkMessageNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<BulkMessageState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<BulkMessageState>>(value),
    );
  }
}

String _$bulkMessageNotifierHash() =>
    r'a46bb87226a2922fa18fad71a0efdf413e12403e';

abstract class _$BulkMessageNotifier
    extends $Notifier<AsyncValue<BulkMessageState>> {
  AsyncValue<BulkMessageState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<BulkMessageState>, AsyncValue<BulkMessageState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<BulkMessageState>,
                AsyncValue<BulkMessageState>
              >,
              AsyncValue<BulkMessageState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
