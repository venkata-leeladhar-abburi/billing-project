// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CancellationDetailNotifier)
final cancellationDetailProvider = CancellationDetailNotifierFamily._();

final class CancellationDetailNotifierProvider
    extends
        $NotifierProvider<
          CancellationDetailNotifier,
          AsyncValue<CancellationRequest>
        > {
  CancellationDetailNotifierProvider._({
    required CancellationDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'cancellationDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cancellationDetailNotifierHash();

  @override
  String toString() {
    return r'cancellationDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CancellationDetailNotifier create() => CancellationDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CancellationRequest> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CancellationRequest>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CancellationDetailNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cancellationDetailNotifierHash() =>
    r'cde025830e4d3b1ba3b95e07c996ea8cc91eb2fc';

final class CancellationDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CancellationDetailNotifier,
          AsyncValue<CancellationRequest>,
          AsyncValue<CancellationRequest>,
          AsyncValue<CancellationRequest>,
          String
        > {
  CancellationDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'cancellationDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CancellationDetailNotifierProvider call(String requestId) =>
      CancellationDetailNotifierProvider._(argument: requestId, from: this);

  @override
  String toString() => r'cancellationDetailProvider';
}

abstract class _$CancellationDetailNotifier
    extends $Notifier<AsyncValue<CancellationRequest>> {
  late final _$args = ref.$arg as String;
  String get requestId => _$args;

  AsyncValue<CancellationRequest> build(String requestId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<CancellationRequest>,
              AsyncValue<CancellationRequest>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CancellationRequest>,
                AsyncValue<CancellationRequest>
              >,
              AsyncValue<CancellationRequest>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
