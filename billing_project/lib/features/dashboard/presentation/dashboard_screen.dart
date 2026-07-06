import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/bottom_tab_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/info_banner.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_badge.dart';
import '../domain/dashboard_notifier.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _DashboardBody(data: data),
      ),
      bottomNavigationBar: AppBottomTabBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/dashboard');
            case 1:
              context.go('/new-bill');
            case 2:
              context.go('/customers');
            case 3:
              context.go('/settings');
          }
        },
        items: const [
          TabBarItem(icon: Icons.home_outlined, label: 'Home'),
          TabBarItem(icon: Icons.receipt_long_outlined, label: 'New Bill'),
          TabBarItem(icon: Icons.people_outline, label: 'Customers'),
          TabBarItem(icon: Icons.settings_outlined, label: 'Settings'),
        ],
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.data});

  final DashboardState data;

  Color get _creditColor {
    final pct = data.billCredits / data.billCreditsLimit;
    if (pct > 0.5) return AppColors.kGreen;
    if (pct > 0.2) return AppColors.kWarning;
    return AppColors.kError;
  }

  @override
  Widget build(BuildContext context) {
    final isLowCredit = data.billCredits / data.billCreditsLimit < 0.2;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GradientHeader(
          type: GradientHeaderType.purple,
          leadingWidget: const Icon(Icons.menu, color: Colors.white),
          trailingWidget: GestureDetector(
            onTap: () => context.go('/credits'),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.s12,
                vertical: AppSpacing.s6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppSpacing.rPill,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    size: 16,
                    color: AppColors.kWarning,
                  ),
                  SizedBox(width: AppSpacing.s6),
                  Text(
                    '${data.billCredits}',
                    style: AppTypography.body.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomOverlap: AppCard(
            borderRadius: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TODAY'S REVENUE", style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s8),
                Text(
                  Formatters.formatINR(data.todayRevenue),
                  style: AppTypography.displaySerif.copyWith(fontSize: 32),
                ),
                SizedBox(height: AppSpacing.s16),
                const Divider(height: 1, color: AppColors.kDivider),
                SizedBox(height: AppSpacing.s16),
                Row(
                  children: [
                    Expanded(
                      child: _StatColumn(
                        value: '${data.todayBillCount}',
                        label: 'Bills Today',
                        valueColor: AppColors.kDark,
                      ),
                    ),
                    Expanded(
                      child: _StatColumn(
                        value: '${data.billCredits}',
                        label: 'Bill Credits',
                        valueColor: _creditColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.s24),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLowCredit) ...[
                InfoBanner(
                  type: InfoBannerType.warning,
                  message:
                      'Only ${data.billCredits} bill credits left. Top up to keep sending.',
                  actionLabel: 'Buy Credits →',
                  onAction: () => context.go('/credits/topup'),
                ),
                SizedBox(height: AppSpacing.s16),
              ],
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      label: 'New Bill',
                      subLabel: 'Send PDF via WhatsApp',
                      icon: Icons.receipt_long_outlined,
                      backgroundColor: AppColors.kOrange,
                      onTap: () => context.go('/new-bill'),
                    ),
                  ),
                  SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: _QuickActionCard(
                      label: 'Bulk Message',
                      subLabel: '${data.msgCredits} credits',
                      icon: Icons.campaign_outlined,
                      backgroundColor: AppColors.kNavyCard,
                      onTap: () => context.go('/bulk-message'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.s8),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      label: 'Customers',
                      subLabel: 'View contacts',
                      icon: Icons.people_outline,
                      backgroundColor: AppColors.kNavyCard,
                      onTap: () => context.go('/customers'),
                    ),
                  ),
                  SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: _QuickActionCard(
                      label: 'Bill History',
                      subLabel: 'View all bills',
                      icon: Icons.history,
                      backgroundColor: AppColors.kNavyCard,
                      onTap: () => context.go('/bill-history'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.s24),
              SectionHeader(
                title: 'Recent Bills',
                actionLabel: 'View All',
                onAction: () => context.go('/bill-history'),
              ),
              SizedBox(height: AppSpacing.s12),
              if (data.recentBills.isEmpty)
                SizedBox(
                  height: 280,
                  child: EmptyState(
                    type: EmptyStateType.bills,
                    title: 'No bills sent today',
                    subtitle: 'Tap New Bill to get started',
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.recentBills.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: AppSpacing.s8),
                  itemBuilder: (context, index) {
                    final bill = data.recentBills[index];
                    return AppCard(
                      onTap: () => context.push('/bill/${bill.billId}'),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                        vertical: AppSpacing.s12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bill.customerName,
                                  style: AppTypography.body.copyWith(
                                    fontSize: 14,
                                    color: AppColors.kDark,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.s4),
                                Text(bill.sentAgo, style: AppTypography.caption),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                Formatters.formatINR(bill.total),
                                style: AppTypography.body.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.kDark,
                                ),
                              ),
                              SizedBox(height: AppSpacing.s4),
                              StatusBadge(
                                label: bill.status == 'sent' ? 'Sent' : 'Failed',
                                type: bill.status == 'sent'
                                    ? StatusBadgeType.active
                                    : StatusBadgeType.failed,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.body.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
        SizedBox(height: AppSpacing.s4),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.label,
    required this.subLabel,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  final String label;
  final String subLabel;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(height: AppSpacing.s12),
            Text(
              label,
              style: AppTypography.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: AppSpacing.s4),
            Text(
              subLabel,
              style: AppTypography.caption.copyWith(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
