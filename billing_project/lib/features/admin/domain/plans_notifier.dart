import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/plan_type.dart';
import '../../salesperson/domain/salesperson_mock_shops.dart';

part 'plans_notifier.g.dart';

class TopupPackConfig {
  const TopupPackConfig({required this.name, required this.credits, required this.price});

  final String name;
  final int credits;
  final double price;

  double get costPerCredit => credits == 0 ? 0 : price / credits;

  TopupPackConfig copyWith({double? price}) => TopupPackConfig(name: name, credits: credits, price: price ?? this.price);
}

class PlanConfig {
  const PlanConfig({
    required this.plan,
    required this.price,
    required this.billCreditsLimit,
    required this.msgCreditsLimit,
    required this.customerLimit,
    required this.billHistoryMonths,
  });

  final SubscriptionPlan plan;
  final double price;
  final int billCreditsLimit;
  final int msgCreditsLimit;
  final int? customerLimit;
  final int? billHistoryMonths;

  PlanConfig copyWith({double? price, int? billCreditsLimit, int? msgCreditsLimit, int? customerLimit}) {
    return PlanConfig(
      plan: plan,
      price: price ?? this.price,
      billCreditsLimit: billCreditsLimit ?? this.billCreditsLimit,
      msgCreditsLimit: msgCreditsLimit ?? this.msgCreditsLimit,
      customerLimit: customerLimit ?? this.customerLimit,
      billHistoryMonths: billHistoryMonths,
    );
  }
}

class PlansState {
  const PlansState({required this.plans, required this.topupPacks, this.isEditMode = false, this.draftPlans, this.draftPacks});

  final List<PlanConfig> plans;
  final List<TopupPackConfig> topupPacks;
  final bool isEditMode;
  final List<PlanConfig>? draftPlans;
  final List<TopupPackConfig>? draftPacks;

  List<PlanConfig> get displayPlans => draftPlans ?? plans;
  List<TopupPackConfig> get displayPacks => draftPacks ?? topupPacks;

  int shopCountFor(SubscriptionPlan plan) => buildMockShopModels().where((s) => s.plan == plan).length;
}

@riverpod
class PlansNotifier extends _$PlansNotifier {
  @override
  AsyncValue<PlansState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /admin/plans call when backend ready
    state = AsyncValue.data(PlansState(
      plans: const [
        PlanConfig(plan: SubscriptionPlan.basic, price: 299, billCreditsLimit: 100, msgCreditsLimit: 300, customerLimit: 500, billHistoryMonths: 3),
        PlanConfig(plan: SubscriptionPlan.pro, price: 599, billCreditsLimit: 300, msgCreditsLimit: 800, customerLimit: 2000, billHistoryMonths: 12),
        PlanConfig(plan: SubscriptionPlan.business, price: 999, billCreditsLimit: 99999, msgCreditsLimit: 2000, customerLimit: null, billHistoryMonths: null),
      ],
      topupPacks: const [
        TopupPackConfig(name: 'Bill Starter', credits: 50, price: 149),
        TopupPackConfig(name: 'Bill Standard', credits: 150, price: 399),
        TopupPackConfig(name: 'Msg Starter', credits: 200, price: 199),
        TopupPackConfig(name: 'Msg Standard', credits: 500, price: 449),
        TopupPackConfig(name: 'Msg Bulk', credits: 1500, price: 1199),
      ],
    ));
  }

  void enterEditMode() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(PlansState(
      plans: current.plans,
      topupPacks: current.topupPacks,
      isEditMode: true,
      draftPlans: List.of(current.plans),
      draftPacks: List.of(current.topupPacks),
    ));
  }

  void updateDraftPlan(int index, PlanConfig updated) {
    final current = state.value;
    if (current?.draftPlans == null) return;
    final drafts = List<PlanConfig>.of(current!.draftPlans!);
    drafts[index] = updated;
    state = AsyncValue.data(PlansState(plans: current.plans, topupPacks: current.topupPacks, isEditMode: true, draftPlans: drafts, draftPacks: current.draftPacks));
  }

  void updateDraftPack(int index, TopupPackConfig updated) {
    final current = state.value;
    if (current?.draftPacks == null) return;
    final drafts = List<TopupPackConfig>.of(current!.draftPacks!);
    drafts[index] = updated;
    state = AsyncValue.data(PlansState(plans: current.plans, topupPacks: current.topupPacks, isEditMode: true, draftPlans: current.draftPlans, draftPacks: drafts));
  }

  void cancelEdit() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(PlansState(plans: current.plans, topupPacks: current.topupPacks));
  }

  Future<void> savePlans() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real PUT /admin/plans call when backend ready
    state = AsyncValue.data(PlansState(
      plans: current.draftPlans ?? current.plans,
      topupPacks: current.draftPacks ?? current.topupPacks,
    ));
  }
}
