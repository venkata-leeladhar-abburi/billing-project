// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_shop_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditShopNotifier)
final editShopProvider = EditShopNotifierFamily._();

final class EditShopNotifierProvider
    extends $NotifierProvider<EditShopNotifier, AsyncValue<ShopModel>> {
  EditShopNotifierProvider._({
    required EditShopNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'editShopProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$editShopNotifierHash();

  @override
  String toString() {
    return r'editShopProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EditShopNotifier create() => EditShopNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ShopModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ShopModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EditShopNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$editShopNotifierHash() => r'fb8e48450cf8c89048074e819689a29087d1642c';

final class EditShopNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          EditShopNotifier,
          AsyncValue<ShopModel>,
          AsyncValue<ShopModel>,
          AsyncValue<ShopModel>,
          String
        > {
  EditShopNotifierFamily._()
    : super(
        retry: null,
        name: r'editShopProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EditShopNotifierProvider call(String shopId) =>
      EditShopNotifierProvider._(argument: shopId, from: this);

  @override
  String toString() => r'editShopProvider';
}

abstract class _$EditShopNotifier extends $Notifier<AsyncValue<ShopModel>> {
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
