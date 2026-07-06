// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BillDetailNotifier)
final billDetailProvider = BillDetailNotifierFamily._();

final class BillDetailNotifierProvider
    extends $NotifierProvider<BillDetailNotifier, AsyncValue<BillDetailState>> {
  BillDetailNotifierProvider._({
    required BillDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'billDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$billDetailNotifierHash();

  @override
  String toString() {
    return r'billDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BillDetailNotifier create() => BillDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<BillDetailState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<BillDetailState>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BillDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$billDetailNotifierHash() =>
    r'eaafe3a664f788198f2198b808a2f96f7ae353b3';

final class BillDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          BillDetailNotifier,
          AsyncValue<BillDetailState>,
          AsyncValue<BillDetailState>,
          AsyncValue<BillDetailState>,
          String
        > {
  BillDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'billDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BillDetailNotifierProvider call(String billId) =>
      BillDetailNotifierProvider._(argument: billId, from: this);

  @override
  String toString() => r'billDetailProvider';
}

abstract class _$BillDetailNotifier
    extends $Notifier<AsyncValue<BillDetailState>> {
  late final _$args = ref.$arg as String;
  String get billId => _$args;

  AsyncValue<BillDetailState> build(String billId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<BillDetailState>, AsyncValue<BillDetailState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<BillDetailState>,
                AsyncValue<BillDetailState>
              >,
              AsyncValue<BillDetailState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
