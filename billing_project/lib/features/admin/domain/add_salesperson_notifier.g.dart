// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_salesperson_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddSalespersonNotifier)
final addSalespersonProvider = AddSalespersonNotifierProvider._();

final class AddSalespersonNotifierProvider
    extends $NotifierProvider<AddSalespersonNotifier, AddSalespersonState> {
  AddSalespersonNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addSalespersonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addSalespersonNotifierHash();

  @$internal
  @override
  AddSalespersonNotifier create() => AddSalespersonNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddSalespersonState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddSalespersonState>(value),
    );
  }
}

String _$addSalespersonNotifierHash() =>
    r'e5d7358be6b633926cf5d82236f6aafe17192a09';

abstract class _$AddSalespersonNotifier extends $Notifier<AddSalespersonState> {
  AddSalespersonState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AddSalespersonState, AddSalespersonState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddSalespersonState, AddSalespersonState>,
              AddSalespersonState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
