import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/shop_model.dart';
import '../../salesperson/domain/salesperson_mock_shops.dart';
import 'admin_mock_salespersons.dart';

part 'admin_dashboard_notifier.g.dart';

enum ActivityType { subscribed, cancellationRequested, autopayFailed, shopAdded, bulkSent }

class ActivityEvent {
  const ActivityEvent({required this.type, required this.text, required this.timestamp});

  final ActivityType type;
  final String text;
  final DateTime timestamp;
}

class AdminDashboardState {
  const AdminDashboardState({
    required this.adminName,
    required this.shops,
    required this.salespersons,
    required this.pendingCancellations,
    required this.paymentFailedShops,
    required this.templatesNeedingRenewal,
    required this.activity,
  });

  final String adminName;
  final List<ShopModel> shops;
  final List<SalespersonModel> salespersons;
  final int pendingCancellations;
  final int paymentFailedShops;
  final int templatesNeedingRenewal;
  final List<ActivityEvent> activity;

  double get mrr => shops.where((s) => s.status != ShopStatus.suspended).fold(0.0, (sum, s) => sum + s.monthlyAmount);
  int get totalShops => shops.length;
  int get activeShops => shops.where((s) => s.status == ShopStatus.active).length;
  int get activeSalespersons => salespersons.where((s) => s.isActive).length;
  int get pendingIssues => pendingCancellations + paymentFailedShops;
  int get newShopsThisMonth => shops.where((s) => s.addedDate != null && DateTime.now().difference(s.addedDate!).inDays <= 30).length;
  int get newShopsToday => shops.where((s) => s.addedDate != null && DateTime.now().difference(s.addedDate!).inHours < 24).length;
}

@riverpod
class AdminDashboardNotifier extends _$AdminDashboardNotifier {
  @override
  AsyncValue<AdminDashboardState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /admin/dashboard call when backend ready
    final shops = buildMockShopModels();
    final now = DateTime.now();
    state = AsyncValue.data(AdminDashboardState(
      adminName: 'Leeladhar',
      shops: shops,
      salespersons: buildMockSalespersons(),
      pendingCancellations: 1,
      paymentFailedShops: shops.where((s) => s.autopayStatus == AutoPayStatus.failed).length,
      templatesNeedingRenewal: 1,
      activity: [
        ActivityEvent(type: ActivityType.subscribed, text: '${shops[0].shopName} subscribed to ${shops[0].plan.name} Plan', timestamp: now.subtract(const Duration(hours: 2))),
        ActivityEvent(type: ActivityType.cancellationRequested, text: '${shops[3].shopName} requested cancellation', timestamp: now.subtract(const Duration(hours: 5))),
        ActivityEvent(type: ActivityType.shopAdded, text: 'Priya Sharma added ${shops[1].shopName}', timestamp: now.subtract(const Duration(hours: 8))),
        ActivityEvent(type: ActivityType.bulkSent, text: '128 messages sent by ${shops[0].shopName}', timestamp: now.subtract(const Duration(hours: 12))),
        ActivityEvent(type: ActivityType.autopayFailed, text: '${shops[1].shopName} AutoPay failed', timestamp: now.subtract(const Duration(days: 1))),
      ],
    ));
  }
}
