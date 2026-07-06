// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_shop_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddShopNotifier)
final addShopProvider = AddShopNotifierProvider._();

final class AddShopNotifierProvider
    extends $NotifierProvider<AddShopNotifier, AddShopState> {
  AddShopNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addShopProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addShopNotifierHash();

  @$internal
  @override
  AddShopNotifier create() => AddShopNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddShopState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddShopState>(value),
    );
  }
}

String _$addShopNotifierHash() => r'6ed67ca9ec42ef8de012fb2910a989a2a8beefe6';

abstract class _$AddShopNotifier extends $Notifier<AddShopState> {
  AddShopState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AddShopState, AddShopState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddShopState, AddShopState>,
              AddShopState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
