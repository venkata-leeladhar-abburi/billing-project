import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/mock/mock_fixtures.dart';

part 'settings_notifier.g.dart';

class SettingsState {
  const SettingsState({
    required this.shopName,
    required this.ownerName,
    required this.phone,
    required this.businessType,
    required this.plan,
    required this.gstRate,
  });

  final String shopName;
  final String ownerName;
  final String phone;
  final String businessType;
  final String plan;
  final double gstRate;

  SettingsState copyWith({double? gstRate}) {
    return SettingsState(
      shopName: shopName,
      ownerName: ownerName,
      phone: phone,
      businessType: businessType,
      plan: plan,
      gstRate: gstRate ?? this.gstRate,
    );
  }
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  AsyncValue<SettingsState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    // TODO: replace with real settingsRepository call when backend ready
    await Future.delayed(const Duration(milliseconds: 600));
    state = const AsyncValue.data(
      SettingsState(
        shopName: MockFixtures.shopName,
        ownerName: MockFixtures.ownerName,
        phone: MockFixtures.shopPhone,
        businessType: 'Clothing',
        plan: MockFixtures.plan,
        gstRate: 0.05,
      ),
    );
  }

  void setGstRate(double rate) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(gstRate: rate));
  }
}
