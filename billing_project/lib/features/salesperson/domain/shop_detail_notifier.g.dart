// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShopDetailNotifier)
final shopDetailProvider = ShopDetailNotifierFamily._();

final class ShopDetailNotifierProvider
    extends $NotifierProvider<ShopDetailNotifier, AsyncValue<ShopModel>> {
  ShopDetailNotifierProvider._({
    required ShopDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'shopDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shopDetailNotifierHash();

  @override
  String toString() {
    return r'shopDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ShopDetailNotifier create() => ShopDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ShopModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ShopModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShopDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shopDetailNotifierHash() =>
    r'0dd61c00a44da27b0679d01b59ebb72c34637e3b';

final class ShopDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ShopDetailNotifier,
          AsyncValue<ShopModel>,
          AsyncValue<ShopModel>,
          AsyncValue<ShopModel>,
          String
        > {
  ShopDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'shopDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShopDetailNotifierProvider call(String shopId) =>
      ShopDetailNotifierProvider._(argument: shopId, from: this);

  @override
  String toString() => r'shopDetailProvider';
}

abstract class _$ShopDetailNotifier extends $Notifier<AsyncValue<ShopModel>> {
  late final _$args = ref.$arg as String;
  String get shopId => _$args;

  AsyncValue<ShopModel> build(String shopId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ShopModel>, AsyncValue<ShopModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ShopModel>, AsyncValue<ShopModel>>,
              AsyncValue<ShopModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
