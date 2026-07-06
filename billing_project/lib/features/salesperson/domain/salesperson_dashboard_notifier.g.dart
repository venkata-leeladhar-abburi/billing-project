// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salesperson_dashboard_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalespersonDashboardNotifier)
final salespersonDashboardProvider = SalespersonDashboardNotifierProvider._();

final class SalespersonDashboardNotifierProvider
    extends
        $NotifierProvider<
          SalespersonDashboardNotifier,
          AsyncValue<SalespersonDashboardState>
        > {
  SalespersonDashboardNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salespersonDashboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salespersonDashboardNotifierHash();

  @$internal
  @override
  SalespersonDashboardNotifier create() => SalespersonDashboardNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SalespersonDashboardState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<SalespersonDashboardState>>(value),
    );
  }
}

String _$salespersonDashboardNotifierHash() =>
    r'20711509eeaaa617e04b143acee0ac82b0a010b8';

abstract class _$SalespersonDashboardNotifier
    extends $Notifier<AsyncValue<SalespersonDashboardState>> {
  AsyncValue<SalespersonDashboardState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<SalespersonDashboardState>,
              AsyncValue<SalespersonDashboardState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SalespersonDashboardState>,
                AsyncValue<SalespersonDashboardState>
              >,
              AsyncValue<SalespersonDashboardState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
