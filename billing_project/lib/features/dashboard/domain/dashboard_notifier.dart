import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_notifier.g.dart';

class MockBill {
  const MockBill(
    this.billId,
    this.billNumber,
    this.customerName,
    this.total,
    this.status,
    this.sentAgo,
  );

  final String billId;
  final String billNumber;
  final String customerName;
  final double total;
  final String status;
  final String sentAgo;
}

class DashboardState {
  const DashboardState({
    required this.shopName,
    required this.ownerName,
    required this.plan,
    required this.billCredits,
    required this.billCreditsLimit,
    required this.msgCredits,
    required this.msgCreditsLimit,
    required this.todayRevenue,
    required this.todayBillCount,
    required this.recentBills,
  });

  final String shopName;
  final String ownerName;
  final String plan;
  final int billCredits;
  final int billCreditsLimit;
  final int msgCredits;
  final int msgCreditsLimit;
  final double todayRevenue;
  final int todayBillCount;
  final List<MockBill> recentBills;
}

@riverpod
class DashboardNotifier extends _$DashboardNotifier {
  @override
  AsyncValue<DashboardState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    // TODO: replace with real dashboardRepository call when backend ready
    await Future.delayed(const Duration(milliseconds: 600));
    state = const AsyncValue.data(
      DashboardState(
        shopName: 'Raju Silks',
        ownerName: 'Rajesh Kumar',
        plan: 'pro',
        billCredits: 82,
        billCreditsLimit: 300,
        msgCredits: 640,
        msgCreditsLimit: 800,
        todayRevenue: 12400.0,
        todayBillCount: 8,
        recentBills: [
          MockBill('b1', 'BILL-2026-0042', 'Suresh Kumar', 2992.50, 'sent', '2 min ago'),
          MockBill('b2', 'BILL-2026-0041', 'Ramesh Reddy', 1450.00, 'sent', '1 hr ago'),
          MockBill('b3', 'BILL-2026-0040', 'Venkat Rao', 8200.00, 'sent', '3 hrs ago'),
          MockBill('b4', 'BILL-2026-0039', 'Lakshmi Devi', 3600.00, 'failed', '5 hrs ago'),
          MockBill('b5', 'BILL-2026-0038', 'Prasad Sharma', 2400.00, 'sent', 'Yesterday'),
        ],
      ),
    );
  }

  Future<void> refresh() => _loadMock();
}
