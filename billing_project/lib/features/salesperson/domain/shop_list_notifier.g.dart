// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShopListNotifier)
final shopListProvider = ShopListNotifierProvider._();

final class ShopListNotifierProvider
    extends $NotifierProvider<ShopListNotifier, AsyncValue<ShopListState>> {
  ShopListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopListNotifierHash();

  @$internal
  @override
  ShopListNotifier create() => ShopListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ShopListState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ShopListState>>(value),
    );
  }
}

String _$shopListNotifierHash() => r'f6058a863dea1fc25c803ce0992beff5ce18a121';

abstract class _$ShopListNotifier extends $Notifier<AsyncValue<ShopListState>> {
  AsyncValue<ShopListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ShopListState>, AsyncValue<ShopListState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ShopListState>, AsyncValue<ShopListState>>,
              AsyncValue<ShopListState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
