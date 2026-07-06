import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/shop_model.dart';
import 'salesperson_mock_shops.dart';

part 'shop_detail_notifier.g.dart';

@riverpod
class ShopDetailNotifier extends _$ShopDetailNotifier {
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

  Future<void> suspendShop() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real POST /shops/:shopId/suspend call when backend ready
    state = AsyncValue.data(current.copyWith(status: ShopStatus.suspended));
  }
}
