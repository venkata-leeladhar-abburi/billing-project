// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TemplateDetailNotifier)
final templateDetailProvider = TemplateDetailNotifierFamily._();

final class TemplateDetailNotifierProvider
    extends
        $NotifierProvider<TemplateDetailNotifier, AsyncValue<TemplateModel>> {
  TemplateDetailNotifierProvider._({
    required TemplateDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'templateDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$templateDetailNotifierHash();

  @override
  String toString() {
    return r'templateDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TemplateDetailNotifier create() => TemplateDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TemplateModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TemplateModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TemplateDetailNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$templateDetailNotifierHash() =>
    r'c13b68511ed2a1ecb1c8141a3258861ce04069fa';

final class TemplateDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          TemplateDetailNotifier,
          AsyncValue<TemplateModel>,
          AsyncValue<TemplateModel>,
          AsyncValue<TemplateModel>,
          String
        > {
  TemplateDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'templateDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TemplateDetailNotifierProvider call(String templateId) =>
      TemplateDetailNotifierProvider._(argument: templateId, from: this);

  @override
  String toString() => r'templateDetailProvider';
}

abstract class _$TemplateDetailNotifier
    extends $Notifier<AsyncValue<TemplateModel>> {
  late final _$args = ref.$arg as String;
  String get templateId => _$args;

  AsyncValue<TemplateModel> build(String templateId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<TemplateModel>, AsyncValue<TemplateModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TemplateModel>, AsyncValue<TemplateModel>>,
              AsyncValue<TemplateModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
