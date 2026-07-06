import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/models/plan_type.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../domain/add_shop_notifier.dart';

class AddShopSuccessScreen extends ConsumerWidget {
  const AddShopSuccessScreen({super.key, this.shopId});

  final String? shopId;

  String _planName(SubscriptionPlan? plan) {
    switch (plan) {
      case SubscriptionPlan.basic:
        return 'Basic';
      case SubscriptionPlan.pro:
        return 'Pro';
      case SubscriptionPlan.business:
        return 'Business';
      case null:
        return '—';
    }
  }

  void _backToDashboard(WidgetRef ref, BuildContext context) {
    ref.read(addShopProvider.notifier).reset();
    context.go('/salesperson/dashboard');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(addShopProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToDashboard(ref, context);
      },
      child: Scaffold(
        backgroundColor: AppColors.kBgCard,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(AppSpacing.s16),
            children: [
              SizedBox(height: AppSpacing.s32),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: AppColors.kGreen, size: 52),
                ),
              ),
              SizedBox(height: AppSpacing.s24),
              Text('Shop Added!', textAlign: TextAlign.center, style: AppTypography.h1Serif.copyWith(fontSize: 28)),
              SizedBox(height: AppSpacing.s8),
              Text(
                '${data.shopName} is now live on ${AppStrings.appName}.',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(fontSize: 14, color: AppColors.kSecondary),
              ),
              SizedBox(height: AppSpacing.s24),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SHOP SUMMARY', style: AppTypography.labelSmall),
                    SizedBox(height: AppSpacing.s12),
                    _SummaryRow(label: 'Shop Name', value: data.shopName),
                    _SummaryRow(label: 'Owner', value: data.ownerName),
                    _SummaryRow(label: 'Business Type', value: data.businessType ?? '—'),
                    _SummaryRow(label: 'Plan', value: '${_planName(data.selectedPlan)} · ₹${data.planAmount.toStringAsFixed(0)}/mo'),
                    _SummaryRow(label: 'AutoPay', value: 'Active ✓', valueColor: AppColors.kGreen),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s16),
              AppCard(
                backgroundColor: AppColors.kBlueLight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.kBlue, size: 20),
                    SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Login credentials sent', style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.kBlue)),
                          SizedBox(height: AppSpacing.s4),
                          Text(
                            'The shopkeeper will receive their login details via WhatsApp on +91 ${data.ownerMobile}. They can log in immediately.',
                            style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kBlue),
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
                  children: const [
                    _CheckItem(text: 'Shop created'),
                    _CheckItem(text: 'AutoPay set up'),
                    _CheckItem(text: 'Template assigned'),
                    _CheckItem(text: 'Credentials sent'),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s24),
              PrimaryButton(
                label: 'Add Another Shop',
                onTap: () {
                  ref.read(addShopProvider.notifier).reset();
                  context.go('/salesperson/shops/add/details');
                },
              ),
              SizedBox(height: AppSpacing.s12),
              SecondaryButton(
                label: 'View This Shop',
                onTap: () {
                  ref.read(addShopProvider.notifier).reset();
                  if (shopId != null) {
                    context.go('/salesperson/shops/$shopId');
                  } else {
                    context.go('/salesperson/shops');
                  }
                },
              ),
              SizedBox(height: AppSpacing.s12),
              Center(
                child: TextButton(
                  onPressed: () => _backToDashboard(ref, context),
                  child: Text('Back to Dashboard', style: AppTypography.body.copyWith(color: AppColors.kOrange)),
                ),
              ),
              SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption),
          Text(value, style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  const _CheckItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: AppColors.kGreen),
          SizedBox(width: AppSpacing.s8),
          Expanded(child: Text(text, style: AppTypography.body.copyWith(fontSize: 13))),
        ],
      ),
    );
  }
}
