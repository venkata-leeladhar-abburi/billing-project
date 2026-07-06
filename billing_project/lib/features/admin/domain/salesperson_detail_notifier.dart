import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/shop_model.dart';
import '../../salesperson/domain/salesperson_mock_shops.dart';
import 'admin_mock_salespersons.dart';

part 'salesperson_detail_notifier.g.dart';

class SalespersonDetailState {
  const SalespersonDetailState({required this.salesperson, required this.shops});

  final SalespersonModel salesperson;
  final List<ShopModel> shops;

  double get revenueGenerated => shops.fold(0.0, (sum, s) => sum + s.monthlyAmount);
  int get activeShops => shops.where((s) => s.status == ShopStatus.active).length;
  int get newThisMonth => shops.where((s) => s.addedDate != null && DateTime.now().difference(s.addedDate!).inDays <= 30).length;
}

@riverpod
class SalespersonDetailNotifier extends _$SalespersonDetailNotifier {
  @override
  AsyncValue<SalespersonDetailState> build(String salespersonId) {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /admin/salespersons/:id call when backend ready
    final people = buildMockSalespersons();
    final person = people.firstWhere((p) => p.id == salespersonId, orElse: () => people.first);
    state = AsyncValue.data(SalespersonDetailState(
      salesperson: person,
      shops: buildMockShopModelsFor(person.name),
    ));
  }

  Future<void> deactivate() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real POST /admin/salespersons/:id/deactivate call when backend ready
    state = AsyncValue.data(SalespersonDetailState(salesperson: current.salesperson.copyWith(isActive: false), shops: current.shops));
  }

  Future<void> reactivate() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real POST /admin/salespersons/:id/reactivate call when backend ready
    state = AsyncValue.data(SalespersonDetailState(salesperson: current.salesperson.copyWith(isActive: true), shops: current.shops));
  }
}
