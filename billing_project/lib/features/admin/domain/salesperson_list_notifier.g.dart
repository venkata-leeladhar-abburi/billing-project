// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salesperson_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalespersonListNotifier)
final salespersonListProvider = SalespersonListNotifierProvider._();

final class SalespersonListNotifierProvider
    extends
        $NotifierProvider<
          SalespersonListNotifier,
          AsyncValue<AdminSalespersonListState>
        > {
  SalespersonListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salespersonListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salespersonListNotifierHash();

  @$internal
  @override
  SalespersonListNotifier create() => SalespersonListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AdminSalespersonListState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<AdminSalespersonListState>>(value),
    );
  }
}

String _$salespersonListNotifierHash() =>
    r'e60ba21bc8eda526c858be79642abc8985a996c4';

abstract class _$SalespersonListNotifier
    extends $Notifier<AsyncValue<AdminSalespersonListState>> {
  AsyncValue<AdminSalespersonListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<AdminSalespersonListState>,
              AsyncValue<AdminSalespersonListState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AdminSalespersonListState>,
                AsyncValue<AdminSalespersonListState>
              >,
              AsyncValue<AdminSalespersonListState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
