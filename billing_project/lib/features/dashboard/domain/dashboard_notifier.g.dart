// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DashboardNotifier)
final dashboardProvider = DashboardNotifierProvider._();

final class DashboardNotifierProvider
    extends $NotifierProvider<DashboardNotifier, AsyncValue<DashboardState>> {
  DashboardNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardNotifierHash();

  @$internal
  @override
  DashboardNotifier create() => DashboardNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<DashboardState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<DashboardState>>(value),
    );
  }
}

String _$dashboardNotifierHash() => r'3e43ba24bccebd725015724b280623533c38d3a3';

abstract class _$DashboardNotifier
    extends $Notifier<AsyncValue<DashboardState>> {
  AsyncValue<DashboardState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<DashboardState>, AsyncValue<DashboardState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<DashboardState>,
                AsyncValue<DashboardState>
              >,
              AsyncValue<DashboardState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
