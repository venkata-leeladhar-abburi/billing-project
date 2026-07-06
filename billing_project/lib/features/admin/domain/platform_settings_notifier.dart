import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'platform_settings_notifier.g.dart';

enum ConnectionTestState { idle, testing, success, failed }

class PlatformSettingsState {
  const PlatformSettingsState({
    this.aisensyConnected = true,
    this.aisensyApiKeyLast4 = '8f2a',
    this.campaignPrefix = 'building_project_',
    this.whatsappNumber = '+91 98765 00000',
    this.razorpayConnected = true,
    this.razorpayKeyId = 'rzp_test_1a2b3c4d5e',
    this.isLiveMode = false,
    this.notifyOnCancellation = true,
    this.notifyOnAutopayFailure = true,
    this.notifySalespersonOnCancellation = true,
    this.notifyShopkeeperBeforeAutopay = true,
    this.notifyShopkeeperOnLowCredit = true,
    this.criticalAlertNumber = '+91 98765 00001',
    this.isSaving = false,
    this.aisensyTestState = ConnectionTestState.idle,
    this.razorpayTestState = ConnectionTestState.idle,
    this.lastTemplateSync,
  });

  final bool aisensyConnected;
  final String aisensyApiKeyLast4;
  final String campaignPrefix;
  final String whatsappNumber;
  final bool razorpayConnected;
  final String razorpayKeyId;
  final bool isLiveMode;
  final bool notifyOnCancellation;
  final bool notifyOnAutopayFailure;
  final bool notifySalespersonOnCancellation;
  final bool notifyShopkeeperBeforeAutopay;
  final bool notifyShopkeeperOnLowCredit;
  final String criticalAlertNumber;
  final bool isSaving;
  final ConnectionTestState aisensyTestState;
  final ConnectionTestState razorpayTestState;
  final DateTime? lastTemplateSync;

  PlatformSettingsState copyWith({
    String? campaignPrefix,
    bool? isLiveMode,
    bool? notifyOnCancellation,
    bool? notifyOnAutopayFailure,
    bool? notifySalespersonOnCancellation,
    bool? notifyShopkeeperBeforeAutopay,
    bool? notifyShopkeeperOnLowCredit,
    String? criticalAlertNumber,
    bool? isSaving,
    ConnectionTestState? aisensyTestState,
    ConnectionTestState? razorpayTestState,
    DateTime? lastTemplateSync,
  }) {
    return PlatformSettingsState(
      aisensyConnected: aisensyConnected,
      aisensyApiKeyLast4: aisensyApiKeyLast4,
      campaignPrefix: campaignPrefix ?? this.campaignPrefix,
      whatsappNumber: whatsappNumber,
      razorpayConnected: razorpayConnected,
      razorpayKeyId: razorpayKeyId,
      isLiveMode: isLiveMode ?? this.isLiveMode,
      notifyOnCancellation: notifyOnCancellation ?? this.notifyOnCancellation,
      notifyOnAutopayFailure: notifyOnAutopayFailure ?? this.notifyOnAutopayFailure,
      notifySalespersonOnCancellation: notifySalespersonOnCancellation ?? this.notifySalespersonOnCancellation,
      notifyShopkeeperBeforeAutopay: notifyShopkeeperBeforeAutopay ?? this.notifyShopkeeperBeforeAutopay,
      notifyShopkeeperOnLowCredit: notifyShopkeeperOnLowCredit ?? this.notifyShopkeeperOnLowCredit,
      criticalAlertNumber: criticalAlertNumber ?? this.criticalAlertNumber,
      isSaving: isSaving ?? this.isSaving,
      aisensyTestState: aisensyTestState ?? this.aisensyTestState,
      razorpayTestState: razorpayTestState ?? this.razorpayTestState,
      lastTemplateSync: lastTemplateSync ?? this.lastTemplateSync,
    );
  }
}

@riverpod
class PlatformSettingsNotifier extends _$PlatformSettingsNotifier {
  @override
  AsyncValue<PlatformSettingsState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /admin/platform-settings call when backend ready
    state = AsyncValue.data(PlatformSettingsState(lastTemplateSync: DateTime.now().subtract(const Duration(hours: 3))));
  }

  void updateField({String? campaignPrefix, String? criticalAlertNumber}) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(campaignPrefix: campaignPrefix, criticalAlertNumber: criticalAlertNumber));
  }

  void toggleLiveMode(bool value) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(isLiveMode: value));
  }

  void toggleNotification(String key, bool value) {
    final current = state.value;
    if (current == null) return;
    switch (key) {
      case 'cancellation':
        state = AsyncValue.data(current.copyWith(notifyOnCancellation: value));
      case 'autopayFailure':
        state = AsyncValue.data(current.copyWith(notifyOnAutopayFailure: value));
      case 'salespersonCancellation':
        state = AsyncValue.data(current.copyWith(notifySalespersonOnCancellation: value));
      case 'beforeAutopay':
        state = AsyncValue.data(current.copyWith(notifyShopkeeperBeforeAutopay: value));
      case 'lowCredit':
        state = AsyncValue.data(current.copyWith(notifyShopkeeperOnLowCredit: value));
    }
  }

  Future<void> testAiSensy() async {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(aisensyTestState: ConnectionTestState.testing));
    await Future.delayed(const Duration(milliseconds: 900));
    // TODO: replace with real AiSensy ping call when backend ready
    state = AsyncValue.data(state.value!.copyWith(aisensyTestState: ConnectionTestState.success));
  }

  Future<void> testRazorpay() async {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(razorpayTestState: ConnectionTestState.testing));
    await Future.delayed(const Duration(milliseconds: 900));
    // TODO: replace with real Razorpay ping call when backend ready
    state = AsyncValue.data(state.value!.copyWith(razorpayTestState: ConnectionTestState.success));
  }

  Future<bool> saveAll() async {
    final current = state.value;
    if (current == null) return false;
    state = AsyncValue.data(current.copyWith(isSaving: true));
    await Future.delayed(const Duration(milliseconds: 700));
    // TODO: replace with real PUT /admin/platform-settings call when backend ready
    state = AsyncValue.data(state.value!.copyWith(isSaving: false));
    return true;
  }

  Future<void> syncTemplates() async {
    final current = state.value;
    if (current == null) return;
    await Future.delayed(const Duration(milliseconds: 700));
    // TODO: replace with real AiSensy template sync call when backend ready
    state = AsyncValue.data(current.copyWith(lastTemplateSync: DateTime.now()));
  }

  Future<void> clearCaches() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: replace with real Isar cache-clear call when backend ready
  }
}
