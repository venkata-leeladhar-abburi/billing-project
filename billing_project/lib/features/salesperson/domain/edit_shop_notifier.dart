import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/plan_type.dart';
import '../../../core/models/shop_model.dart';
import 'salesperson_mock_shops.dart';

part 'edit_shop_notifier.g.dart';

@riverpod
class EditShopNotifier extends _$EditShopNotifier {
  @override
  AsyncValue<ShopModel> build(String shopId) {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /shops/:shopId call when backend ready
    final shops = buildMockShopModels();
    final shop = shops.firstWhere((s) => s.id == shopId, orElse: () => shops.first);
    state = AsyncValue.data(shop);
  }

  void updateField({
    String? shopName,
    String? ownerName,
    String? phone,
    String? whatsappNumber,
    String? address,
    String? city,
    String? stateName,
    String? pinCode,
    String? gstNumber,
    String? businessType,
  }) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(
      shopName: shopName,
      ownerName: ownerName,
      phone: phone,
      whatsappNumber: whatsappNumber,
      address: address,
      city: city,
      state: stateName,
      pinCode: pinCode,
      gstNumber: gstNumber,
      businessType: businessType,
    ));
  }

  void changePlan(SubscriptionPlan plan) {
    final current = state.value;
    if (current == null) return;
    final amount = switch (plan) {
      SubscriptionPlan.basic => 299.0,
      SubscriptionPlan.pro => 599.0,
      SubscriptionPlan.business => 999.0,
    };
    state = AsyncValue.data(current.copyWith(plan: plan, monthlyAmount: amount));
  }

  Future<bool> save() async {
    final current = state.value;
    if (current == null) return false;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 700));
    // TODO: replace with real PATCH /shops/:shopId call when backend ready
    state = AsyncValue.data(current);
    return true;
  }
}
