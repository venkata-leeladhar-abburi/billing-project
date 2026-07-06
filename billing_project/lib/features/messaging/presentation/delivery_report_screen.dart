import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/bulk_message_notifier.dart';

class DeliveryReportScreen extends ConsumerWidget {
  const DeliveryReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(bulkMessageProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgCard,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.kDark),
          onPressed: () {
            ref.read(bulkMessageProvider.notifier).reset();
            context.go('/dashboard');
          },
        ),
        title: Text('Delivery Report', style: AppTypography.h3.copyWith(fontSize: 17)),
      ),
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _buildBody(context, ref, data),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, BulkMessageState data) {
    final total = data.recipientCount;
    final pending = total - data.deliveredCount - data.failedCount;

    return ListView(
      padding: EdgeInsets.all(AppSpacing.s16),
      children: [
        AppCard(
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: total == 0 ? 0 : data.deliveredCount / total,
                      strokeWidth: 8,
                      color: AppColors.kGreen,
                      backgroundColor: AppColors.kBorderGray,
                    ),
                    Text(
                      '${data.deliveredCount}/$total',
                      style: AppTypography.body.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kDark,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s8),
              Text('delivered successfully', style: AppTypography.caption),
              SizedBox(height: AppSpacing.s16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(label: 'Delivered', value: data.deliveredCount, color: AppColors.kGreen),
                  _StatItem(label: 'Failed', value: data.failedCount, color: AppColors.kError),
                  _StatItem(label: 'Pending', value: pending, color: AppColors.kWarning),
                ],
              ),
            ],
          ),
        ),
        if (data.failedCount > 0) ...[
          SizedBox(height: AppSpacing.s24),
          Text(
            'Failed to deliver',
            style: AppTypography.labelSmall.copyWith(color: AppColors.kError),
          ),
          SizedBox(height: AppSpacing.s12),
          for (final customer in data.customers.take(data.failedCount))
            AppCard(
              margin: EdgeInsets.only(bottom: AppSpacing.s8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(customer.name, style: AppTypography.body.copyWith(fontSize: 14)),
                        Text(customer.phone, style: AppTypography.caption),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: wire POST /campaigns/:id/retry when backend ready
                    },
                    child: Text('Retry', style: AppTypography.body.copyWith(color: AppColors.kOrange)),
                  ),
                ],
              ),
            ),
        ],
        SizedBox(height: AppSpacing.s24),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryRow('Template used', data.selectedTemplate?.displayName ?? '—'),
              _summaryRow('Credits used', '$total'),
              _summaryRow('Credits remaining', '${data.msgCredits - total}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
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

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value, required this.color});

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: AppTypography.body.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: color),
        ),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
