import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/mock/mock_fixtures.dart';

part 'new_bill_notifier.g.dart';

class NewBillItem {
  const NewBillItem({
    required this.id,
    this.name = '',
    this.qty = 1,
    this.rate = 0,
  });

  final String id;
  final String name;
  final int qty;
  final double rate;

  double get amount => qty * rate;

  bool get isValid => name.trim().isNotEmpty && qty > 0 && rate > 0;

  NewBillItem copyWith({String? name, int? qty, double? rate}) {
    return NewBillItem(
      id: id,
      name: name ?? this.name,
      qty: qty ?? this.qty,
      rate: rate ?? this.rate,
    );
  }
}

class NewBillState {
  const NewBillState({
    required this.customers,
    required this.billNumber,
    this.selectedCustomer,
    this.items = const [],
    this.notes = '',
    this.gstRate = 0.05,
    this.isSubmitting = false,
    this.isSent = false,
    this.sentAt,
  });

  final List<MockCustomer> customers;
  final String billNumber;
  final MockCustomer? selectedCustomer;
  final List<NewBillItem> items;
  final String notes;
  final double gstRate;
  final bool isSubmitting;
  final bool isSent;
  final DateTime? sentAt;

  double get subtotal => items.fold(0, (sum, item) => sum + item.amount);
  double get gst => subtotal * gstRate;
  double get total => subtotal + gst;

  bool get canSubmit =>
      selectedCustomer != null &&
      items.isNotEmpty &&
      items.every((item) => item.isValid);

  NewBillState copyWith({
    MockCustomer? selectedCustomer,
    bool clearCustomer = false,
    List<NewBillItem>? items,
    String? notes,
    bool? isSubmitting,
    bool? isSent,
    DateTime? sentAt,
  }) {
    return NewBillState(
      customers: customers,
      billNumber: billNumber,
      selectedCustomer: clearCustomer
          ? null
          : (selectedCustomer ?? this.selectedCustomer),
      items: items ?? this.items,
      notes: notes ?? this.notes,
      gstRate: gstRate,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSent: isSent ?? this.isSent,
      sentAt: sentAt ?? this.sentAt,
    );
  }
}

int _itemCounter = 0;

@riverpod
class NewBillNotifier extends _$NewBillNotifier {
  @override
  AsyncValue<NewBillState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    // TODO: replace with real customerRepository call when backend ready
    await Future.delayed(const Duration(milliseconds: 600));
    state = AsyncValue.data(
      NewBillState(
        customers: MockFixtures.customers,
        billNumber: _generateBillNumber(),
        items: [NewBillItem(id: _nextItemId())],
      ),
    );
  }

  String _nextItemId() => 'item_${_itemCounter++}';

  String _generateBillNumber() {
    final n = DateTime.now().millisecondsSinceEpoch % 9000 + 1000;
    return 'BILL-2026-$n';
  }

  void selectCustomer(MockCustomer customer) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(selectedCustomer: customer));
  }

  void clearCustomer() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(clearCustomer: true));
  }

  void addNewCustomerMock(String name) {
    final current = state.value;
    if (current == null) return;
    final newCustomer = MockCustomer(
      'new_${DateTime.now().millisecondsSinceEpoch}',
      name,
      '',
      0,
      0,
    );
    state = AsyncValue.data(
      current.copyWith(
        selectedCustomer: newCustomer,
      ),
    );
  }

  void addItem() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(
        items: [...current.items, NewBillItem(id: _nextItemId())],
      ),
    );
  }

  void updateItem(int index, {String? name, int? qty, double? rate}) {
    final current = state.value;
    if (current == null) return;
    final items = [...current.items];
    items[index] = items[index].copyWith(name: name, qty: qty, rate: rate);
    state = AsyncValue.data(current.copyWith(items: items));
  }

  void updateNotes(String notes) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(notes: notes));
  }

  Future<void> sendBill() async {
    final current = state.value;
    if (current == null || !current.canSubmit) return;

    state = AsyncValue.data(current.copyWith(isSubmitting: true));
    // TODO: replace with real billingRepository.sendBill() call when backend ready
    await Future.delayed(const Duration(milliseconds: 800));
    state = AsyncValue.data(
      current.copyWith(isSubmitting: false, isSent: true, sentAt: DateTime.now()),
    );
  }

  /// Clears the current draft and starts a fresh bill (e.g. "Send Another Bill").
  void reset() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      NewBillState(
        customers: current.customers,
        billNumber: _generateBillNumber(),
        items: [NewBillItem(id: _nextItemId())],
      ),
    );
  }
}
