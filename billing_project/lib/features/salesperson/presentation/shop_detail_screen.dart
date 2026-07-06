import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/shop_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/confirm_bottom_sheet.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/plan_badge.dart';
import '../../../shared/widgets/status_badge.dart';
import '../domain/shop_detail_notifier.dart';

class ShopDetailScreen extends ConsumerWidget {
  const ShopDetailScreen({required this.shopId, super.key});

  final String shopId;

  StatusBadgeType _statusType(ShopStatus status) {
    switch (status) {
      case ShopStatus.active:
        return StatusBadgeType.active;
      case ShopStatus.pendingSetup:
        return StatusBadgeType.pending;
      case ShopStatus.suspended:
        return StatusBadgeType.suspended;
    }
  }

  String _statusLabel(ShopStatus status) {
    switch (status) {
      case ShopStatus.active:
        return 'Active';
      case ShopStatus.pendingSetup:
        return 'Pending Setup';
      case ShopStatus.suspended:
        return 'Suspended';
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    return parts.first[0].toUpperCase();
  }

  // TODO: replace with real GET /shops/:shopId/payments call when backend ready
  List<(String, String)> _mockBillingHistory(ShopModel shop) {
    final base = shop.nextBillingDate ?? DateTime.now();
    return [
      (Formatters.formatDate(DateTime(base.year, base.month - 1, 1)), 'Paid ✓'),
      (Formatters.formatDate(DateTime(base.year, base.month - 2, 1)), 'Paid ✓'),
      (Formatters.formatDate(DateTime(base.year, base.month - 3, 1)), shop.status == ShopStatus.suspended ? 'Failed ✗' : 'Paid ✓'),
    ];
  }

  Future<void> _confirmSuspend(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmBottomSheet.show(
      context,
      title: 'Suspend this shop?',
      body: 'The shop owner will lose access immediately. This can be reversed by Super Admin.',
      confirmLabel: 'Suspend',
      isDestructive: true,
    );
    if (confirmed == true) {
      await ref.read(shopDetailProvider(shopId).notifier).suspendShop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shopDetailProvider(shopId));

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load shop: $e')),
        data: (shop) {
          final billPct = shop.billCreditsLimit == 0 ? 0.0 : (shop.billCreditsUsed / shop.billCreditsLimit).clamp(0.0, 1.0);
          final msgPct = shop.msgCreditsLimit == 0 ? 0.0 : (shop.msgCreditsUsed / shop.msgCreditsLimit).clamp(0.0, 1.0);

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              GradientHeader(
                type: GradientHeaderType.orange,
                showBackButton: true,
                height: 140,
                trailingWidget: IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  onPressed: () => context.push('/salesperson/shops/$shopId/edit'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCard(
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(color: AppColors.kOrangeLight, shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: Text(
                              _initials(shop.shopName),
                              style: AppTypography.h2.copyWith(color: AppColors.kOrange),
                            ),
                          ),
                          SizedBox(height: AppSpacing.s12),
                          Text(shop.shopName, style: AppTypography.h3),
                          SizedBox(height: AppSpacing.s4),
                          Text('${shop.ownerName} · ${shop.businessType}', style: AppTypography.caption),
                          SizedBox(height: AppSpacing.s12),
                          Wrap(
                            spacing: AppSpacing.s8,
                            alignment: WrapAlignment.center,
                            children: [
                              StatusBadge(label: _statusLabel(shop.status), type: _statusType(shop.status)),
                              PlanBadge(plan: shop.plan),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PLAN & BILLING', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          _DetailRow(label: 'Monthly Amount', value: Formatters.formatINR(shop.monthlyAmount)),
                          _DetailRow(
                            label: 'AutoPay Status',
                            value: shop.autopayStatus == AutoPayStatus.active ? 'Active ✓' : (shop.autopayStatus == AutoPayStatus.pending ? 'Pending' : 'Failed'),
                            valueColor: shop.autopayStatus == AutoPayStatus.active ? AppColors.kGreen : (shop.autopayStatus == AutoPayStatus.pending ? AppColors.kWarning : AppColors.kError),
                          ),
                          if (shop.nextBillingDate != null)
                            _DetailRow(label: 'Next Billing', value: Formatters.formatDate(shop.nextBillingDate!)),
                          _DetailRow(label: 'WhatsApp Template', value: shop.templateName),
                          SizedBox(height: AppSpacing.s8),
                          Text('BILLING HISTORY', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                          SizedBox(height: AppSpacing.s8),
                          for (final payment in _mockBillingHistory(shop))
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(payment.$1, style: AppTypography.caption),
                                  Text(
                                    '${Formatters.formatINR(shop.monthlyAmount)} · ${payment.$2}',
                                    style: AppTypography.body.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: payment.$2 == 'Paid ✓' ? AppColors.kGreen : AppColors.kError,
                                    ),
                                  ),
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
                          Text('USAGE THIS MONTH', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          _UsageBar(label: 'Bill Credits', used: shop.billCreditsUsed, limit: shop.billCreditsLimit, pct: billPct),
                          SizedBox(height: AppSpacing.s12),
                          _UsageBar(label: 'Message Credits', used: shop.msgCreditsUsed, limit: shop.msgCreditsLimit, pct: msgPct),
                          SizedBox(height: AppSpacing.s12),
                          _DetailRow(
                            label: 'Customers',
                            value: shop.customerLimit == null ? '${shop.customerCount} (unlimited)' : '${shop.customerCount} / ${shop.customerLimit}',
                          ),
                          _DetailRow(label: 'Bills Sent', value: '${shop.billsSentThisMonth}'),
                          if (shop.lastActiveAt != null)
                            _DetailRow(label: 'Last Active', value: Formatters.formatRelativeTime(shop.lastActiveAt!)),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SHOP DETAILS', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          _DetailRow(label: 'Phone', value: shop.phone),
                          _DetailRow(label: 'WhatsApp', value: shop.whatsappNumber),
                          _DetailRow(label: 'Address', value: '${shop.address}, ${shop.city}, ${shop.state} - ${shop.pinCode}'),
                          _DetailRow(label: 'GST Number', value: shop.gstNumber ?? 'Not provided'),
                          if (shop.addedDate != null)
                            _DetailRow(
                              label: 'Added By',
                              value: '${shop.salespersonName ?? '—'} on ${Formatters.formatDate(shop.addedDate!)}',
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      borderColor: const Color(0xFFFECACA),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DANGER ZONE', style: AppTypography.labelSmall.copyWith(color: AppColors.kError)),
                          SizedBox(height: AppSpacing.s12),
                          if (shop.status != ShopStatus.suspended)
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _confirmSuspend(context, ref),
                                icon: const Icon(Icons.block, color: AppColors.kError, size: 18),
                                label: const Text('Suspend Shop', style: TextStyle(color: AppColors.kError)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFFECACA)),
                                  minimumSize: const Size.fromHeight(48),
                                ),
                              ),
                            )
                          else
                            Text('This shop is currently suspended.', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kError)),
                          SizedBox(height: AppSpacing.s8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => context.push('/salesperson/cancellations'),
                              icon: const Icon(Icons.receipt_long_outlined, size: 18),
                              label: const Text('View Cancellation Requests'),
                              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                            ),
                          ),
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
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption),
          SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _UsageBar extends StatelessWidget {
  const _UsageBar({required this.label, required this.used, required this.limit, required this.pct});

  final String label;
  final int used;
  final int limit;
  final double pct;

  Color get _barColor {
    if (pct >= 0.8) return AppColors.kError;
    if (pct >= 0.5) return AppColors.kWarning;
    return AppColors.kGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.body.copyWith(fontSize: 13)),
            Text(
              limit >= 99999 ? '$used / Unlimited' : '$used / $limit',
              style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.s6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: limit >= 99999 ? 0.1 : pct,
            minHeight: 6,
            backgroundColor: AppColors.kBorderGray,
            valueColor: AlwaysStoppedAnimation(_barColor),
          ),
        ),
      ],
    );
  }
}
