import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/plan_type.dart';
import '../../../core/models/shop_model.dart';
import '../../salesperson/domain/salesperson_mock_shops.dart';

part 'admin_shop_detail_notifier.g.dart';

@riverpod
class AdminShopDetailNotifier extends _$AdminShopDetailNotifier {
  @override
  AsyncValue<ShopModel> build(String shopId) {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /admin/shops/:shopId call when backend ready
    final shops = buildMockShopModels();
    final shop = shops.firstWhere((s) => s.id == shopId, orElse: () => shops.first);
    state = AsyncValue.data(shop);
  }

  Future<void> changePlan(SubscriptionPlan plan) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: replace with real PATCH /admin/shops/:shopId/plan call when backend ready
    final amount = switch (plan) {
      SubscriptionPlan.basic => 299.0,
      SubscriptionPlan.pro => 599.0,
      SubscriptionPlan.business => 999.0,
    };
    state = AsyncValue.data(current.copyWith(plan: plan, monthlyAmount: amount));
  }

  Future<void> addCredits({required bool isBillCredits, required int amount}) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: replace with real POST /admin/shops/:shopId/credits/add call when backend ready
    state = AsyncValue.data(isBillCredits
        ? current.copyWith(billCreditsLimit: current.billCreditsLimit + amount)
        : current.copyWith(msgCreditsLimit: current.msgCreditsLimit + amount));
  }

  Future<void> reassignSalesperson(String salespersonName) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: replace with real PATCH /admin/shops/:shopId/reassign call when backend ready
    state = AsyncValue.data(current.copyWith(salespersonName: salespersonName));
  }

  Future<void> suspend() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: replace with real POST /admin/shops/:shopId/suspend call when backend ready
    state = AsyncValue.data(current.copyWith(status: ShopStatus.suspended));
  }

  Future<void> reactivate() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: replace with real POST /admin/shops/:shopId/reactivate call when backend ready
    state = AsyncValue.data(current.copyWith(status: ShopStatus.active));
  }

  Future<bool> delete() async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real DELETE /admin/shops/:shopId call when backend ready
    return true;
  }
}
