import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/shop_model.dart';
import 'salesperson_mock_shops.dart';

part 'salesperson_dashboard_notifier.g.dart';

class SalespersonDashboardState {
  const SalespersonDashboardState({
    required this.salespersonName,
    required this.shops,
    required this.pendingCancellations,
  });

  final String salespersonName;
  final List<ShopModel> shops;
  final int pendingCancellations;

  int get totalShops => shops.length;
  int get activeToday =>
      shops.where((s) => s.lastActiveAt != null && DateTime.now().difference(s.lastActiveAt!).inHours < 24).length;
  int get newThisMonth => shops.where((s) => s.addedDate != null && DateTime.now().difference(s.addedDate!).inDays <= 30).length;
  int get pendingSetup => shops.where((s) => s.status == ShopStatus.pendingSetup).length;
}

@riverpod
class SalespersonDashboardNotifier extends _$SalespersonDashboardNotifier {
  @override
  AsyncValue<SalespersonDashboardState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    // TODO: replace with real salespersonRepository call when backend ready
    await Future.delayed(const Duration(milliseconds: 600));
    state = AsyncValue.data(
      SalespersonDashboardState(
        salespersonName: 'Venkatesh Naidu',
        shops: buildMockShopModelsFor('Venkatesh Naidu'),
        pendingCancellations: 1,
      ),
    );
  }
}
