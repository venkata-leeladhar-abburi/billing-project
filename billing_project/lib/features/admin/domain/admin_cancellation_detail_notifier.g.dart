// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancellation_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminCancellationDetailNotifier)
final adminCancellationDetailProvider =
    AdminCancellationDetailNotifierFamily._();

final class AdminCancellationDetailNotifierProvider
    extends
        $NotifierProvider<
          AdminCancellationDetailNotifier,
          AsyncValue<CancellationRequest>
        > {
  AdminCancellationDetailNotifierProvider._({
    required AdminCancellationDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'adminCancellationDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminCancellationDetailNotifierHash();

  @override
  String toString() {
    return r'adminCancellationDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AdminCancellationDetailNotifier create() => AdminCancellationDetailNotifier();

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
    return other is AdminCancellationDetailNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminCancellationDetailNotifierHash() =>
    r'89bd367218b7691c01d422d7a3b7d742a40f13d3';

final class AdminCancellationDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          AdminCancellationDetailNotifier,
          AsyncValue<CancellationRequest>,
          AsyncValue<CancellationRequest>,
          AsyncValue<CancellationRequest>,
          String
        > {
  AdminCancellationDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'adminCancellationDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdminCancellationDetailNotifierProvider call(String requestId) =>
      AdminCancellationDetailNotifierProvider._(
        argument: requestId,
        from: this,
      );

  @override
  String toString() => r'adminCancellationDetailProvider';
}

abstract class _$AdminCancellationDetailNotifier
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
