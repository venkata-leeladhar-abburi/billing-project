// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancellation_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminCancellationListNotifier)
final adminCancellationListProvider = AdminCancellationListNotifierProvider._();

final class AdminCancellationListNotifierProvider
    extends
        $NotifierProvider<
          AdminCancellationListNotifier,
          AsyncValue<AdminCancellationListState>
        > {
  AdminCancellationListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminCancellationListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminCancellationListNotifierHash();

  @$internal
  @override
  AdminCancellationListNotifier create() => AdminCancellationListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AdminCancellationListState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<AdminCancellationListState>>(value),
    );
  }
}

String _$adminCancellationListNotifierHash() =>
    r'e40565d0393f572bf875e3ed74c0619227caf1fa';

abstract class _$AdminCancellationListNotifier
    extends $Notifier<AsyncValue<AdminCancellationListState>> {
  AsyncValue<AdminCancellationListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<AdminCancellationListState>,
              AsyncValue<AdminCancellationListState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AdminCancellationListState>,
                AsyncValue<AdminCancellationListState>
              >,
              AsyncValue<AdminCancellationListState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
