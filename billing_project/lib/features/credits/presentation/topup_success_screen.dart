import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/primary_button.dart';
import '../domain/credits_notifier.dart';
import '../domain/topup_notifier.dart';

class TopupSuccessScreen extends ConsumerWidget {
  const TopupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTopup = ref.watch(topupProvider);
    final asyncCredits = ref.watch(creditsProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgCard,
      body: SafeArea(
        child: asyncTopup.when(
          loading: () => const LoadingOverlay(),
          error: (error, _) => const Center(child: Text('Could not load')),
          data: (topup) => asyncCredits.maybeWhen(
            data: (credits) => _buildBody(context, topup, credits),
            orElse: () => const LoadingOverlay(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TopupState topup, CreditsState credits) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      children: [
        SizedBox(height: AppSpacing.s48),
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
            child: const Icon(Icons.check_circle, size: 56, color: AppColors.kGreen),
          ),
        ),
        SizedBox(height: AppSpacing.s24),
        Text(
          'Credits Added!',
          textAlign: TextAlign.center,
          style: AppTypography.displaySerif.copyWith(fontSize: 28),
        ),
        SizedBox(height: AppSpacing.s8),
        Text(
          '${topup.pack.credits} credits added to your account',
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(color: AppColors.kSecondary),
        ),
        SizedBox(height: AppSpacing.s24),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row('Pack', topup.pack.name),
              _row(
                'Credits added',
                '${topup.pack.credits} ${topup.pack.creditType == 'bill' ? 'bill credits' : 'msg credits'}',
              ),
              _row(
                'New balance',
                '${credits.billCredits} bill · ${credits.msgCredits} msg',
              ),
              _row('Amount paid', Formatters.formatINR(topup.total)),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.s24),
        PrimaryButton(label: 'Back to Dashboard', onTap: () => context.go('/dashboard')),
        SizedBox(height: AppSpacing.s16),
        GestureDetector(
          onTap: () => context.go('/credits'),
          child: Text(
            'Buy More Credits',
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kOrange),
          ),
        ),
        SizedBox(height: AppSpacing.s24),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kSecondary)),
          Text(value, style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
