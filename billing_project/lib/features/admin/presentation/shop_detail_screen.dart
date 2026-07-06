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
import '../domain/admin_mock_salespersons.dart';
import '../domain/admin_shop_detail_notifier.dart';

class AdminShopDetailScreen extends ConsumerWidget {
  const AdminShopDetailScreen({required this.shopId, super.key});

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

  Future<void> _changePlan(BuildContext context, WidgetRef ref, ShopModel shop) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final plan in SubscriptionPlan.values)
              ListTile(
                title: PlanBadge(plan: plan),
                trailing: shop.plan == plan ? const Icon(Icons.check, color: AppColors.kOrange) : null,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ref.read(adminShopDetailProvider(shopId).notifier).changePlan(plan);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCredits(BuildContext context, WidgetRef ref, {required bool isBillCredits}) async {
    final controller = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.s16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add ${isBillCredits ? 'Bill' : 'Message'} Credits', style: AppTypography.h3.copyWith(fontSize: 16)),
                SizedBox(height: AppSpacing.s16),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    filled: true,
                    fillColor: AppColors.kBgPage,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(height: AppSpacing.s16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final amount = int.tryParse(controller.text.trim()) ?? 0;
                      Navigator.of(sheetContext).pop();
                      if (amount > 0) {
                        ref.read(adminShopDetailProvider(shopId).notifier).addCredits(isBillCredits: isBillCredits, amount: amount);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.kOrange, minimumSize: const Size.fromHeight(48)),
                    child: const Text('Add Credits', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _reassignSalesperson(BuildContext context, WidgetRef ref) async {
    final people = buildMockSalespersons();
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final person in people)
              ListTile(
                title: Text(person.name),
                subtitle: Text(person.city),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ref.read(adminShopDetailProvider(shopId).notifier).reassignSalesperson(person.name);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSuspend(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmBottomSheet.show(
      context,
      title: 'Suspend this shop?',
      body: 'The shop owner will lose access immediately.',
      confirmLabel: 'Suspend',
      isDestructive: true,
    );
    if (confirmed == true) await ref.read(adminShopDetailProvider(shopId).notifier).suspend();
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, String shopName) async {
    final controller = TextEditingController();
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.s16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delete this shop?', style: AppTypography.h3.copyWith(fontSize: 16, color: AppColors.kError)),
                SizedBox(height: AppSpacing.s8),
                Text('This cannot be undone. Type "$shopName" to confirm.', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kSecondary)),
                SizedBox(height: AppSpacing.s16),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.kBgPage,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(height: AppSpacing.s16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.text.trim() == shopName ? () => Navigator.of(sheetContext).pop(true) : null,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.kError, minimumSize: const Size.fromHeight(48)),
                    child: const Text('Delete Shop', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(adminShopDetailProvider(shopId).notifier).delete();
      if (context.mounted) context.go('/admin/shops');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminShopDetailProvider(shopId));

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
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
                title: shop.shopName,
                trailingWidget: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    if (value == 'edit') context.push('/admin/shops/$shopId');
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit Shop')),
                  ],
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
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(color: AppColors.kOrangeLight, shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: Text(_initials(shop.shopName), style: AppTypography.h2.copyWith(color: AppColors.kOrange)),
                          ),
                          SizedBox(height: AppSpacing.s12),
                          Text(shop.shopName, style: AppTypography.h3.copyWith(fontSize: 18)),
                          SizedBox(height: AppSpacing.s4),
                          Text('${shop.ownerName} · ${shop.phone}', style: AppTypography.caption),
                          SizedBox(height: AppSpacing.s8),
                          GestureDetector(
                            onTap: () {
                              final people = buildMockSalespersons();
                              final match = people.where((p) => p.name == shop.salespersonName);
                              if (match.isNotEmpty) context.push('/admin/salespersons/${match.first.id}');
                            },
                            child: Text('Managed by: ${shop.salespersonName ?? '—'}', style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kBlue)),
                          ),
                          SizedBox(height: AppSpacing.s12),
                          StatusBadge(label: _statusLabel(shop.status), type: _statusType(shop.status)),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SUBSCRIPTION & BILLING', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [PlanBadge(plan: shop.plan), Text(Formatters.formatINR(shop.monthlyAmount), style: AppTypography.body.copyWith(fontWeight: FontWeight.w700))]),
                          SizedBox(height: AppSpacing.s12),
                          _DetailRow(
                            label: 'AutoPay',
                            value: shop.autopayStatus == AutoPayStatus.active ? 'Active ✓' : (shop.autopayStatus == AutoPayStatus.pending ? 'Pending' : 'Failed'),
                            valueColor: shop.autopayStatus == AutoPayStatus.active ? AppColors.kGreen : (shop.autopayStatus == AutoPayStatus.pending ? AppColors.kWarning : AppColors.kError),
                          ),
                          _DetailRow(label: 'UPI ID', value: 'xxxx@okhdfcbank'),
                          if (shop.nextBillingDate != null) _DetailRow(label: 'Next Billing', value: Formatters.formatDate(shop.nextBillingDate!)),
                          if (shop.addedDate != null) _DetailRow(label: 'Started', value: Formatters.formatDate(shop.addedDate!)),
                          SizedBox(height: AppSpacing.s8),
                          Text('BILLING HISTORY', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                          SizedBox(height: AppSpacing.s8),
                          for (var m = 1; m <= 3; m++)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(Formatters.formatDate(DateTime((shop.nextBillingDate ?? DateTime.now()).year, (shop.nextBillingDate ?? DateTime.now()).month - m, 1)), style: AppTypography.caption),
                                  Text('${Formatters.formatINR(shop.monthlyAmount)} · Paid ✓', style: AppTypography.body.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.kGreen)),
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
                          Text('PLATFORM USAGE', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          _UsageBar(label: 'Bill Credits', used: shop.billCreditsUsed, limit: shop.billCreditsLimit, pct: billPct),
                          SizedBox(height: AppSpacing.s12),
                          _UsageBar(label: 'Message Credits', used: shop.msgCreditsUsed, limit: shop.msgCreditsLimit, pct: msgPct),
                          SizedBox(height: AppSpacing.s12),
                          _DetailRow(label: 'Customers', value: shop.customerLimit == null ? '${shop.customerCount} (unlimited)' : '${shop.customerCount} / ${shop.customerLimit}'),
                          _DetailRow(label: 'Total Bills Sent', value: '${shop.billsSentThisMonth}'),
                          _DetailRow(label: 'Total Bulk Campaigns', value: '3'),
                          if (shop.lastActiveAt != null) _DetailRow(label: 'Last Active', value: Formatters.formatRelativeTime(shop.lastActiveAt!)),
                          _DetailRow(label: 'WhatsApp Messages Sent', value: '${shop.billsSentThisMonth * 3}'),
                          _DetailRow(label: 'AiSensy Cost This Month', value: '~${Formatters.formatINR(shop.billsSentThisMonth * 0.12)}'),
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
                          _DetailRow(label: 'Address', value: '${shop.address}, ${shop.city}, ${shop.state} - ${shop.pinCode}'),
                          _DetailRow(label: 'GST Number', value: shop.gstNumber ?? 'Not provided'),
                          _DetailRow(label: 'WhatsApp', value: shop.whatsappNumber),
                          _DetailRow(label: 'Business Type', value: shop.businessType),
                          _DetailRow(label: 'Template', value: shop.templateName),
                          _DetailRow(label: 'App Login Number', value: shop.phone),
                          if (shop.addedDate != null) _DetailRow(label: 'Date Onboarded', value: Formatters.formatDate(shop.addedDate!)),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ADMIN ACTIONS', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s8),
                          _ActionRow(label: 'Change Plan', onTap: () => _changePlan(context, ref, shop)),
                          _ActionRow(label: 'Change Assigned Template', onTap: () => context.push('/admin/templates')),
                          _ActionRow(label: 'Add Bill Credits Manually', onTap: () => _addCredits(context, ref, isBillCredits: true)),
                          _ActionRow(label: 'Add Msg Credits Manually', onTap: () => _addCredits(context, ref, isBillCredits: false)),
                          _ActionRow(label: 'Reset Shopkeeper Password', onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset (simulated)')));
                          }),
                          _ActionRow(label: 'Reassign Salesperson', onTap: () => _reassignSalesperson(context, ref)),
                          if (shop.status != ShopStatus.suspended)
                            _ActionRow(label: 'Suspend Shop', textColor: AppColors.kError, onTap: () => _confirmSuspend(context, ref))
                          else
                            _ActionRow(label: 'Reactivate Shop', textColor: AppColors.kGreen, onTap: () => ref.read(adminShopDetailProvider(shopId).notifier).reactivate()),
                          _ActionRow(label: 'Delete Shop', textColor: AppColors.kError, onTap: () => _confirmDelete(context, ref, shop.shopName)),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CANCELLATION HISTORY', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          Text('No requests', style: AppTypography.body.copyWith(color: AppColors.kMuted)),
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
          Expanded(child: Text(value, textAlign: TextAlign.right, style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor))),
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
            Text(limit >= 99999 ? '$used / Unlimited' : '$used / $limit', style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        SizedBox(height: AppSpacing.s6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: limit >= 99999 ? 0.1 : pct, minHeight: 6, backgroundColor: AppColors.kBorderGray, valueColor: AlwaysStoppedAnimation(_barColor)),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.label, required this.onTap, this.textColor});

  final String label;
  final VoidCallback onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.s8),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTypography.body.copyWith(fontSize: 14, color: textColor ?? AppColors.kDark))),
            Icon(Icons.chevron_right, size: 18, color: textColor ?? AppColors.kMuted),
          ],
        ),
      ),
    );
  }
}
