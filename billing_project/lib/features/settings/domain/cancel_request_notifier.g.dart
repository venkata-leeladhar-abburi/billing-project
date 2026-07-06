// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_request_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CancelRequestNotifier)
final cancelRequestProvider = CancelRequestNotifierProvider._();

final class CancelRequestNotifierProvider
    extends
        $NotifierProvider<
          CancelRequestNotifier,
          AsyncValue<CancelRequestState>
        > {
  CancelRequestNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cancelRequestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cancelRequestNotifierHash();

  @$internal
  @override
  CancelRequestNotifier create() => CancelRequestNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CancelRequestState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CancelRequestState>>(
        value,
      ),
    );
  }
}

String _$cancelRequestNotifierHash() =>
    r'b05819469e83f391f336733c085339eb6f4c52eb';

abstract class _$CancelRequestNotifier
    extends $Notifier<AsyncValue<CancelRequestState>> {
  AsyncValue<CancelRequestState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<CancelRequestState>,
              AsyncValue<CancelRequestState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CancelRequestState>,
                AsyncValue<CancelRequestState>
              >,
              AsyncValue<CancelRequestState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
