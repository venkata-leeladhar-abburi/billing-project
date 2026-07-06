// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationsNotifier)
final notificationsProvider = NotificationsNotifierProvider._();

final class NotificationsNotifierProvider
    extends
        $NotifierProvider<
          NotificationsNotifier,
          AsyncValue<NotificationsState>
        > {
  NotificationsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsNotifierHash();

  @$internal
  @override
  NotificationsNotifier create() => NotificationsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<NotificationsState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<NotificationsState>>(
        value,
      ),
    );
  }
}

String _$notificationsNotifierHash() =>
    r'4395fe925ea32841c3a58125a7be1d9acfd44406';

abstract class _$NotificationsNotifier
    extends $Notifier<AsyncValue<NotificationsState>> {
  AsyncValue<NotificationsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<NotificationsState>,
              AsyncValue<NotificationsState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationsState>,
                AsyncValue<NotificationsState>
              >,
              AsyncValue<NotificationsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
