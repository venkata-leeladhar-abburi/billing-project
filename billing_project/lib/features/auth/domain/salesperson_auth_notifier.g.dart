// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salesperson_auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalespersonAuthNotifier)
final salespersonAuthProvider = SalespersonAuthNotifierProvider._();

final class SalespersonAuthNotifierProvider
    extends $NotifierProvider<SalespersonAuthNotifier, AsyncValue<String>> {
  SalespersonAuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salespersonAuthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salespersonAuthNotifierHash();

  @$internal
  @override
  SalespersonAuthNotifier create() => SalespersonAuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<String>>(value),
    );
  }
}

String _$salespersonAuthNotifierHash() =>
    r'c5a3f83182e8344227a530594ea11c184d811ef0';

abstract class _$SalespersonAuthNotifier extends $Notifier<AsyncValue<String>> {
  AsyncValue<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, AsyncValue<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, AsyncValue<String>>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
