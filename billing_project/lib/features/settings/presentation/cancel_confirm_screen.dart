import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/primary_button.dart';
import '../domain/cancel_request_notifier.dart';

class CancelConfirmScreen extends ConsumerWidget {
  const CancelConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(cancelRequestProvider).value ?? const CancelRequestState();

    return Scaffold(
      backgroundColor: AppColors.kBgCard,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          children: [
            SizedBox(height: AppSpacing.s48),
            const Icon(Icons.pending_outlined, size: 80, color: AppColors.kWarning),
            SizedBox(height: AppSpacing.s24),
            Text(
              'Request Submitted',
              textAlign: TextAlign.center,
              style: AppTypography.h1Serif.copyWith(fontSize: 24),
            ),
            SizedBox(height: AppSpacing.s8),
            Text(
              "We've received your request. Our team will contact you within 24 hours.",
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: AppColors.kSecondary),
            ),
            SizedBox(height: AppSpacing.s24),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Request ID: #${data.requestId ?? '—'}', style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                  SizedBox(height: AppSpacing.s8),
                  Text(
                    data.submittedAt == null
                        ? ''
                        : 'Submitted at ${Formatters.formatDateTime(data.submittedAt!)}',
                    style: AppTypography.caption,
                  ),
                  SizedBox(height: AppSpacing.s12),
                  Text(
                    'You can continue using the app until your current billing period ends on 31 Jul 2026',
                    style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kSecondary),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.s24),
            PrimaryButton(label: 'Back to Home', onTap: () => context.go('/dashboard')),
            SizedBox(height: AppSpacing.s24),
          ],
        ),
      ),
    );
  }
}
