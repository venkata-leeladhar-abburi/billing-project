import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/bill_model.dart';

part 'bill_history_notifier.g.dart';

class BillHistoryState {
  const BillHistoryState({required this.bills});

  final List<BillModel> bills;
}

@riverpod
class BillHistoryNotifier extends _$BillHistoryNotifier {
  @override
  AsyncValue<BillHistoryState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    // TODO: replace with real billingRepository.getBillHistory() call when backend ready
    await Future.delayed(const Duration(milliseconds: 600));
    final now = DateTime.now();
    state = AsyncValue.data(
      BillHistoryState(
        bills: [
          BillModel(
            id: 'b1',
            billNumber: 'BILL-2026-0042',
            customerName: 'Suresh Kumar',
            total: 2992.50,
            status: BillStatus.sent,
            sentAgo: '2 min ago',
            sentAt: now.subtract(const Duration(minutes: 2)),
            customerId: 'c1',
          ),
          BillModel(
            id: 'b2',
            billNumber: 'BILL-2026-0041',
            customerName: 'Ramesh Reddy',
            total: 1450.00,
            status: BillStatus.sent,
            sentAgo: '1 hr ago',
            sentAt: now.subtract(const Duration(hours: 1)),
            customerId: 'c2',
          ),
          BillModel(
            id: 'b3',
            billNumber: 'BILL-2026-0040',
            customerName: 'Venkat Rao',
            total: 8200.00,
            status: BillStatus.sent,
            sentAgo: '3 hrs ago',
            sentAt: now.subtract(const Duration(hours: 3)),
            customerId: 'c3',
          ),
          BillModel(
            id: 'b4',
            billNumber: 'BILL-2026-0039',
            customerName: 'Lakshmi Devi',
            total: 3600.00,
            status: BillStatus.failed,
            sentAgo: '5 hrs ago',
            sentAt: now.subtract(const Duration(hours: 5)),
            customerId: 'c4',
          ),
          BillModel(
            id: 'b5',
            billNumber: 'BILL-2026-0038',
            customerName: 'Prasad Sharma',
            total: 2400.00,
            status: BillStatus.sent,
            sentAgo: 'Yesterday',
            sentAt: now.subtract(const Duration(days: 1)),
            customerId: 'c5',
          ),
          BillModel(
            id: 'b9',
            billNumber: 'BILL-2026-0031',
            customerName: 'Suresh Kumar',
            total: 4500.00,
            status: BillStatus.sent,
            sentAgo: '2 weeks ago',
            sentAt: now.subtract(const Duration(days: 14)),
            customerId: 'c1',
          ),
          BillModel(
            id: 'b12',
            billNumber: 'BILL-2026-0018',
            customerName: 'Suresh Kumar',
            total: 1800.00,
            status: BillStatus.failed,
            sentAgo: '1 month ago',
            sentAt: now.subtract(const Duration(days: 32)),
            customerId: 'c1',
          ),
        ],
      ),
    );
  }
}
