// Delete this entire file when real backend is connected

class MockFixtures {
  // ── SHOP ──────────────────────────────────────────
  static const shopName = 'Raju Silks';
  static const ownerName = 'Rajesh Kumar';
  static const shopPhone = '+919876543210';
  static const shopGst = '37AABCS1234C1Z5';
  static const plan = 'pro';
  static const billCredits = 82;
  static const billCreditsMax = 300;
  static const msgCredits = 640;
  static const msgCreditsMax = 800;

  // ── CUSTOMERS ─────────────────────────────────────
  static final customers = [
    MockCustomer('c1', 'Suresh Kumar', '+919876543210', 8, 24800),
    MockCustomer('c2', 'Ramesh Reddy', '+919876543211', 3, 8600),
    MockCustomer('c3', 'Venkat Rao', '+919876543212', 12, 36200),
    MockCustomer('c4', 'Lakshmi Devi', '+919876543213', 5, 14500),
    MockCustomer('c5', 'Prasad Sharma', '+919876543214', 1, 2400),
  ];

  // ── BILLS ─────────────────────────────────────────
  static final bills = [
    MockBill('b1', 'BILL-2026-0042', 'Suresh Kumar', 2992.50, 'sent', '2 min ago'),
    MockBill('b2', 'BILL-2026-0041', 'Ramesh Reddy', 1450.00, 'sent', '1 hr ago'),
    MockBill('b3', 'BILL-2026-0040', 'Venkat Rao', 8200.00, 'sent', '3 hrs ago'),
    MockBill('b4', 'BILL-2026-0039', 'Lakshmi Devi', 3600.00, 'failed', '5 hrs ago'),
    MockBill('b5', 'BILL-2026-0038', 'Prasad Sharma', 2400.00, 'sent', 'Yesterday'),
  ];

  // ── TEMPLATES ─────────────────────────────────────
  static final templates = [
    MockTemplate(
      't1',
      'Festival Offer',
      'New arrivals at {{shop_name}}! Visit us for {{offer}} this season.',
      'approved',
    ),
    MockTemplate(
      't2',
      'Payment Reminder',
      'Dear {{customer_name}}, your payment of ₹{{amount}} is due at {{shop_name}}.',
      'approved',
    ),
    MockTemplate(
      't3',
      'New Stock Alert',
      'Fresh stock arrived at {{shop_name}}! {{item}} now available.',
      'approved',
    ),
  ];

  // ── SHOPS (for salesperson) ────────────────────────
  static final shops = [
    MockShop('s1', 'Raju Silks', 'Rajesh Kumar', 'pro', 'active'),
    MockShop('s2', 'Krishna Steel', 'Krishna Rao', 'basic', 'active'),
    MockShop('s3', 'Sri Electronics', 'Srinivas', 'business', 'active'),
    MockShop('s4', 'Lakshmi Jewels', 'Lakshmi', 'pro', 'pending_setup'),
  ];
}

// ── Simple data classes (no fromJson needed — mock only) ──
class MockCustomer {
  final String id, name, phone;
  final int billCount;
  final double totalBilled;
  const MockCustomer(this.id, this.name, this.phone, this.billCount, this.totalBilled);
}

class MockBill {
  final String id, number, customerName, status, sentAgo;
  final double total;
  const MockBill(this.id, this.number, this.customerName, this.total, this.status, this.sentAgo);
}

class MockTemplate {
  final String id, displayName, body, metaStatus;
  const MockTemplate(this.id, this.displayName, this.body, this.metaStatus);
}

class MockShop {
  final String id, shopName, ownerName, plan, status;
  const MockShop(this.id, this.shopName, this.ownerName, this.plan, this.status);
}
