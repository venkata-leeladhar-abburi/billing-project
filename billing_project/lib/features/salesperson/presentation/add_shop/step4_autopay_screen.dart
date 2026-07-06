import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/models/plan_type.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_action_bar.dart';
import '../../../../shared/widgets/input_field.dart';
import '../../../../shared/widgets/step_progress_bar.dart';
import '../../domain/add_shop_notifier.dart';

class Step4AutoPayScreen extends ConsumerStatefulWidget {
  const Step4AutoPayScreen({super.key});

  @override
  ConsumerState<Step4AutoPayScreen> createState() => _Step4AutoPayScreenState();
}

class _Step4AutoPayScreenState extends ConsumerState<Step4AutoPayScreen> {
  final _upiController = TextEditingController();

  @override
  void dispose() {
    _upiController.dispose();
    super.dispose();
  }

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

  Future<void> _startMandate() async {
    ref.read(addShopProvider.notifier).setUpiId(_upiController.text.trim());
    await ref.read(addShopProvider.notifier).createAutoPayMandate();
    if (mounted) {
      final newId = ref.read(addShopProvider).newShopId;
      context.go('/salesperson/shops/add/success', extra: newId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(addShopProvider);
    final isBusy = data.mandateStatus == MandateStatus.sending || data.mandateStatus == MandateStatus.waitingApproval;
    final isValidUpi = RegExp(r'^[\w.\-]{2,}@[a-zA-Z]{2,}$').hasMatch(_upiController.text.trim());

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: !isBusy,
        leading: isBusy
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.kDark),
                onPressed: () => context.pop(),
              ),
        title: Text('New Shop · Step 4 of 4', style: AppTypography.h3.copyWith(fontSize: 15)),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.s16),
        children: [
          StepProgressBar(
            stepLabels: const ['Details', 'Branding', 'Plan', 'AutoPay'],
            currentStep: 3,
            completedSteps: 3,
          ),
          SizedBox(height: AppSpacing.s24),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PLAN SUMMARY', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_planName(data.selectedPlan)} Plan', style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
                    Text('₹${data.planAmount.toStringAsFixed(0)}/mo', style: AppTypography.body.copyWith(fontWeight: FontWeight.w700, color: AppColors.kOrange)),
                  ],
                ),
                SizedBox(height: AppSpacing.s4),
                Text('Billed monthly via UPI AutoPay', style: AppTypography.caption),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s16),
          if (data.mandateStatus == MandateStatus.notStarted || data.mandateStatus == MandateStatus.failed) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SET UP UPI AUTOPAY', style: AppTypography.labelSmall),
                  SizedBox(height: AppSpacing.s12),
                  Text(
                    'Enter the shop owner\'s UPI ID to set up an automatic monthly mandate. The owner will receive an approval request in their UPI app.',
                    style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kSecondary),
                  ),
                  SizedBox(height: AppSpacing.s16),
                  InputField(
                    label: 'UPI ID',
                    isRequired: true,
                    controller: _upiController,
                    placeholder: 'ownername@upi',
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
            if (data.mandateStatus == MandateStatus.failed) ...[
              SizedBox(height: AppSpacing.s16),
              AppCard(
                backgroundColor: const Color(0xFFFEE2E2),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.kError, size: 20),
                    SizedBox(width: AppSpacing.s12),
                    Expanded(child: Text('Mandate request failed. Please try again.', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kError))),
                  ],
                ),
              ),
            ],
          ] else ...[
            SizedBox(height: AppSpacing.s24),
            AppCard(
              child: Column(
                children: [
                  SizedBox(height: AppSpacing.s16),
                  const SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(strokeWidth: 4, color: AppColors.kOrange),
                  ),
                  SizedBox(height: AppSpacing.s16),
                  Text(
                    data.mandateStatus == MandateStatus.sending ? 'Sending mandate request...' : 'Waiting for owner approval...',
                    style: AppTypography.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: AppSpacing.s8),
                  Text(
                    data.mandateStatus == MandateStatus.sending
                        ? 'Setting up the AutoPay mandate on ${data.upiId}'
                        : 'Ask the shop owner to check their UPI app and approve the mandate.',
                    textAlign: TextAlign.center,
                    style: AppTypography.caption,
                  ),
                  SizedBox(height: AppSpacing.s16),
                ],
              ),
            ),
          ],
          SizedBox(height: AppSpacing.s16),
          AppCard(
            backgroundColor: AppColors.kBlueLight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: AppColors.kBlue, size: 20),
                SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Text(
                    'The shop owner cannot cancel AutoPay themselves. They must submit a cancellation request for Super Admin review.',
                    style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kBlue),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s48),
        ],
      ),
      bottomNavigationBar: isBusy
          ? null
          : BottomActionBar(
              secondaryLabel: 'Step 4 of 4',
              ctaLabel: 'Create AutoPay Mandate',
              onCtaTap: isValidUpi ? _startMandate : null,
            ),
    );
  }
}
