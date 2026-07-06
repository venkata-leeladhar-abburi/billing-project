import '../../../core/mock/mock_fixtures.dart';
import '../../../core/models/plan_type.dart';
import '../../../core/models/shop_model.dart';

/// Enriches core/mock/mock_fixtures.dart's MockShop list into full ShopModel
/// instances (with address/autopay/usage fields) for the salesperson portal,
/// reused across dashboard, shop list, shop detail, and edit shop notifiers.
List<ShopModel> buildMockShopModels() {
  final now = DateTime.now();

  SubscriptionPlan planFor(String plan) {
    switch (plan) {
      case 'basic':
        return SubscriptionPlan.basic;
      case 'business':
        return SubscriptionPlan.business;
      default:
        return SubscriptionPlan.pro;
    }
  }

  ShopStatus statusFor(String status) {
    switch (status) {
      case 'pending_setup':
        return ShopStatus.pendingSetup;
      case 'suspended':
        return ShopStatus.suspended;
      default:
        return ShopStatus.active;
    }
  }

  double amountFor(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.basic:
        return 299;
      case SubscriptionPlan.pro:
        return 599;
      case SubscriptionPlan.business:
        return 999;
    }
  }

  final extras = [
    (
      businessType: 'Clothing',
      phone: '+919876543210',
      city: 'Anantapur',
      addedDaysAgo: 120,
      lastActiveHoursAgo: 1,
      billsThisMonth: 42,
      customers: 218,
      salesperson: 'Venkatesh Naidu',
    ),
    (
      businessType: 'Steel',
      phone: '+919876543220',
      city: 'Kadapa',
      addedDaysAgo: 60,
      lastActiveHoursAgo: 5,
      billsThisMonth: 18,
      customers: 96,
      salesperson: 'Priya Sharma',
    ),
    (
      businessType: 'Electronics',
      phone: '+919876543230',
      city: 'Kurnool',
      addedDaysAgo: 20,
      lastActiveHoursAgo: 26,
      billsThisMonth: 63,
      customers: 340,
      salesperson: 'Venkatesh Naidu',
    ),
    (
      businessType: 'Jewellery',
      phone: '+919876543240',
      city: 'Tirupati',
      addedDaysAgo: 3,
      lastActiveHoursAgo: 48,
      billsThisMonth: 0,
      customers: 0,
      salesperson: 'Priya Sharma',
    ),
  ];

  return List.generate(MockFixtures.shops.length, (i) {
    final mock = MockFixtures.shops[i];
    final extra = extras[i % extras.length];
    final plan = planFor(mock.plan);

    return ShopModel(
      id: mock.id,
      shopName: mock.shopName,
      ownerName: mock.ownerName,
      businessType: extra.businessType,
      plan: plan,
      status: statusFor(mock.status),
      salespersonName: extra.salesperson,
      phone: extra.phone,
      whatsappNumber: extra.phone,
      address: '${extra.businessType} Market Road',
      city: extra.city,
      state: 'Andhra Pradesh',
      pinCode: '515001',
      gstNumber: i.isEven ? '37AABCS1234C1Z${i + 1}' : null,
      addedDate: now.subtract(Duration(days: extra.addedDaysAgo)),
      templateName: '${extra.businessType.toLowerCase()}_festival_offer',
      monthlyAmount: amountFor(plan),
      autopayStatus: statusFor(mock.status) == ShopStatus.pendingSetup
          ? AutoPayStatus.pending
          : AutoPayStatus.active,
      nextBillingDate: DateTime(now.year, now.month + 1, 1),
      billCreditsUsed: extra.billsThisMonth,
      billCreditsLimit: plan == SubscriptionPlan.business ? 99999 : (plan == SubscriptionPlan.pro ? 300 : 100),
      msgCreditsUsed: (extra.billsThisMonth * 2).clamp(0, 800),
      msgCreditsLimit: plan == SubscriptionPlan.business ? 2000 : (plan == SubscriptionPlan.pro ? 800 : 300),
      customerCount: extra.customers,
      customerLimit: plan == SubscriptionPlan.basic ? 500 : (plan == SubscriptionPlan.pro ? 2000 : null),
      billsSentThisMonth: extra.billsThisMonth,
      lastActiveAt: now.subtract(Duration(hours: extra.lastActiveHoursAgo)),
    );
  });
}

/// Shops managed by a single logged-in salesperson (used by the salesperson
/// portal's dashboard/shop-list, as opposed to the admin portal's unfiltered
/// buildMockShopModels() which shows every shop platform-wide).
List<ShopModel> buildMockShopModelsFor(String salespersonName) {
  return buildMockShopModels().where((s) => s.salespersonName == salespersonName).toList();
}
