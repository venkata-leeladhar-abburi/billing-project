import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/shop_model.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/plan_badge.dart';
import '../domain/salesperson_dashboard_notifier.dart';

class SalespersonDashboardScreen extends ConsumerWidget {
  const SalespersonDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(salespersonDashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _buildBody(context, data),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  Widget _buildBody(BuildContext context, SalespersonDashboardState data) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GradientHeader(
          type: GradientHeaderType.purple,
          leadingWidget: const Icon(Icons.menu, color: Colors.white),
          title: 'Good morning, ${data.salespersonName.split(' ').first}',
          trailingWidget: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(color: AppColors.kOrange, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              _initials(data.salespersonName),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -20),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            child: AppCard(
              borderRadius: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('YOUR SHOPS', style: AppTypography.labelSmall),
                  SizedBox(height: AppSpacing.s16),
                  Row(
                    children: [
                      Expanded(child: _StatCell(value: '${data.totalShops}', label: 'Total Shops')),
                      Expanded(child: _StatCell(value: '${data.activeToday}', label: 'Active Today')),
                    ],
                  ),
                  SizedBox(height: AppSpacing.s16),
                  Row(
                    children: [
                      Expanded(child: _StatCell(value: '${data.newThisMonth}', label: 'New This Month')),
                      Expanded(
                        child: _StatCell(
                          value: '${data.pendingSetup}',
                          label: 'Pending Setup',
                          valueColor: data.pendingSetup > 0 ? AppColors.kWarning : AppColors.kDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      label: 'Add New Shop',
                      subLabel: 'Onboard a shopkeeper',
                      icon: Icons.storefront_outlined,
                      backgroundColor: AppColors.kOrange,
                      onTap: () => context.push('/salesperson/shops/add/details'),
                    ),
                  ),
                  SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: _QuickActionCard(
                      label: 'All Shops',
                      subLabel: '${data.totalShops} shops',
                      icon: Icons.grid_view_outlined,
                      backgroundColor: AppColors.kNavyCard,
                      onTap: () => context.go('/salesperson/shops'),
                    ),
                  ),
                ],
              ),
              if (data.pendingCancellations > 0) ...[
                SizedBox(height: AppSpacing.s16),
                AppCard(
                  onTap: () => context.go('/salesperson/cancellations'),
                  backgroundColor: const Color(0xFFFEF2F2),
                  borderColor: const Color(0xFFFECACA),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.kError, size: 20),
                      SizedBox(width: AppSpacing.s12),
                      Expanded(
                        child: Text(
                          '${data.pendingCancellations} cancellation request(s) need your attention',
                          style: AppTypography.body.copyWith(fontSize: 13),
                        ),
                      ),
                      Text('Review →', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kOrange)),
                    ],
                  ),
                ),
              ],
              SizedBox(height: AppSpacing.s24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Shops', style: AppTypography.labelSmall.copyWith(fontSize: 13)),
                  GestureDetector(
                    onTap: () => context.go('/salesperson/shops'),
                    child: Text('View All →', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kOrange)),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.s12),
              if (data.shops.isEmpty)
                EmptyState(
                  type: EmptyStateType.shops,
                  title: 'No shops yet',
                  subtitle: 'Tap Add New Shop to onboard your first shopkeeper',
                  ctaLabel: 'Add New Shop',
                  onCtaTap: () => context.push('/salesperson/shops/add/details'),
                )
              else
                for (final shop in data.shops.take(5)) ...[
                  AppCard(
                    onTap: () => context.push('/salesperson/shops/${shop.id}'),
                    margin: EdgeInsets.only(bottom: AppSpacing.s8),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(color: AppColors.kOrangeLight, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Text(
                            _initials(shop.shopName),
                            style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.kOrange),
                          ),
                        ),
                        SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(shop.shopName, style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                              SizedBox(height: AppSpacing.s4),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.kOrangeLight, borderRadius: AppSpacing.rPill),
                                child: Text(
                                  shop.businessType,
                                  style: const TextStyle(fontSize: 10, color: AppColors.kOrange, fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(height: AppSpacing.s4),
                              Text(shop.phone, style: AppTypography.caption),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            PlanBadge(plan: shop.plan),
                            SizedBox(height: AppSpacing.s8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(color: shop.status.dotColor, shape: BoxShape.circle),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ],
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
