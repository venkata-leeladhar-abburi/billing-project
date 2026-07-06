import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/bottom_action_bar.dart';
import '../../../shared/widgets/info_banner.dart';
import '../domain/cancel_request_notifier.dart';

const _reasonLabels = {
  CancelReason.noLongerNeeded: 'No longer need the service',
  CancelReason.tooExpensive: 'Too expensive',
  CancelReason.switchingApp: 'Switching to another app',
  CancelReason.technicalIssues: 'Technical issues',
  CancelReason.other: 'Other',
};

class CancelRequestScreen extends ConsumerStatefulWidget {
  const CancelRequestScreen({super.key});

  @override
  ConsumerState<CancelRequestScreen> createState() => _CancelRequestScreenState();
}

class _CancelRequestScreenState extends ConsumerState<CancelRequestScreen> {
  final _customReasonController = TextEditingController();

  @override
  void dispose() {
    _customReasonController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    await ref.read(cancelRequestProvider.notifier).submit();
    if (!mounted) return;
    final requestId = ref.read(cancelRequestProvider).value?.requestId;
    if (requestId != null) context.push('/settings/cancel-confirm');
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(cancelRequestProvider);
    final data = asyncState.value ?? const CancelRequestState();

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
        title: Text('Cancel AutoPay', style: AppTypography.h3.copyWith(fontSize: 17)),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.s16),
        children: [
          const InfoBanner(
            type: InfoBannerType.warning,
            message: 'Your AutoPay cannot be cancelled directly. Submit a request and '
                'our team will process it within 24 hours.',
          ),
          SizedBox(height: AppSpacing.s16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pro Plan · ₹599/month', style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                SizedBox(height: AppSpacing.s4),
                Text('Next billing: 1 Aug 2026', style: AppTypography.caption),
                SizedBox(height: AppSpacing.s8),
                Text(
                  'If cancelled, access ends on 31 Jul 2026',
                  style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kError),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('REASON FOR CANCELLATION *', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s8),
                RadioGroup<CancelReason>(
                  groupValue: data.reason,
                  onChanged: (value) => ref.read(cancelRequestProvider.notifier).setReason(value!),
                  child: Column(
                    children: [
                      for (final reason in CancelReason.values)
                        RadioListTile<CancelReason>(
                          contentPadding: EdgeInsets.zero,
                          value: reason,
                          activeColor: AppColors.kOrange,
                          title: Text(_reasonLabels[reason]!, style: AppTypography.body.copyWith(fontSize: 14)),
                        ),
                    ],
                  ),
                ),
                if (data.reason == CancelReason.other) ...[
                  SizedBox(height: AppSpacing.s8),
                  TextField(
                    controller: _customReasonController,
                    maxLines: 3,
                    onChanged: (v) => ref.read(cancelRequestProvider.notifier).setCustomReason(v),
                    decoration: InputDecoration(
                      hintText: 'Tell us more...',
                      filled: true,
                      fillColor: AppColors.kBgCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.kBorderGray),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s16),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: data.confirmed,
            activeColor: AppColors.kOrange,
            title: Text(
              'I understand my account will be deactivated at end of billing cycle',
              style: AppTypography.body.copyWith(fontSize: 13),
            ),
            onChanged: (value) => ref.read(cancelRequestProvider.notifier).setConfirmed(value ?? false),
          ),
          SizedBox(height: AppSpacing.s48),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        showTopBorder: true,
        ctaLabel: 'Submit Cancellation Request',
        isCtaLoading: data.isSubmitting,
        onCtaTap: data.canSubmit && !data.isSubmitting ? _onSubmit : null,
      ),
    );
  }
}
