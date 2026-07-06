// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'templates_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TemplatesNotifier)
final templatesProvider = TemplatesNotifierProvider._();

final class TemplatesNotifierProvider
    extends $NotifierProvider<TemplatesNotifier, AsyncValue<TemplatesState>> {
  TemplatesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templatesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templatesNotifierHash();

  @$internal
  @override
  TemplatesNotifier create() => TemplatesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TemplatesState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TemplatesState>>(value),
    );
  }
}

String _$templatesNotifierHash() => r'96b351efda3b4f7dd16d65f6dfcaceef23e21287';

abstract class _$TemplatesNotifier
    extends $Notifier<AsyncValue<TemplatesState>> {
  AsyncValue<TemplatesState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<TemplatesState>, AsyncValue<TemplatesState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<TemplatesState>,
                AsyncValue<TemplatesState>
              >,
              AsyncValue<TemplatesState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
