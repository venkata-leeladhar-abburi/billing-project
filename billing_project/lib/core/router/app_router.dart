import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/admin/presentation/add_salesperson_screen.dart';
import '../../features/admin/presentation/admin_settings_screen.dart';
import '../../features/admin/presentation/all_shops_screen.dart';
import '../../features/admin/presentation/cancellation_detail_screen.dart';
import '../../features/admin/presentation/cancellation_list_screen.dart';
import '../../features/admin/presentation/dashboard_screen.dart';
import '../../features/admin/presentation/plans_screen.dart';
import '../../features/admin/presentation/platform_settings_screen.dart';
import '../../features/admin/presentation/revenue_screen.dart';
import '../../features/admin/presentation/salesperson_detail_screen.dart';
import '../../features/admin/presentation/salesperson_list_screen.dart';
import '../../features/admin/presentation/shop_detail_screen.dart';
import '../../features/admin/presentation/template_detail_screen.dart';
import '../../features/admin/presentation/templates_screen.dart';
import '../../features/auth/presentation/admin_login_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/salesperson_login_screen.dart';
import '../../features/billing/presentation/bill_detail_screen.dart';
import '../../features/billing/presentation/bill_history_screen.dart';
import '../../features/billing/presentation/bill_preview_screen.dart';
import '../../features/billing/presentation/bill_sent_screen.dart';
import '../../features/customers/presentation/add_customer_screen.dart';
import '../../features/customers/presentation/customer_detail_screen.dart';
import '../../features/customers/presentation/customer_list_screen.dart';
import '../../features/billing/presentation/new_bill_screen.dart';
import '../../features/credits/domain/credits_notifier.dart';
import '../../features/credits/presentation/credits_screen.dart';
import '../../features/credits/presentation/topup_screen.dart';
import '../../features/credits/presentation/topup_success_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/messaging/presentation/bulk_message_preview_screen.dart';
import '../../features/messaging/presentation/bulk_message_screen.dart';
import '../../features/messaging/presentation/delivery_report_screen.dart';
import '../../features/messaging/presentation/template_select_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/settings/presentation/cancel_confirm_screen.dart';
import '../../features/settings/presentation/cancel_request_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/salesperson/presentation/add_shop/step1_details_screen.dart';
import '../../features/salesperson/presentation/add_shop/step2_branding_screen.dart';
import '../../features/salesperson/presentation/add_shop/step3_plan_screen.dart';
import '../../features/salesperson/presentation/add_shop/step4_autopay_screen.dart';
import '../../features/salesperson/presentation/add_shop/success_screen.dart';
import '../../features/salesperson/presentation/cancellation_detail_screen.dart';
import '../../features/salesperson/presentation/cancellation_list_screen.dart';
import '../../features/salesperson/presentation/dashboard_screen.dart';
import '../../features/salesperson/presentation/edit_shop_screen.dart';
import '../../features/salesperson/presentation/settings_screen.dart';
import '../../features/salesperson/presentation/shop_detail_screen.dart';
import '../../features/salesperson/presentation/shop_list_screen.dart';
import '../constants/app_colors.dart';
import '../utils/mock_session.dart';

