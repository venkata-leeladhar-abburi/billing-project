import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/plan_type.dart';
import '../../../core/models/shop_model.dart';
import '../../salesperson/domain/salesperson_mock_shops.dart';
import 'admin_mock_salespersons.dart';

part 'revenue_notifier.g.dart';

enum RevenueRange { thisMonth, lastMonth, last3Months }

class RevenueState {
  const RevenueState({required this.shops, required this.salespersons, required this.range});

  final List<ShopModel> shops;
  final List<SalespersonModel> salespersons;
  final RevenueRange range;

  double get subscriptionRevenue => shops.where((s) => s.status != ShopStatus.suspended).fold(0.0, (sum, s) => sum + s.monthlyAmount);
  double get topupRevenue => 18400; // TODO: replace with real topup_orders aggregation when backend ready
  double get totalRevenue => subscriptionRevenue + topupRevenue;
  double get lastMonthMrr => subscriptionRevenue * 0.91; // TODO: replace with real historical MRR when backend ready
  double get mrrDiff => subscriptionRevenue - lastMonthMrr;
  double get mrrDiffPct => lastMonthMrr == 0 ? 0 : (mrrDiff / lastMonthMrr) * 100;

  int shopCountFor(SubscriptionPlan plan) => shops.where((s) => s.plan == plan).length;
  double revenueFor(SubscriptionPlan plan) => shops.where((s) => s.plan == plan && s.status != ShopStatus.suspended).fold(0.0, (sum, s) => sum + s.monthlyAmount);

  double get aisensyFee => 1500;
  double get metaMessageCost => shops.fold(0.0, (sum, s) => sum + s.billsSentThisMonth * 0.12);
  double get razorpayFees => totalRevenue * 0.02;
  double get estimatedTotalCost => aisensyFee + metaMessageCost + razorpayFees;
  double get netRevenue => totalRevenue - estimatedTotalCost;
  double get marginPct => totalRevenue == 0 ? 0 : (netRevenue / totalRevenue) * 100;

  List<ShopModel> get topShopsByValue {
    final sorted = List<ShopModel>.of(shops)..sort((a, b) => b.monthlyAmount.compareTo(a.monthlyAmount));
    return sorted;
  }

  List<SalespersonModel> get salespersonsByRevenue {
    final sorted = List<SalespersonModel>.of(salespersons)
      ..sort((a, b) => _revenueFor(b).compareTo(_revenueFor(a)));
    return sorted;
  }

  double _revenueFor(SalespersonModel person) => buildMockShopModelsFor(person.name).fold(0.0, (sum, s) => sum + s.monthlyAmount);

  double revenueForSalesperson(SalespersonModel person) => _revenueFor(person);
  int newShopsForSalesperson(SalespersonModel person) =>
      buildMockShopModelsFor(person.name).where((s) => s.addedDate != null && DateTime.now().difference(s.addedDate!).inDays <= 30).length;

  int get successfulAutopay => shops.where((s) => s.autopayStatus == AutoPayStatus.active).length;
  int get failedAutopay => shops.where((s) => s.autopayStatus == AutoPayStatus.failed).length;
}

@riverpod
class RevenueNotifier extends _$RevenueNotifier {
  @override
  AsyncValue<RevenueState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /admin/revenue call when backend ready
    state = AsyncValue.data(RevenueState(shops: buildMockShopModels(), salespersons: buildMockSalespersons(), range: RevenueRange.thisMonth));
  }

  void setRange(RevenueRange range) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(RevenueState(shops: current.shops, salespersons: current.salespersons, range: range));
  }
}
