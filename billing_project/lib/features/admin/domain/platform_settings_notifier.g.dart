// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_settings_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlatformSettingsNotifier)
final platformSettingsProvider = PlatformSettingsNotifierProvider._();

final class PlatformSettingsNotifierProvider
    extends
        $NotifierProvider<
          PlatformSettingsNotifier,
          AsyncValue<PlatformSettingsState>
        > {
  PlatformSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'platformSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$platformSettingsNotifierHash();

  @$internal
  @override
  PlatformSettingsNotifier create() => PlatformSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<PlatformSettingsState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<PlatformSettingsState>>(
        value,
      ),
    );
  }
}

String _$platformSettingsNotifierHash() =>
    r'd3b0ec1cd0d49acf1850ef3fa63ab10688764895';

abstract class _$PlatformSettingsNotifier
    extends $Notifier<AsyncValue<PlatformSettingsState>> {
  AsyncValue<PlatformSettingsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PlatformSettingsState>,
              AsyncValue<PlatformSettingsState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PlatformSettingsState>,
                AsyncValue<PlatformSettingsState>
              >,
              AsyncValue<PlatformSettingsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
