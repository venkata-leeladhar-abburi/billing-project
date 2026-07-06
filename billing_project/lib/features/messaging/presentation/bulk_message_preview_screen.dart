import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/mock/mock_fixtures.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/bottom_action_bar.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/bulk_message_notifier.dart';

class BulkMessagePreviewScreen extends ConsumerWidget {
  const BulkMessagePreviewScreen({super.key});

  String _resolve(String body) {
    return body
        .replaceAll('{{shop_name}}', MockFixtures.shopName)
        .replaceAll('{{offer}}', 'Diwali collection')
        .replaceAll('{{item}}', 'new arrivals')
        .replaceAll('{{customer_name}}', 'Suresh')
        .replaceAll('{{amount}}', '2,500');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(bulkMessageProvider);

    return Scaffold(
      backgroundColor: AppColors.kOrange,
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _buildBody(context, ref, data),
      ),
      bottomNavigationBar: asyncState.maybeWhen(
        data: (data) => BottomActionBar(
          secondaryLabel: '${data.recipientCount} customers · ${data.recipientCount} credits',
          ctaLabel: 'Send Now',
          isCtaLoading: data.isSending,
          onCtaTap: data.canSend && !data.isSending
              ? () => _onSend(context, ref)
              : null,
        ),
        orElse: () => const SizedBox(height: 72),
      ),
    );
  }

  Future<void> _onSend(BuildContext context, WidgetRef ref) async {
    await ref.read(bulkMessageProvider.notifier).send();
    if (context.mounted) context.go('/delivery-report');
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, BulkMessageState data) {
    final names = data.recipientMode == RecipientMode.all
        ? data.customers.map((c) => c.name).toList()
        : data.customers
              .where((c) => data.selectedCustomerIds.contains(c.id))
              .map((c) => c.name)
              .toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            AppSpacing.s16,
            MediaQuery.of(context).padding.top + AppSpacing.s8,
            AppSpacing.s16,
            AppSpacing.s24,
          ),
          decoration: const BoxDecoration(gradient: AppColors.kGradientOrange),
          child: Row(
            children: [
              Material(
                color: Colors.white24,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () => context.pop(),
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(Icons.arrow_back, size: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.s12),
              Text(
                'Message Preview',
                style: AppTypography.h3.copyWith(fontSize: 17, color: Colors.white),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.kBgCard,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.s16),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sending to ${data.recipientCount} customers',
                        style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: AppSpacing.s4),
                      Text(
                        'Uses ${data.recipientCount} credits · ${data.creditsRemainingAfter} left after',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.s16),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppSpacing.s12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCF8C6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          data.selectedTemplate == null
                              ? ''
                              : _resolve(data.selectedTemplate!.body),
                          style: AppTypography.body.copyWith(fontSize: 14),
                        ),
                      ),
                      SizedBox(height: AppSpacing.s8),
                      Text(
                        'This is how your customers will see it',
                        style: AppTypography.caption.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.s16),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final name in names.take(5))
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
                          child: Text(name, style: AppTypography.body.copyWith(fontSize: 14)),
                        ),
                      if (names.length > 5)
                        Text(
                          'and ${names.length - 5} more...',
                          style: AppTypography.caption,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.s48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
