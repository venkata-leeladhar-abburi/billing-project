import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/customer_model.dart';

part 'customer_detail_notifier.g.dart';

class CustomerBillSummary {
  const CustomerBillSummary({
    required this.billId,
    required this.billNumber,
    required this.total,
    required this.status,
    required this.sentAgo,
  });

  final String billId;
  final String billNumber;
  final double total;
  final String status;
  final String sentAgo;
}

class CustomerDetailState {
  const CustomerDetailState({
    required this.customer,
    required this.businessType,
    required this.bills,
    this.note,
  });

  final CustomerModel customer;
  final String businessType;
  final List<CustomerBillSummary> bills;
  final String? note;

  CustomerDetailState copyWith({
    CustomerModel? customer,
    String? note,
  }) {
    return CustomerDetailState(
      customer: customer ?? this.customer,
      businessType: businessType,
      bills: bills,
      note: note ?? this.note,
    );
  }
}

@riverpod
class CustomerDetailNotifier extends _$CustomerDetailNotifier {
  @override
  AsyncValue<CustomerDetailState> build(String customerId) {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    // TODO: replace with real customerRepository.getCustomer(customerId) call when backend ready
    await Future.delayed(const Duration(milliseconds: 600));
    final now = DateTime.now();

    state = AsyncValue.data(
      CustomerDetailState(
        customer: CustomerModel(
          id: customerId,
          name: 'Suresh Kumar',
          phone: '+919876543210',
          billCount: 8,
          totalBilled: 24800,
          lastBilledAt: now.subtract(const Duration(days: 2)),
          addedAt: now.subtract(const Duration(days: 120)),
        ),
        businessType: 'Clothing',
        note: 'Prefers WhatsApp updates in the evening.',
        bills: const [
          CustomerBillSummary(
            billId: 'b1',
            billNumber: 'BILL-2026-0042',
            total: 2992.50,
            status: 'sent',
            sentAgo: '2 min ago',
          ),
          CustomerBillSummary(
            billId: 'b9',
            billNumber: 'BILL-2026-0031',
            total: 4500.00,
            status: 'sent',
            sentAgo: '2 weeks ago',
          ),
          CustomerBillSummary(
            billId: 'b12',
            billNumber: 'BILL-2026-0018',
            total: 1800.00,
            status: 'failed',
            sentAgo: '1 month ago',
          ),
        ],
      ),
    );
  }

  void updateNote(String note) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(note: note));
  }
}
