import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/admin_dashboard_notifier.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  IconData _activityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.subscribed:
        return Icons.check_circle;
      case ActivityType.cancellationRequested:
        return Icons.warning_amber_rounded;
      case ActivityType.autopayFailed:
        return Icons.error;
      case ActivityType.shopAdded:
        return Icons.storefront;
      case ActivityType.bulkSent:
        return Icons.campaign;
    }
  }

  Color _activityColor(ActivityType type) {
    switch (type) {
      case ActivityType.subscribed:
        return AppColors.kGreen;
      case ActivityType.cancellationRequested:
        return AppColors.kWarning;
      case ActivityType.autopayFailed:
        return AppColors.kError;
      case ActivityType.shopAdded:
        return AppColors.kBlue;
      case ActivityType.bulkSent:
        return AppColors.kOrange;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminDashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (data) => ListView(
          padding: EdgeInsets.zero,
          children: [
            GradientHeader(
              type: GradientHeaderType.navy,
              leadingWidget: const Icon(Icons.menu, color: Colors.white),
              trailingWidget: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(color: AppColors.kOrange, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(data.adminName.isNotEmpty ? data.adminName[0] : '?', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
              title: 'Good morning, ${data.adminName}',
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: AppCard(
                      borderRadius: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('MONTHLY RECURRING REVENUE', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s8),
                          Text(Formatters.formatINR(data.mrr), style: AppTypography.displaySerif.copyWith(fontSize: 32)),
                          SizedBox(height: AppSpacing.s4),
                          Text('+${data.newShopsThisMonth} new shops this month', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kGreen)),
                          SizedBox(height: AppSpacing.s16),
                          const Divider(),
                          SizedBox(height: AppSpacing.s12),
                          Row(
                            children: [
                              Expanded(child: _StatCell(value: '${data.totalShops}', label: 'Total Shops')),
                              Expanded(child: _StatCell(value: '${data.activeShops}', label: 'Active Shops')),
                            ],
                          ),
                          SizedBox(height: AppSpacing.s16),
                          Row(
                            children: [
                              Expanded(child: _StatCell(value: '${data.activeSalespersons}', label: 'Salespersons')),
                              Expanded(
                                child: _StatCell(
                                  value: '${data.pendingIssues}',
                                  label: 'Pending Issues',
                                  valueColor: data.pendingIssues > 0 ? AppColors.kError : AppColors.kDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (data.pendingCancellations > 0)
                    _AlertCard(
                      color: AppColors.kWarning,
                      text: '${data.pendingCancellations} cancellation request(s) awaiting approval',
                      actionLabel: 'Review',
                      onTap: () => context.push('/admin/cancellations'),
                    ),
                  if (data.paymentFailedShops > 0)
                    _AlertCard(
                      color: AppColors.kError,
                      text: '${data.paymentFailedShops} shop(s) have failed AutoPay payments',
                      actionLabel: 'View',
                      onTap: () => context.push('/admin/shops'),
                    ),
                  if (data.templatesNeedingRenewal > 0)
                    _AlertCard(
                      color: AppColors.kOrange,
                      text: '${data.templatesNeedingRenewal} WhatsApp template(s) need renewal',
                      actionLabel: 'Manage',
                      onTap: () => context.push('/admin/templates'),
                    ),
                  if (data.newShopsToday > 0)
                    _AlertCard(
                      color: AppColors.kBlue,
                      text: '${data.newShopsToday} shops added today across all salespersons',
                    ),
                  SizedBox(height: AppSpacing.s16),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          label: 'Salespersons',
                          subLabel: '${data.activeSalespersons} active',
                          icon: Icons.groups_outlined,
                          backgroundColor: AppColors.kNavyCard,
                          onTap: () => context.push('/admin/salespersons'),
                        ),
                      ),
                      SizedBox(width: AppSpacing.s8),
                      Expanded(
                        child: _QuickActionCard(
                          label: 'All Shops',
                          subLabel: '${data.totalShops} total',
                          icon: Icons.storefront_outlined,
                          backgroundColor: AppColors.kNavyCard,
                          onTap: () => context.push('/admin/shops'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.s8),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          label: 'Templates',
                          subLabel: '7 active',
                          icon: Icons.article_outlined,
                          backgroundColor: AppColors.kOrange,
                          onTap: () => context.push('/admin/templates'),
                        ),
                      ),
                      SizedBox(width: AppSpacing.s8),
                      Expanded(
                        child: _QuickActionCard(
                          label: 'Revenue',
                          subLabel: '${Formatters.formatINR(data.mrr)}/mo',
                          icon: Icons.bar_chart_outlined,
                          backgroundColor: AppColors.kNavyCard,
                          onTap: () => context.push('/admin/revenue'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.s24),
                  Text('Recent Activity', style: AppTypography.labelSmall.copyWith(fontSize: 13)),
                  SizedBox(height: AppSpacing.s12),
                  for (final event in data.activity) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.s8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(_activityIcon(event.type), size: 16, color: _activityColor(event.type)),
                          SizedBox(width: AppSpacing.s12),
                          Expanded(child: Text(event.text, style: AppTypography.body.copyWith(fontSize: 13))),
                          Text(Formatters.formatRelativeTime(event.timestamp), style: AppTypography.caption.copyWith(fontSize: 11)),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                  SizedBox(height: AppSpacing.s24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label, this.valueColor});

  final String value;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.body.copyWith(fontSize: 22, fontWeight: FontWeight.w700, color: valueColor ?? AppColors.kDark)),
        SizedBox(height: AppSpacing.s4),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.color, required this.text, this.actionLabel, this.onTap});

  final Color color;
  final String text;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.s12),
      child: AppCard(
        leftBorderColor: color,
        onTap: onTap,
        child: Row(
          children: [
            Expanded(child: Text(text, style: AppTypography.body.copyWith(fontSize: 13))),
            if (actionLabel != null)
              Text(actionLabel!, style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kOrange, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
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
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(height: AppSpacing.s12),
            Text(label, style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
            SizedBox(height: AppSpacing.s4),
            Text(subLabel, style: AppTypography.caption.copyWith(fontSize: 10, color: Colors.white.withValues(alpha: 0.55))),
          ],
        ),
      ),
    );
  }
}
