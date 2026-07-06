import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/bill_model.dart';

part 'bill_detail_notifier.g.dart';

class BillDetailItem {
  const BillDetailItem({
    required this.name,
    required this.qty,
    required this.rate,
  });

  final String name;
  final int qty;
  final double rate;

  double get amount => qty * rate;
}

class BillDetailState {
  const BillDetailState({
    required this.bill,
    required this.customerPhone,
    required this.items,
    this.isResending = false,
    this.deliveredAt,
  });

  final BillModel bill;
  final String customerPhone;
  final List<BillDetailItem> items;
  final bool isResending;
  final DateTime? deliveredAt;

  double get subtotal => items.fold(0, (sum, item) => sum + item.amount);
  double get gst => subtotal * 0.05;
  double get total => subtotal + gst;

  BillDetailState copyWith({bool? isResending}) {
    return BillDetailState(
      bill: bill,
      customerPhone: customerPhone,
      items: items,
      isResending: isResending ?? this.isResending,
      deliveredAt: deliveredAt,
    );
  }
}

@riverpod
class BillDetailNotifier extends _$BillDetailNotifier {
  @override
  AsyncValue<BillDetailState> build(String billId) {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    // TODO: replace with real billingRepository.getBill(billId) call when backend ready
    await Future.delayed(const Duration(milliseconds: 600));
    final now = DateTime.now();
    state = AsyncValue.data(
      BillDetailState(
        bill: BillModel(
          id: billId,
          billNumber: 'BILL-2026-0042',
          customerName: 'Suresh Kumar',
          total: 2992.50,
          status: BillStatus.sent,
          sentAgo: '2 min ago',
          sentAt: now.subtract(const Duration(minutes: 2)),
          customerId: 'c1',
        ),
        customerPhone: '+919876543210',
        deliveredAt: now.subtract(const Duration(minutes: 1)),
        items: const [
          BillDetailItem(name: 'Silk Saree', qty: 2, rate: 1250),
          BillDetailItem(name: 'Cotton Kurti', qty: 1, rate: 492.5),
        ],
      ),
    );
  }

  Future<void> resend() async {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(isResending: true));
    // TODO: replace with real POST /bills/:billId/resend call when backend ready
    await Future.delayed(const Duration(milliseconds: 800));
    state = AsyncValue.data(current.copyWith(isResending: false));
  }
}
