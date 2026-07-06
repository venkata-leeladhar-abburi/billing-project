import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'admin_mock_salespersons.dart';

part 'salesperson_list_notifier.g.dart';

class AdminSalespersonListState {
  const AdminSalespersonListState({required this.salespersons});

  final List<SalespersonModel> salespersons;

  int get totalShopsManaged => salespersons.fold(0, (sum, s) => sum + shopCountFor(s.name));
}

@riverpod
class SalespersonListNotifier extends _$SalespersonListNotifier {
  @override
  AsyncValue<AdminSalespersonListState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /admin/salespersons call when backend ready
    state = AsyncValue.data(AdminSalespersonListState(salespersons: buildMockSalespersons()));
  }
}
