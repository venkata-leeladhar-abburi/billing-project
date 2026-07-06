// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salesperson_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalespersonDetailNotifier)
final salespersonDetailProvider = SalespersonDetailNotifierFamily._();

final class SalespersonDetailNotifierProvider
    extends
        $NotifierProvider<
          SalespersonDetailNotifier,
          AsyncValue<SalespersonDetailState>
        > {
  SalespersonDetailNotifierProvider._({
    required SalespersonDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'salespersonDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salespersonDetailNotifierHash();

  @override
  String toString() {
    return r'salespersonDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SalespersonDetailNotifier create() => SalespersonDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SalespersonDetailState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SalespersonDetailState>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SalespersonDetailNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salespersonDetailNotifierHash() =>
    r'9243414188d4dd6a36a31395affa26a433484fb8';

final class SalespersonDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SalespersonDetailNotifier,
          AsyncValue<SalespersonDetailState>,
          AsyncValue<SalespersonDetailState>,
          AsyncValue<SalespersonDetailState>,
          String
        > {
  SalespersonDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'salespersonDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SalespersonDetailNotifierProvider call(String salespersonId) =>
      SalespersonDetailNotifierProvider._(argument: salespersonId, from: this);

  @override
  String toString() => r'salespersonDetailProvider';
}

abstract class _$SalespersonDetailNotifier
    extends $Notifier<AsyncValue<SalespersonDetailState>> {
  late final _$args = ref.$arg as String;
  String get salespersonId => _$args;

  AsyncValue<SalespersonDetailState> build(String salespersonId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<SalespersonDetailState>,
              AsyncValue<SalespersonDetailState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SalespersonDetailState>,
                AsyncValue<SalespersonDetailState>
              >,
              AsyncValue<SalespersonDetailState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
