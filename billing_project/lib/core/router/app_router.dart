import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_colors.dart';

/// All go_router routes for Billing Project live here — nowhere else.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: _redirect,
    routes: [
      // ── SHOPKEEPER ────────────────────────────────────────────────────
      GoRoute(path: '/login', builder: _placeholderBuilder),
      GoRoute(path: '/otp', builder: _placeholderBuilder),
      GoRoute(path: '/bill-preview', builder: _placeholderBuilder),
      GoRoute(path: '/bill-sent', builder: _placeholderBuilder),
      GoRoute(path: '/bill-history', builder: _placeholderBuilder),
      GoRoute(path: '/bill/:id', builder: _placeholderBuilder),
      GoRoute(path: '/customers/add', builder: _placeholderBuilder),
      GoRoute(path: '/customers/:id', builder: _placeholderBuilder),
      GoRoute(path: '/bulk-message', builder: _placeholderBuilder),
      GoRoute(path: '/template-select', builder: _placeholderBuilder),
      GoRoute(path: '/bulk-message-preview', builder: _placeholderBuilder),
      GoRoute(path: '/delivery-report', builder: _placeholderBuilder),
      GoRoute(path: '/credits', builder: _placeholderBuilder),
      GoRoute(path: '/credits/topup', builder: _placeholderBuilder),
      GoRoute(path: '/credits/topup-success', builder: _placeholderBuilder),
      GoRoute(path: '/notifications', builder: _placeholderBuilder),
      GoRoute(path: '/settings/cancel-request', builder: _placeholderBuilder),
      GoRoute(path: '/settings/cancel-confirm', builder: _placeholderBuilder),

      // ── SALESPERSON ───────────────────────────────────────────────────
      GoRoute(path: '/salesperson/login', builder: _placeholderBuilder),
      GoRoute(
        path: '/salesperson/shops/add/details',
        builder: _placeholderBuilder,
      ),
      GoRoute(
        path: '/salesperson/shops/add/branding',
        builder: _placeholderBuilder,
      ),
      GoRoute(
        path: '/salesperson/shops/add/plan',
        builder: _placeholderBuilder,
      ),
      GoRoute(
        path: '/salesperson/shops/add/autopay',
        builder: _placeholderBuilder,
      ),
      GoRoute(
        path: '/salesperson/shops/add/success',
        builder: _placeholderBuilder,
      ),
      GoRoute(path: '/salesperson/shops/:shopId', builder: _placeholderBuilder),
      GoRoute(
        path: '/salesperson/shops/:shopId/edit',
        builder: _placeholderBuilder,
      ),
      GoRoute(
        path: '/salesperson/cancellations/:requestId',
        builder: _placeholderBuilder,
      ),

      // ── SUPER ADMIN ───────────────────────────────────────────────────
      GoRoute(path: '/admin/login', builder: _placeholderBuilder),
      GoRoute(path: '/admin/salespersons/add', builder: _placeholderBuilder),
      GoRoute(path: '/admin/salespersons/:id', builder: _placeholderBuilder),
      GoRoute(path: '/admin/shops/:shopId', builder: _placeholderBuilder),
      GoRoute(path: '/admin/templates/add', builder: _placeholderBuilder),
      GoRoute(path: '/admin/templates/:id', builder: _placeholderBuilder),
      GoRoute(path: '/admin/plans', builder: _placeholderBuilder),
      GoRoute(path: '/admin/cancellations', builder: _placeholderBuilder),
      GoRoute(
        path: '/admin/cancellations/:requestId',
        builder: _placeholderBuilder,
      ),
      GoRoute(path: '/admin/revenue', builder: _placeholderBuilder),
      GoRoute(path: '/admin/platform-settings', builder: _placeholderBuilder),

      // ── SHELL: SHOPKEEPER TAB BAR ─────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) =>
            _TabShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: '/dashboard', builder: _placeholderBuilder),
          GoRoute(path: '/new-bill', builder: _placeholderBuilder),
          GoRoute(path: '/customers', builder: _placeholderBuilder),
          GoRoute(path: '/settings', builder: _placeholderBuilder),
        ],
      ),

      // ── SHELL: SALESPERSON TAB BAR ────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) =>
            _TabShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: '/salesperson/dashboard', builder: _placeholderBuilder),
          GoRoute(path: '/salesperson/shops', builder: _placeholderBuilder),
          GoRoute(
            path: '/salesperson/cancellations',
            builder: _placeholderBuilder,
          ),
          GoRoute(path: '/salesperson/settings', builder: _placeholderBuilder),
        ],
      ),

      // ── SHELL: SUPER ADMIN TAB BAR ────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) =>
            _TabShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: '/admin/dashboard', builder: _placeholderBuilder),
          GoRoute(path: '/admin/shops', builder: _placeholderBuilder),
          GoRoute(path: '/admin/salespersons', builder: _placeholderBuilder),
          GoRoute(path: '/admin/templates', builder: _placeholderBuilder),
          GoRoute(path: '/admin/settings', builder: _placeholderBuilder),
        ],
      ),
    ],
  );

  /// Role-based redirect. Checks Supabase session's user_metadata.role
  /// on every navigation and routes unauthenticated / mismatched-role
  /// users to the correct entry point.
  static String? _redirect(BuildContext context, GoRouterState state) {
    const loginPaths = {'/login', '/salesperson/login', '/admin/login'};
    final location = state.matchedLocation;

    Session? session;
    try {
      session = Supabase.instance.client.auth.currentSession;
    } catch (_) {
      // Supabase not initialised yet (e.g. during early scaffolding) —
      // treat as unauthenticated rather than crash the router.
      session = null;
    }

    if (session == null) {
      return loginPaths.contains(location) ? null : '/login';
    }

    final role = session.user.userMetadata?['role'] as String?;
    if (!loginPaths.contains(location)) {
      return null;
    }

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

  static Widget _placeholderBuilder(BuildContext context, GoRouterState state) {
    return _PlaceholderScreen(routeName: state.matchedLocation);
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(routeName)),
    );
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
