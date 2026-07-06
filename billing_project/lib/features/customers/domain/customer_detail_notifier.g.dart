// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomerDetailNotifier)
final customerDetailProvider = CustomerDetailNotifierFamily._();

final class CustomerDetailNotifierProvider
    extends
        $NotifierProvider<
          CustomerDetailNotifier,
          AsyncValue<CustomerDetailState>
        > {
  CustomerDetailNotifierProvider._({
    required CustomerDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'customerDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerDetailNotifierHash();

  @override
  String toString() {
    return r'customerDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CustomerDetailNotifier create() => CustomerDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CustomerDetailState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CustomerDetailState>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerDetailNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerDetailNotifierHash() =>
    r'4c0af969fb737654ac92c2c5d39c67209ef3fbc2';

final class CustomerDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CustomerDetailNotifier,
          AsyncValue<CustomerDetailState>,
          AsyncValue<CustomerDetailState>,
          AsyncValue<CustomerDetailState>,
          String
        > {
  CustomerDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'customerDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CustomerDetailNotifierProvider call(String customerId) =>
      CustomerDetailNotifierProvider._(argument: customerId, from: this);

  @override
  String toString() => r'customerDetailProvider';
}

abstract class _$CustomerDetailNotifier
    extends $Notifier<AsyncValue<CustomerDetailState>> {
  late final _$args = ref.$arg as String;
  String get customerId => _$args;

  AsyncValue<CustomerDetailState> build(String customerId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<CustomerDetailState>,
              AsyncValue<CustomerDetailState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CustomerDetailState>,
                AsyncValue<CustomerDetailState>
              >,
              AsyncValue<CustomerDetailState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
