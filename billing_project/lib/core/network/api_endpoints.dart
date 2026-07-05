/// All Node.js backend API paths as string constants.
/// No inline URL strings in repositories — import this class instead.
class ApiEndpoints {
  ApiEndpoints._();

  // ── SHOPS (API.md Section 3) ───────────────────────────────────────────
  static const shopsMe = '/shops/me';
  static const shops = '/shops'; // POST create, GET list (salesperson)
  static const adminShops = '/admin/shops'; // GET list (super admin)

  static String shopLogo(String shopId) => '/shops/$shopId/logo';
  static String shopById(String shopId) => '/shops/$shopId';
  static String adminShopById(String shopId) => '/admin/shops/$shopId';

  // ── CUSTOMERS (API.md Section 4) ────────────────────────────────────────
  static const customers = '/customers'; // GET list, POST add
  static String customerById(String customerId) => '/customers/$customerId';

  // ── BILLING (API.md Section 5) ──────────────────────────────────────────
  static const bills = '/bills'; // POST create, GET history
  static String billById(String billId) => '/bills/$billId';
  static String billResend(String billId) => '/bills/$billId/resend';

  // ── MESSAGING (API.md Section 6) ────────────────────────────────────────
  static const templates = '/templates';
  static const campaigns = '/campaigns';
  static String campaignReport(String campaignId) =>
      '/campaigns/$campaignId/report';
  static String campaignRetry(String campaignId) =>
      '/campaigns/$campaignId/retry';

  // ── CREDITS (API.md Section 7) ───────────────────────────────────────────
  static const creditsPacks = '/credits/packs';
  static const creditsTopupInitiate = '/credits/topup/initiate';
  static const creditsTopupVerify = '/credits/topup/verify';
  static String adminShopCreditsAdd(String shopId) =>
      '/admin/shops/$shopId/credits/add';

  // ── SUBSCRIPTIONS & AUTOPAY (API.md Section 8) ───────────────────────────
  static const subscriptionsAutopayCreate = '/subscriptions/autopay/create';
  static const subscriptionsAutopayStatus = '/subscriptions/autopay/status';
  static String adminSubscriptionCancel(String subscriptionId) =>
      '/admin/subscriptions/$subscriptionId/cancel';

  // ── TEMPLATES — ADMIN (API.md Section 9) ─────────────────────────────────
  static const adminTemplates = '/admin/templates'; // GET list, POST create
  static String adminTemplateById(String templateId) =>
      '/admin/templates/$templateId'; // PUT update
  static String adminTemplateToggle(String templateId) =>
      '/admin/templates/$templateId/toggle';

  // ── NOTIFICATIONS (API.md Section 10) ────────────────────────────────────
  static const notificationsRegister = '/notifications/register';
  static const notifications = '/notifications';
  static const notificationsMarkRead = '/notifications/mark-read';

  // ── ADMIN (API.md Section 11) ────────────────────────────────────────────
  static const adminDashboard = '/admin/dashboard';
  static const adminRevenue = '/admin/revenue';
  static const adminSalespersons =
      '/admin/salespersons'; // GET list, POST create
  static String adminSalespersonById(String salespersonId) =>
      '/admin/salespersons/$salespersonId';
}