/// All go_router routes for Billing Project live here — nowhere else.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    redirect: _redirect,
    routes: [
      // ── SHOPKEEPER ────────────────────────────────────────────────────
      GoRoute(path: '/onboarding', builder: _onboardingBuilder),
      GoRoute(path: '/login', builder: _loginBuilder),
      GoRoute(path: '/otp', builder: _otpBuilder),
      GoRoute(path: '/bill-preview', builder: _billPreviewBuilder),
      GoRoute(path: '/bill-sent', builder: _billSentBuilder),
      GoRoute(path: '/bill-history', builder: _billHistoryBuilder),
      GoRoute(path: '/bill/:id', builder: _billDetailBuilder),
      GoRoute(path: '/customers/add', builder: _addCustomerBuilder),
      GoRoute(path: '/customers/:id', builder: _customerDetailBuilder),
      GoRoute(path: '/bulk-message', builder: _bulkMessageBuilder),
      GoRoute(path: '/template-select', builder: _templateSelectBuilder),
      GoRoute(path: '/bulk-message-preview', builder: _bulkMessagePreviewBuilder),
      GoRoute(path: '/delivery-report', builder: _deliveryReportBuilder),
      GoRoute(path: '/credits', builder: _creditsBuilder),
      GoRoute(path: '/credits/topup', builder: _topupBuilder),
      GoRoute(path: '/credits/topup-success', builder: _topupSuccessBuilder),
      GoRoute(path: '/notifications', builder: _notificationsBuilder),
      GoRoute(path: '/settings/cancel-request', builder: _cancelRequestBuilder),
      GoRoute(path: '/settings/cancel-confirm', builder: _cancelConfirmBuilder),

      // ── SALESPERSON ───────────────────────────────────────────────────
      GoRoute(
        path: '/salesperson/login',
        builder: _salespersonLoginBuilder,
      ),
      GoRoute(
        path: '/salesperson/shops/add/details',
        builder: _step1DetailsBuilder,
      ),
      GoRoute(
        path: '/salesperson/shops/add/branding',
        builder: _step2BrandingBuilder,
      ),
      GoRoute(
        path: '/salesperson/shops/add/plan',
        builder: _step3PlanBuilder,
      ),
      GoRoute(
        path: '/salesperson/shops/add/autopay',
        builder: _step4AutoPayBuilder,
      ),
      GoRoute(
        path: '/salesperson/shops/add/success',
        builder: _addShopSuccessBuilder,
      ),
      GoRoute(path: '/salesperson/shops/:shopId', builder: _shopDetailBuilder),
      GoRoute(
        path: '/salesperson/shops/:shopId/edit',
        builder: _editShopBuilder,
      ),
      GoRoute(
        path: '/salesperson/cancellations/:requestId',
        builder: _cancellationDetailBuilder,
      ),

      // ── SUPER ADMIN ───────────────────────────────────────────────────
      GoRoute(path: '/admin/login', builder: _adminLoginBuilder),
      GoRoute(path: '/admin/salespersons/add', builder: _addSalespersonBuilder),
      GoRoute(path: '/admin/salespersons/:id', builder: _salespersonDetailBuilder),
      GoRoute(path: '/admin/shops/:shopId', builder: _adminShopDetailBuilder),
      GoRoute(path: '/admin/templates/add', builder: _templateAddBuilder),
      GoRoute(path: '/admin/templates/:id', builder: _templateDetailBuilder),
      GoRoute(path: '/admin/plans', builder: _plansBuilder),
      GoRoute(path: '/admin/cancellations', builder: _adminCancellationListBuilder),
      GoRoute(
        path: '/admin/cancellations/:requestId',
        builder: _adminCancellationDetailBuilder,
      ),
      GoRoute(path: '/admin/revenue', builder: _revenueBuilder),
      GoRoute(path: '/admin/platform-settings', builder: _platformSettingsBuilder),

      // Screens below own their own bottom bar (AppBottomTabBar or
      // BottomActionBar), so they sit outside the shopkeeper ShellRoute
      // to avoid stacking a second bottom bar underneath.
      GoRoute(path: '/dashboard', builder: _dashboardBuilder),
      GoRoute(path: '/new-bill', builder: _newBillBuilder),

      // ── SHELL: SHOPKEEPER TAB BAR ─────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) =>
            _TabShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: '/customers', builder: _customersBuilder),
          GoRoute(path: '/settings', builder: _settingsBuilder),
        ],
      ),

      // ── SHELL: SALESPERSON TAB BAR ────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) =>
            _TabShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: '/salesperson/dashboard',
            builder: _salespersonDashboardBuilder,
          ),
          GoRoute(path: '/salesperson/shops', builder: _shopListBuilder),
          GoRoute(
            path: '/salesperson/cancellations',
            builder: _cancellationListBuilder,
          ),
          GoRoute(
            path: '/salesperson/settings',
            builder: _salespersonSettingsBuilder,
          ),
        ],
      ),

      // ── SHELL: SUPER ADMIN TAB BAR ────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) =>
            _TabShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: '/admin/dashboard', builder: _adminDashboardBuilder),
          GoRoute(path: '/admin/shops', builder: _allShopsBuilder),
          GoRoute(path: '/admin/salespersons', builder: _salespersonListBuilder),
          GoRoute(path: '/admin/templates', builder: _templatesBuilder),
          GoRoute(path: '/admin/settings', builder: _adminSettingsBuilder),
        ],
      ),
    ],
  );

  /// Role-based redirect. Checks Supabase session's user_metadata.role
  /// on every navigation and routes unauthenticated / mismatched-role
  /// users to the correct entry point.
  static String? _redirect(BuildContext context, GoRouterState state) {
    const publicPaths = {
      '/onboarding',
      '/login',
      '/otp',
      '/salesperson/login',
      '/admin/login',
    };
    final location = state.matchedLocation;

    Session? session;
    try {
      session = Supabase.instance.client.auth.currentSession;
    } catch (_) {
      // Supabase not initialised yet (e.g. during early scaffolding) —
      // treat as unauthenticated rather than crash the router.
      session = null;
    }

    // TODO: MockSession is a temporary bypass for the mock-auth flow (see
    // core/utils/mock_session.dart) — remove once AuthNotifier uses real
    // Supabase Auth and a real session is always present after login.
    final mockRole = MockSession.role;
    final isAuthenticated = session != null || mockRole != null;

    if (!isAuthenticated) {
      return publicPaths.contains(location) ? null : '/login';
    }

    if (!publicPaths.contains(location)) {
      return null;
    }

    final role = mockRole ?? (session?.user.userMetadata?['role'] as String?);
    switch (role) {
      case 'shopkeeper':
        return '/dashboard';
      case 'salesperson':
        return '/salesperson/dashboard';
      case 'super_admin':
        return '/admin/dashboard';
      default:
        return '/login';
    }
  }

  static Widget _dashboardBuilder(BuildContext context, GoRouterState state) {
    return const DashboardScreen();
  }

  static Widget _newBillBuilder(BuildContext context, GoRouterState state) {
    return const NewBillScreen();
  }

  static Widget _billPreviewBuilder(BuildContext context, GoRouterState state) {
    return const BillPreviewScreen();
  }

  static Widget _billSentBuilder(BuildContext context, GoRouterState state) {
    return const BillSentScreen();
  }

  static Widget _customersBuilder(BuildContext context, GoRouterState state) {
    return const CustomerListScreen();
  }

  static Widget _customerDetailBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return CustomerDetailScreen(customerId: state.pathParameters['id']!);
  }

  static Widget _addCustomerBuilder(BuildContext context, GoRouterState state) {
    return const AddCustomerScreen();
  }

  static Widget _billHistoryBuilder(BuildContext context, GoRouterState state) {
    return BillHistoryScreen(customerId: state.uri.queryParameters['customerId']);
  }

  static Widget _billDetailBuilder(BuildContext context, GoRouterState state) {
    return BillDetailScreen(billId: state.pathParameters['id']!);
  }

  static Widget _bulkMessageBuilder(BuildContext context, GoRouterState state) {
    return const BulkMessageScreen();
  }

  static Widget _templateSelectBuilder(BuildContext context, GoRouterState state) {
    return const TemplateSelectScreen();
  }

  static Widget _bulkMessagePreviewBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return const BulkMessagePreviewScreen();
  }

  static Widget _deliveryReportBuilder(BuildContext context, GoRouterState state) {
    return const DeliveryReportScreen();
  }

  static Widget _creditsBuilder(BuildContext context, GoRouterState state) {
    return const CreditsScreen();
  }

  static const _defaultTopupPack = TopupPack(
    id: 'msg_standard',
    name: 'Standard Pack',
    credits: 500,
    creditType: 'msg',
    price: 500,
    perUnitCost: 1.00,
  );

  static Widget _topupBuilder(BuildContext context, GoRouterState state) {
    return TopupScreen(pack: state.extra as TopupPack? ?? _defaultTopupPack);
  }

  static Widget _topupSuccessBuilder(BuildContext context, GoRouterState state) {
    return const TopupSuccessScreen();
  }

  static Widget _notificationsBuilder(BuildContext context, GoRouterState state) {
    return const NotificationsScreen();
  }

  static Widget _settingsBuilder(BuildContext context, GoRouterState state) {
    return const SettingsScreen();
  }

  static Widget _cancelRequestBuilder(BuildContext context, GoRouterState state) {
    return const CancelRequestScreen();
  }

  static Widget _cancelConfirmBuilder(BuildContext context, GoRouterState state) {
    return const CancelConfirmScreen();
  }

  static Widget _onboardingBuilder(BuildContext context, GoRouterState state) {
    return const OnboardingScreen();
  }

  static Widget _loginBuilder(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }

  static Widget _otpBuilder(BuildContext context, GoRouterState state) {
    return OtpScreen(phone: state.extra as String? ?? '');
  }

  static Widget _salespersonLoginBuilder(BuildContext context, GoRouterState state) {
    return const SalespersonLoginScreen();
  }

  static Widget _salespersonDashboardBuilder(BuildContext context, GoRouterState state) {
    return const SalespersonDashboardScreen();
  }

  static Widget _shopListBuilder(BuildContext context, GoRouterState state) {
    return const ShopListScreen();
  }

  static Widget _step1DetailsBuilder(BuildContext context, GoRouterState state) {
    return const Step1DetailsScreen();
  }

  static Widget _step2BrandingBuilder(BuildContext context, GoRouterState state) {
    return const Step2BrandingScreen();
  }

  static Widget _step3PlanBuilder(BuildContext context, GoRouterState state) {
    return const Step3PlanScreen();
  }

  static Widget _step4AutoPayBuilder(BuildContext context, GoRouterState state) {
    return const Step4AutoPayScreen();
  }

  static Widget _addShopSuccessBuilder(BuildContext context, GoRouterState state) {
    return AddShopSuccessScreen(shopId: state.extra as String?);
  }

  static Widget _shopDetailBuilder(BuildContext context, GoRouterState state) {
    return ShopDetailScreen(shopId: state.pathParameters['shopId']!);
  }

  static Widget _editShopBuilder(BuildContext context, GoRouterState state) {
    return EditShopScreen(shopId: state.pathParameters['shopId']!);
  }

  static Widget _cancellationListBuilder(BuildContext context, GoRouterState state) {
    return const CancellationListScreen();
  }

  static Widget _cancellationDetailBuilder(BuildContext context, GoRouterState state) {
    return CancellationDetailScreen(requestId: state.pathParameters['requestId']!);
  }

  static Widget _salespersonSettingsBuilder(BuildContext context, GoRouterState state) {
    return const SalespersonSettingsScreen();
  }

  static Widget _adminLoginBuilder(BuildContext context, GoRouterState state) {
    return const AdminLoginScreen();
  }

  static Widget _adminDashboardBuilder(BuildContext context, GoRouterState state) {
    return const AdminDashboardScreen();
  }

  static Widget _salespersonListBuilder(BuildContext context, GoRouterState state) {
    return const SalespersonListScreen();
  }

  static Widget _addSalespersonBuilder(BuildContext context, GoRouterState state) {
    return const AddSalespersonScreen();
  }

  static Widget _salespersonDetailBuilder(BuildContext context, GoRouterState state) {
    return SalespersonDetailScreen(salespersonId: state.pathParameters['id']!);
  }

  static Widget _allShopsBuilder(BuildContext context, GoRouterState state) {
    return const AllShopsScreen();
  }

  static Widget _adminShopDetailBuilder(BuildContext context, GoRouterState state) {
    return AdminShopDetailScreen(shopId: state.pathParameters['shopId']!);
  }

  static Widget _templatesBuilder(BuildContext context, GoRouterState state) {
    return const TemplatesScreen();
  }

  static Widget _templateDetailBuilder(BuildContext context, GoRouterState state) {
    return TemplateDetailScreen(templateId: state.pathParameters['id']!);
  }

  static Widget _templateAddBuilder(BuildContext context, GoRouterState state) {
    return const TemplateDetailScreen(templateId: 'new');
  }

  static Widget _plansBuilder(BuildContext context, GoRouterState state) {
    return const PlansScreen();
  }

  static Widget _adminCancellationListBuilder(BuildContext context, GoRouterState state) {
    return const AdminCancellationListScreen();
  }

  static Widget _adminCancellationDetailBuilder(BuildContext context, GoRouterState state) {
    return AdminCancellationDetailScreen(requestId: state.pathParameters['requestId']!);
  }

  static Widget _revenueBuilder(BuildContext context, GoRouterState state) {
    return const RevenueScreen();
  }

  static Widget _platformSettingsBuilder(BuildContext context, GoRouterState state) {
    return const PlatformSettingsScreen();
  }

  static Widget _adminSettingsBuilder(BuildContext context, GoRouterState state) {
    return const AdminSettingsScreen();
  }
}

