import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/models/plan_type.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_action_bar.dart';
import '../../../../shared/widgets/step_progress_bar.dart';
import '../../domain/add_shop_notifier.dart';

class _PlanInfo {
  const _PlanInfo({
    required this.plan,
    required this.name,
    required this.price,
    required this.features,
    required this.bestFor,
    required this.color,
  });

  final SubscriptionPlan plan;
  final String name;
  final int price;
  final List<String> features;
  final String bestFor;
  final Color color;
}

const _plans = [
  _PlanInfo(
    plan: SubscriptionPlan.basic,
    name: 'BASIC',
    price: 299,
    features: [
      '100 bill credits/month',
      '300 bulk msg credits/month',
      'Up to 500 customers',
      '3 months bill history',
      'In-app chat support',
    ],
    bestFor: 'Small kirana, grocery shops',
    color: AppColors.kDark,
  ),
  _PlanInfo(
    plan: SubscriptionPlan.pro,
    name: 'PRO',
    price: 599,
    features: [
      '300 bill credits/month',
      '800 bulk msg credits/month',
      'Up to 2,000 customers',
      '12 months bill history',
      'Priority support',
      'All business templates',
    ],
    bestFor: 'Clothing, electronics shops',
    color: Color(0xFF7C3AED),
  ),
  _PlanInfo(
    plan: SubscriptionPlan.business,
    name: 'BUSINESS',
    price: 999,
    features: [
      'Unlimited bill credits',
      '2,000 bulk msg credits/month',
      'Unlimited customers',
      'Unlimited bill history',
      'Dedicated support',
      'All templates + custom',
    ],
    bestFor: 'Steel, jewellery, large shops',
    color: AppColors.kOrange,
  ),
];

class Step3PlanScreen extends ConsumerWidget {
  const Step3PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(addShopProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.kDark),
          onPressed: () => context.pop(),
        ),
        title: Text('New Shop · Step 3 of 4', style: AppTypography.h3.copyWith(fontSize: 15)),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.s16),
        children: [
          StepProgressBar(
            stepLabels: const ['Details', 'Branding', 'Plan', 'AutoPay'],
            currentStep: 2,
            completedSteps: 2,
          ),
          SizedBox(height: AppSpacing.s16),
          Text('Choose the right plan for this shop.', style: AppTypography.body.copyWith(fontSize: 14, color: AppColors.kSecondary)),
          SizedBox(height: AppSpacing.s16),
          for (final plan in _plans) ...[
            _PlanCard(
              info: plan,
              isSelected: data.selectedPlan == plan.plan,
              onTap: () => ref.read(addShopProvider.notifier).selectPlan(plan.plan),
            ),
            SizedBox(height: AppSpacing.s12),
          ],
          AppCard(
            backgroundColor: AppColors.kBlueLight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: AppColors.kBlue, size: 20),
                SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Text(
                    "Based on this shop's business type (${data.businessType ?? '—'}), the "
                    "'${(data.businessType ?? 'default').toLowerCase()}_festival_offer' WhatsApp template will be auto-assigned.",
                    style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kBlue),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s48),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        secondaryLabel: data.selectedPlan == null ? 'Select a plan' : '${_plans.firstWhere((p) => p.plan == data.selectedPlan).name} · ₹${data.planAmount.toStringAsFixed(0)}/mo',
        ctaLabel: 'Next: AutoPay →',
        onCtaTap: data.selectedPlan != null ? () => context.push('/salesperson/shops/add/autopay') : null,
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.info, required this.isSelected, required this.onTap});

  final _PlanInfo info;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      borderColor: isSelected ? info.color : AppColors.kBorderGray,
      borderWidth: isSelected ? 2.0 : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (info.plan == SubscriptionPlan.pro)
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(bottom: AppSpacing.s8),
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s4),
                decoration: BoxDecoration(color: const Color(0xFF7C3AED), borderRadius: AppSpacing.rPill),
                child: const Text('MOST POPULAR', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(info.name, style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: info.color)),
              if (isSelected) Icon(Icons.check_circle, color: info.color, size: 20),
            ],
          ),
          SizedBox(height: AppSpacing.s4),
          Text('₹${info.price}/month', style: AppTypography.body.copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
          SizedBox(height: AppSpacing.s12),
          for (final feature in info.features)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 16, color: AppColors.kGreen),
                  SizedBox(width: AppSpacing.s8),
                  Expanded(child: Text(feature, style: AppTypography.body.copyWith(fontSize: 13))),
                ],
              ),
            ),
          SizedBox(height: AppSpacing.s8),
          Text('Best for: ${info.bestFor}', style: AppTypography.caption.copyWith(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
