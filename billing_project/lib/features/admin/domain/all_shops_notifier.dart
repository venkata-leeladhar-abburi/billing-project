import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/shop_model.dart';
import '../../salesperson/domain/salesperson_mock_shops.dart';

part 'all_shops_notifier.g.dart';

class AllShopsState {
  const AllShopsState({required this.shops});

  final List<ShopModel> shops;

  double get mrr => shops.where((s) => s.status != ShopStatus.suspended).fold(0.0, (sum, s) => sum + s.monthlyAmount);
  int get activeCount => shops.where((s) => s.status == ShopStatus.active).length;
}

@riverpod
class AllShopsNotifier extends _$AllShopsNotifier {
  @override
  AsyncValue<AllShopsState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /admin/shops call when backend ready
    state = AsyncValue.data(AllShopsState(shops: buildMockShopModels()));
  }
}
