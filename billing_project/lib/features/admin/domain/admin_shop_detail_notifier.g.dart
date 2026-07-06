// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_shop_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminShopDetailNotifier)
final adminShopDetailProvider = AdminShopDetailNotifierFamily._();

final class AdminShopDetailNotifierProvider
    extends $NotifierProvider<AdminShopDetailNotifier, AsyncValue<ShopModel>> {
  AdminShopDetailNotifierProvider._({
    required AdminShopDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'adminShopDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminShopDetailNotifierHash();

  @override
  String toString() {
    return r'adminShopDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AdminShopDetailNotifier create() => AdminShopDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ShopModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ShopModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AdminShopDetailNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminShopDetailNotifierHash() =>
    r'8ad7ff0c7506c9def005f3ec0d14fd071a2388db';

final class AdminShopDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          AdminShopDetailNotifier,
          AsyncValue<ShopModel>,
          AsyncValue<ShopModel>,
          AsyncValue<ShopModel>,
          String
        > {
  AdminShopDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'adminShopDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdminShopDetailNotifierProvider call(String shopId) =>
      AdminShopDetailNotifierProvider._(argument: shopId, from: this);

  @override
  String toString() => r'adminShopDetailProvider';
}

abstract class _$AdminShopDetailNotifier
    extends $Notifier<AsyncValue<ShopModel>> {
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