/// Minimal shell that shows a bottom tab bar around shopkeeper /
/// salesperson / super_admin tab routes. Tab items are picked per role
/// based on the current location's prefix.
class _TabShell extends StatelessWidget {
  const _TabShell({required this.location, required this.child});

  final String location;
  final Widget child;

  static const _shopkeeperTabs = [
    ('/dashboard', Icons.home_outlined, 'Home'),
    ('/new-bill', Icons.receipt_long_outlined, 'New Bill'),
    ('/customers', Icons.people_outline, 'Customers'),
    ('/settings', Icons.settings_outlined, 'Settings'),
  ];

  static const _salespersonTabs = [
    ('/salesperson/dashboard', Icons.dashboard_outlined, 'Dashboard'),
    ('/salesperson/shops', Icons.storefront_outlined, 'Shops'),
    (
      '/salesperson/cancellations',
      Icons.report_gmailerrorred_outlined,
      'Cancellations',
    ),
    ('/salesperson/settings', Icons.settings_outlined, 'Settings'),
  ];

  static const _adminTabs = [
    ('/admin/dashboard', Icons.dashboard_outlined, 'Dashboard'),
    ('/admin/shops', Icons.storefront_outlined, 'Shops'),
    ('/admin/salespersons', Icons.groups_outlined, 'Salespersons'),
    ('/admin/templates', Icons.article_outlined, 'Templates'),
    ('/admin/settings', Icons.settings_outlined, 'Settings'),
  ];

  List<(String, IconData, String)> get _tabs {
    if (location.startsWith('/salesperson')) return _salespersonTabs;
    if (location.startsWith('/admin')) return _adminTabs;
    return _shopkeeperTabs;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _tabs;
    final currentIndex = tabs.indexWhere((t) => t.$1 == location).clamp(
          0,
          tabs.length - 1,
        );

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex < 0 ? 0 : currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.kOrange,
        unselectedItemColor: AppColors.kMuted,
        backgroundColor: AppColors.kBgCard,
        onTap: (index) => context.go(tabs[index].$1),
        items: [
          for (final tab in tabs)
            BottomNavigationBarItem(icon: Icon(tab.$2), label: tab.$3),
        ],
      ),
    );
  }
}
