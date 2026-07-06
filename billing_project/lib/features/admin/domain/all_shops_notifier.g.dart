// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_shops_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AllShopsNotifier)
final allShopsProvider = AllShopsNotifierProvider._();

final class AllShopsNotifierProvider
    extends $NotifierProvider<AllShopsNotifier, AsyncValue<AllShopsState>> {
  AllShopsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allShopsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allShopsNotifierHash();

  @$internal
  @override
  AllShopsNotifier create() => AllShopsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AllShopsState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AllShopsState>>(value),
    );
  }
}

String _$allShopsNotifierHash() => r'e6b2ec2c1b5230f449abc1cca4141cadd6473259';

abstract class _$AllShopsNotifier extends $Notifier<AsyncValue<AllShopsState>> {
  AsyncValue<AllShopsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AllShopsState>, AsyncValue<AllShopsState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AllShopsState>, AsyncValue<AllShopsState>>,
              AsyncValue<AllShopsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
