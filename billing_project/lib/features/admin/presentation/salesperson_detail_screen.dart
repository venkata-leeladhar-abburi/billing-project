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
import '../domain/salesperson_detail_notifier.dart';

class SalespersonDetailScreen extends ConsumerWidget {
  const SalespersonDetailScreen({required this.salespersonId, super.key});

  final String salespersonId;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  Future<void> _confirmDeactivate(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmBottomSheet.show(
      context,
      title: 'Deactivate this account?',
      body: 'Deactivating will not affect their shops — Super Admin takes over management.',
      confirmLabel: 'Deactivate',
      isDestructive: true,
    );
    if (confirmed == true) {
      await ref.read(salespersonDetailProvider(salespersonId).notifier).deactivate();
    }
  }

  Future<void> _resetPassword(BuildContext context) async {
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
                Text('Reset Password', style: AppTypography.h3.copyWith(fontSize: 16)),
                SizedBox(height: AppSpacing.s16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Temporary Password',
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
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset (simulated)')));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.kOrange, minimumSize: const Size.fromHeight(48)),
                    child: const Text('Set Password', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(salespersonDetailProvider(salespersonId));

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (data) {
          final person = data.salesperson;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              GradientHeader(
                type: GradientHeaderType.orange,
                showBackButton: true,
                height: 140,
                title: person.name,
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
                            child: Text(_initials(person.name), style: AppTypography.h2.copyWith(color: AppColors.kOrange)),
                          ),
                          SizedBox(height: AppSpacing.s12),
                          Text(person.name, style: AppTypography.h3.copyWith(fontSize: 18)),
                          SizedBox(height: AppSpacing.s4),
                          Text(person.phone, style: AppTypography.caption),
                          SizedBox(height: AppSpacing.s12),
                          Wrap(
                            spacing: AppSpacing.s8,
                            alignment: WrapAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s4),
                                decoration: BoxDecoration(color: AppColors.kOrangeLight, borderRadius: AppSpacing.rPill),
                                child: Text(person.city, style: AppTypography.caption.copyWith(fontSize: 11, color: AppColors.kOrange, fontWeight: FontWeight.w600)),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s4),
                                decoration: BoxDecoration(
                                  color: person.isActive ? AppColors.kGreenLight : const Color(0xFFFEF2F2),
                                  borderRadius: AppSpacing.rPill,
                                ),
                                child: Text(
                                  person.isActive ? 'Active' : 'Inactive',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: person.isActive ? AppColors.kGreen : AppColors.kError),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.s8),
                          Text('Member since: ${Formatters.formatDate(person.addedDate)}', style: AppTypography.caption.copyWith(fontSize: 11)),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PERFORMANCE', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s16),
                          Row(
                            children: [
                              Expanded(child: _StatCell(value: '${data.shops.length}', label: 'Total Shops')),
                              Expanded(child: _StatCell(value: Formatters.formatINR(data.revenueGenerated), label: 'Revenue Gen.')),
                            ],
                          ),
                          SizedBox(height: AppSpacing.s16),
                          Row(
                            children: [
                              Expanded(child: _StatCell(value: '${data.activeShops}', label: 'Active Shops')),
                              Expanded(child: _StatCell(value: '${data.newThisMonth}', label: 'This Month')),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('SHOPS (${data.shops.length})', style: AppTypography.labelSmall),
                              if (data.shops.length > 5)
                                GestureDetector(
                                  onTap: () => context.push('/admin/shops'),
                                  child: Text('View All ${data.shops.length} Shops →', style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kOrange)),
                                ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.s12),
                          for (final shop in data.shops.take(5)) ...[
                            _ShopRow(shop: shop, onTap: () => context.push('/admin/shops/${shop.id}')),
                            if (shop != data.shops.take(5).last) const Divider(height: 16),
                          ],
                          if (data.shops.isEmpty) Text('No shops yet', style: AppTypography.caption),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ACCOUNT MANAGEMENT', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          _ActionRow(label: 'Reset Password', onTap: () => _resetPassword(context)),
                          if (person.isActive)
                            _ActionRow(label: 'Deactivate Account', textColor: AppColors.kError, onTap: () => _confirmDeactivate(context, ref))
                          else
                            _ActionRow(
                              label: 'Reactivate Account',
                              textColor: AppColors.kGreen,
                              onTap: () => ref.read(salespersonDetailProvider(salespersonId).notifier).reactivate(),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Text('Activity timeline coming soon', textAlign: TextAlign.center, style: AppTypography.body.copyWith(color: AppColors.kMuted)),
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

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.body.copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
        SizedBox(height: AppSpacing.s4),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}

class _ShopRow extends StatelessWidget {
  const _ShopRow({required this.shop, required this.onTap});

  final ShopModel shop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shop.shopName, style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
                SizedBox(height: AppSpacing.s4),
                Text(shop.businessType, style: AppTypography.caption),
              ],
            ),
          ),
          PlanBadge(plan: shop.plan),
          SizedBox(width: AppSpacing.s8),
          Container(width: 8, height: 8, decoration: BoxDecoration(color: shop.status.dotColor, shape: BoxShape.circle)),
        ],
      ),
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
