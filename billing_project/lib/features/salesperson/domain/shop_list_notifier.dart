import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/shop_model.dart';
import 'salesperson_mock_shops.dart';

part 'shop_list_notifier.g.dart';

class ShopListState {
  const ShopListState({required this.shops});

  final List<ShopModel> shops;
}

@riverpod
class ShopListNotifier extends _$ShopListNotifier {
  @override
  AsyncValue<ShopListState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    // TODO: replace with real shopRepository call when backend ready
    await Future.delayed(const Duration(milliseconds: 600));
    state = AsyncValue.data(ShopListState(shops: buildMockShopModelsFor('Venkatesh Naidu')));
  }
}
