// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomerNotifier)
final customerProvider = CustomerNotifierProvider._();

final class CustomerNotifierProvider
    extends $NotifierProvider<CustomerNotifier, AsyncValue<CustomerListState>> {
  CustomerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerNotifierHash();

  @$internal
  @override
  CustomerNotifier create() => CustomerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CustomerListState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CustomerListState>>(
        value,
      ),
    );
  }
}

String _$customerNotifierHash() => r'b63683e6220b4365e816cfc6becbf35352ccff40';

abstract class _$CustomerNotifier
    extends $Notifier<AsyncValue<CustomerListState>> {
  AsyncValue<CustomerListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<CustomerListState>,
              AsyncValue<CustomerListState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CustomerListState>,
                AsyncValue<CustomerListState>
              >,
              AsyncValue<CustomerListState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
