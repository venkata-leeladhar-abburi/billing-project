// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_customer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddCustomerNotifier)
final addCustomerProvider = AddCustomerNotifierProvider._();

final class AddCustomerNotifierProvider
    extends
        $NotifierProvider<AddCustomerNotifier, AsyncValue<AddCustomerState>> {
  AddCustomerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addCustomerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addCustomerNotifierHash();

  @$internal
  @override
  AddCustomerNotifier create() => AddCustomerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AddCustomerState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AddCustomerState>>(value),
    );
  }
}

String _$addCustomerNotifierHash() =>
    r'0ee2fe7b4579ccccb6b0a73ed340310ce6548621';

abstract class _$AddCustomerNotifier
    extends $Notifier<AsyncValue<AddCustomerState>> {
  AsyncValue<AddCustomerState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<AddCustomerState>, AsyncValue<AddCustomerState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AddCustomerState>,
                AsyncValue<AddCustomerState>
              >,
              AsyncValue<AddCustomerState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
