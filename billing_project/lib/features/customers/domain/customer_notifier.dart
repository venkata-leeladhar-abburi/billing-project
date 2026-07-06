import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/customer_model.dart';

part 'customer_notifier.g.dart';

class CustomerListState {
  const CustomerListState({required this.customers});

  final List<CustomerModel> customers;
}

@riverpod
class CustomerNotifier extends _$CustomerNotifier {
  @override
  AsyncValue<CustomerListState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    // TODO: replace with real customerRepository call when backend ready
    await Future.delayed(const Duration(milliseconds: 600));
    final now = DateTime.now();
    state = AsyncValue.data(
      CustomerListState(
        customers: [
          CustomerModel(
            id: 'c1',
            name: 'Suresh Kumar',
            phone: '+919876543210',
            billCount: 8,
            totalBilled: 24800,
            lastBilledAt: now.subtract(const Duration(days: 2)),
            addedAt: now.subtract(const Duration(days: 120)),
          ),
          CustomerModel(
            id: 'c2',
            name: 'Ramesh Reddy',
            phone: '+919876543211',
            billCount: 3,
            totalBilled: 8600,
            lastBilledAt: now.subtract(const Duration(days: 20)),
            addedAt: now.subtract(const Duration(days: 15)),
          ),
          CustomerModel(
            id: 'c3',
            name: 'Venkat Rao',
            phone: '+919876543212',
            billCount: 12,
            totalBilled: 36200,
            lastBilledAt: now.subtract(const Duration(days: 1)),
            addedAt: now.subtract(const Duration(days: 200)),
          ),
          CustomerModel(
            id: 'c4',
            name: 'Lakshmi Devi',
            phone: '+919876543213',
            billCount: 5,
            totalBilled: 14500,
            lastBilledAt: now.subtract(const Duration(days: 40)),
            addedAt: now.subtract(const Duration(days: 60)),
          ),
          CustomerModel(
            id: 'c5',
            name: 'Prasad Sharma',
            phone: '+919876543214',
            billCount: 1,
            totalBilled: 2400,
            lastBilledAt: now.subtract(const Duration(days: 5)),
            addedAt: now.subtract(const Duration(days: 3)),
          ),
        ],
      ),
    );
  }
}
