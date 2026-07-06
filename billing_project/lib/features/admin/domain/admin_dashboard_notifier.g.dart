// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminDashboardNotifier)
final adminDashboardProvider = AdminDashboardNotifierProvider._();

final class AdminDashboardNotifierProvider
    extends
        $NotifierProvider<
          AdminDashboardNotifier,
          AsyncValue<AdminDashboardState>
        > {
  AdminDashboardNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminDashboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminDashboardNotifierHash();

  @$internal
  @override
  AdminDashboardNotifier create() => AdminDashboardNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AdminDashboardState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AdminDashboardState>>(
        value,
      ),
    );
  }
}

String _$adminDashboardNotifierHash() =>
    r'8824d2cd6cfb717cb59d2eaab46ae3b16aaaba6c';

abstract class _$AdminDashboardNotifier
    extends $Notifier<AsyncValue<AdminDashboardState>> {
  AsyncValue<AdminDashboardState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<AdminDashboardState>,
              AsyncValue<AdminDashboardState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AdminDashboardState>,
                AsyncValue<AdminDashboardState>
              >,
              AsyncValue<AdminDashboardState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
