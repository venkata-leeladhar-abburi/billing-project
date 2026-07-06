import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/bottom_action_bar.dart';
import '../../../shared/widgets/dark_pill_button.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/bulk_message_notifier.dart';

class BulkMessageScreen extends ConsumerWidget {
  const BulkMessageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(bulkMessageProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _buildBody(context, ref, data),
      ),
      bottomNavigationBar: asyncState.maybeWhen(
        data: (data) => BottomActionBar(
          primaryLabel: 'To ${data.recipientCount} customers',
          secondaryLabel: '${data.msgCredits} credits left',
          ctaLabel: 'Send Messages',
          onCtaTap: data.canSend
              ? () => context.push('/bulk-message-preview')
              : null,
        ),
        orElse: () => const SizedBox(height: 72),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, BulkMessageState data) {
    final notifier = ref.read(bulkMessageProvider.notifier);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GradientHeader(
          type: GradientHeaderType.purple,
          height: 140,
          showBackButton: true,
          onBack: () => context.go('/dashboard'),
          title: 'Bulk Message',
          subtitle: '${data.msgCredits} message credits',
        ),
        Padding(
          padding: EdgeInsets.all(AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SEND TO', style: AppTypography.labelSmall),
                    SizedBox(height: AppSpacing.s12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DarkPillButton(
                          label: 'All Customers',
                          isSelected: data.recipientMode == RecipientMode.all,
                          onTap: () => notifier.setRecipientMode(RecipientMode.all),
                        ),
                        SizedBox(width: AppSpacing.s8),
                        DarkPillButton(
                          label: 'Select Manually',
                          isSelected: data.recipientMode == RecipientMode.manual,
                          onTap: () => notifier.setRecipientMode(RecipientMode.manual),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.s16),
                    if (data.recipientMode == RecipientMode.all)
                      Text(
                        '${data.customers.length} customers will receive this message',
                        style: AppTypography.body.copyWith(fontSize: 14),
                      )
                    else ...[
                      Text(
                        '${data.selectedCustomerIds.length} selected',
                        style: AppTypography.body.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppSpacing.s8),
                      for (final customer in data.customers)
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: data.selectedCustomerIds.contains(customer.id),
                          onChanged: (_) => notifier.toggleCustomer(customer.id),
                          title: Text(
                            customer.name,
                            style: AppTypography.body.copyWith(fontSize: 14),
                          ),
                          subtitle: Text(customer.phone, style: AppTypography.caption),
                        ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s16),
              AppCard(
                leftBorderColor: AppColors.kWarning,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This campaign will use ${data.recipientCount} credits',
                      style: AppTypography.body.copyWith(fontSize: 14),
                    ),
                    SizedBox(height: AppSpacing.s4),
                    Text(
                      data.creditsRemainingAfter >= 0
                          ? '${data.creditsRemainingAfter} credits remaining after sending'
                          : 'Insufficient credits — need ${-data.creditsRemainingAfter} more',
                      style: AppTypography.caption.copyWith(
                        color: data.creditsRemainingAfter >= 0
                            ? AppColors.kMuted
                            : AppColors.kError,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s16),
              AppCard(
                onTap: () => context.push('/template-select'),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Choose Template', style: AppTypography.h3.copyWith(fontSize: 15)),
                          SizedBox(height: AppSpacing.s4),
                          Text(
                            data.selectedTemplate?.displayName ?? 'Not selected yet',
                            style: AppTypography.body.copyWith(
                              fontSize: 13,
                              color: data.selectedTemplate == null
                                  ? AppColors.kMuted
                                  : AppColors.kSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward, color: AppColors.kOrange, size: 18),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s48),
            ],
          ),
        ),
      ],
    );
  }
}
