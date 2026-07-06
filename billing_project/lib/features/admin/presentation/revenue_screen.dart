import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/plan_type.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/revenue_notifier.dart';

class RevenueScreen extends ConsumerWidget {
  const RevenueScreen({super.key});

  String _rangeLabel(RevenueRange range) {
    switch (range) {
      case RevenueRange.thisMonth:
        return 'This Month';
      case RevenueRange.lastMonth:
        return 'Last Month';
      case RevenueRange.last3Months:
        return 'Last 3 Months';
    }
  }

  Future<void> _pickRange(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final range in RevenueRange.values)
              ListTile(
                title: Text(_rangeLabel(range)),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ref.read(revenueProvider.notifier).setRange(range);
                },
              ),
          ],
        ),
      ),
    );
  }

  Color _planColor(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.basic:
        return AppColors.kDark;
      case SubscriptionPlan.pro:
        return const Color(0xFF7C3AED);
      case SubscriptionPlan.business:
        return AppColors.kOrange;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(revenueProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (data) {
          final maxPlanRevenue = SubscriptionPlan.values.map(data.revenueFor).fold(1.0, (a, b) => a > b ? a : b);
          final topupPacks = [
            ('Bill Starter', 12, 149.0 * 12),
            ('Bill Standard', 6, 399.0 * 6),
            ('Msg Starter', 9, 199.0 * 9),
            ('Msg Standard', 15, 449.0 * 15),
            ('Msg Bulk', 3, 1199.0 * 3),
          ];

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              GradientHeader(
                type: GradientHeaderType.navy,
                showBackButton: true,
                height: 130,
                title: 'Revenue Report',
                trailingWidget: GestureDetector(
                  onTap: () => _pickRange(context, ref),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s6),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: AppSpacing.rPill),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_rangeLabel(data.range), style: const TextStyle(fontSize: 12, color: Colors.white)),
                        const Icon(Icons.arrow_drop_down, size: 16, color: Colors.white),
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
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: AppCard(
                        borderRadius: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MONTHLY RECURRING REVENUE', style: AppTypography.labelSmall),
                            SizedBox(height: AppSpacing.s8),
                            Text(Formatters.formatINR(data.subscriptionRevenue), style: AppTypography.displaySerif.copyWith(fontSize: 32)),
                            SizedBox(height: AppSpacing.s4),
                            Text(
                              '${data.mrrDiff >= 0 ? '+' : ''}${Formatters.formatINR(data.mrrDiff)} (${data.mrrDiffPct >= 0 ? '+' : ''}${data.mrrDiffPct.toStringAsFixed(1)}%) vs last month',
                              style: AppTypography.body.copyWith(fontSize: 13, color: data.mrrDiff >= 0 ? AppColors.kGreen : AppColors.kError),
                            ),
                            SizedBox(height: AppSpacing.s16),
                            const Divider(),
                            SizedBox(height: AppSpacing.s12),
                            _StatLine(label: 'Subscription Revenue', value: Formatters.formatINR(data.subscriptionRevenue)),
                            _StatLine(label: 'Top-Up Revenue', value: Formatters.formatINR(data.topupRevenue)),
                            _StatLine(label: 'Total Revenue', value: Formatters.formatINR(data.totalRevenue), valueColor: AppColors.kOrange, bold: true),
                          ],
                        ),
                      ),
                    ),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PLAN BREAKDOWN', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s16),
                          for (final plan in SubscriptionPlan.values) ...[
                            _PlanBar(
                              plan: plan,
                              shopCount: data.shopCountFor(plan),
                              revenue: data.revenueFor(plan),
                              fraction: maxPlanRevenue == 0 ? 0 : data.revenueFor(plan) / maxPlanRevenue,
                              color: _planColor(plan),
                            ),
                            SizedBox(height: AppSpacing.s12),
                          ],
                          const Divider(),
                          SizedBox(height: AppSpacing.s8),
                          Text('Total: ${data.shops.length} shops · ${Formatters.formatINR(data.subscriptionRevenue)}/month', style: AppTypography.body.copyWith(fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CREDIT TOP-UPS', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          Text(Formatters.formatINR(data.topupRevenue), style: AppTypography.body.copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
                          SizedBox(height: AppSpacing.s4),
                          Text('${topupPacks.fold(0, (sum, p) => sum + p.$2.round())} top-up transactions', style: AppTypography.caption),
                          SizedBox(height: AppSpacing.s12),
                          for (final pack in topupPacks)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(pack.$1, style: AppTypography.body.copyWith(fontSize: 13)),
                                  Text('${pack.$2} sold', style: AppTypography.caption),
                                  Text(Formatters.formatINR(pack.$3), style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('PLATFORM COSTS (INTERNAL)', style: AppTypography.labelSmall),
                            ],
                          ),
                          SizedBox(height: AppSpacing.s4),
                          Text('Visible to Super Admin only', style: AppTypography.caption.copyWith(fontSize: 11)),
                          SizedBox(height: AppSpacing.s12),
                          _StatLine(label: 'AiSensy Platform Fee', value: Formatters.formatINR(data.aisensyFee)),
                          _StatLine(label: 'Meta Message Costs', value: '~${Formatters.formatINR(data.metaMessageCost)}'),
                          _StatLine(label: 'Razorpay Fees (2%)', value: '~${Formatters.formatINR(data.razorpayFees)}'),
                          const Divider(),
                          _StatLine(label: 'Estimated Total Cost', value: Formatters.formatINR(data.estimatedTotalCost)),
                          _StatLine(label: 'Estimated Net Revenue', value: Formatters.formatINR(data.netRevenue), valueColor: AppColors.kGreen, bold: true),
                          _StatLine(label: 'Estimated Margin', value: '${data.marginPct.toStringAsFixed(1)}%', bold: true),
                          SizedBox(height: AppSpacing.s8),
                          Text('* Message costs are estimates. Verify with AiSensy dashboard.', style: AppTypography.caption.copyWith(fontSize: 11)),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TOP SHOPS BY VALUE', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          for (var i = 0; i < data.topShopsByValue.length; i++)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
                              child: Row(
                                children: [
                                  SizedBox(width: 20, child: Text('${i + 1}', style: AppTypography.caption)),
                                  Expanded(child: Text(data.topShopsByValue[i].shopName, style: AppTypography.body.copyWith(fontSize: 13))),
                                  SizedBox(width: 60, child: Text(data.topShopsByValue[i].plan.name, style: AppTypography.caption)),
                                  Text(Formatters.formatINR(data.topShopsByValue[i].monthlyAmount), style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SALESPERSON PERFORMANCE', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          for (final person in data.salespersonsByRevenue)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text(person.name, style: AppTypography.body.copyWith(fontSize: 13))),
                                  Expanded(child: Text('${buildShopCount(data, person.name)} shops', style: AppTypography.caption)),
                                  Expanded(child: Text(Formatters.formatINR(data.revenueForSalesperson(person)), style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600))),
                                  Text('+${data.newShopsForSalesperson(person)} new', style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.kGreen)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PAYMENT HEALTH', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          _StatLine(label: 'Successful AutoPay', value: '${data.successfulAutopay}', valueColor: AppColors.kGreen),
                          _StatLine(label: 'Failed AutoPay', value: '${data.failedAutopay}', valueColor: data.failedAutopay > 0 ? AppColors.kError : AppColors.kMuted, bold: data.failedAutopay > 0),
                          _StatLine(label: 'Retry Successful', value: '0', valueColor: AppColors.kWarning),
                          _StatLine(label: 'Action Needed', value: '${data.failedAutopay}', valueColor: data.failedAutopay > 0 ? AppColors.kError : AppColors.kMuted, bold: data.failedAutopay > 0),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  int buildShopCount(RevenueState data, String salespersonName) => data.shops.where((s) => s.salespersonName == salespersonName).length;
}

class _StatLine extends StatelessWidget {
  const _StatLine({required this.label, required this.value, this.valueColor, this.bold = false});

  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kSecondary)),
          Text(value, style: AppTypography.body.copyWith(fontSize: 13, fontWeight: bold ? FontWeight.w700 : FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }
}

class _PlanBar extends StatelessWidget {
  const _PlanBar({required this.plan, required this.shopCount, required this.revenue, required this.fraction, required this.color});

  final SubscriptionPlan plan;
  final int shopCount;
  final double revenue;
  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${plan.name[0].toUpperCase()}${plan.name.substring(1)}: $shopCount shops · ${Formatters.formatINR(revenue)}', style: AppTypography.body.copyWith(fontSize: 13)),
        SizedBox(height: AppSpacing.s6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: fraction.clamp(0.0, 1.0), minHeight: 8, backgroundColor: AppColors.kBorderGray, valueColor: AlwaysStoppedAnimation(color)),
        ),
      ],
    );
  }
}
