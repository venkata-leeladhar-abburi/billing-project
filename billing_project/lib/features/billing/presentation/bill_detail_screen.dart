import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/mock/mock_fixtures.dart';
import '../../../core/models/bill_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/bottom_action_bar.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/success_toast.dart';
import '../domain/bill_detail_notifier.dart';

class BillDetailScreen extends ConsumerWidget {
  const BillDetailScreen({required this.billId, super.key});

  final String billId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(billDetailProvider(billId));

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _buildBody(context, ref, data),
      ),
      bottomNavigationBar: asyncState.maybeWhen(
        data: (data) => data.bill.status == BillStatus.sent
            ? BottomActionBar(
                primaryLabel: Formatters.formatINR(data.total),
                secondaryLabel: data.bill.customerName,
                ctaLabel: 'Re-send on WhatsApp',
                isCtaLoading: data.isResending,
                onCtaTap: data.isResending
                    ? null
                    : () => _onResend(context, ref),
                creditInfo: 'Free — no credit used',
                creditInfoColor: AppColors.kGreen,
              )
            : const SizedBox(height: 72)
        ,
        orElse: () => const SizedBox(height: 72),
      ),
    );
  }

  Future<void> _onResend(BuildContext context, WidgetRef ref) async {
    await ref.read(billDetailProvider(billId).notifier).resend();
    if (context.mounted) {
      SuccessToast.show(context, message: 'Bill re-sent on WhatsApp');
    }
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, BillDetailState data) {
    return ListView(
      padding: EdgeInsets.zero,
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
              _CircleIconButton(
                icon: Icons.arrow_back,
                onTap: () => context.go('/bill-history'),
              ),
              SizedBox(width: AppSpacing.s12),
              Text(
                'Bill #${data.bill.billNumber}',
                style: AppTypography.h3.copyWith(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              _CircleIconButton(
                icon: Icons.share,
                onTap: () {
                  // TODO: share PDF via system share sheet when PDF generation is wired up
                },
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.kBgCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.s8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.kBorderGray),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                        vertical: 14,
                      ),
                      color: AppColors.kNavy,
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Colors.white24,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              MockFixtures.shopName.isNotEmpty
                                  ? MockFixtures.shopName[0]
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.s12),
                          Text(
                            MockFixtures.shopName,
                            style: AppTypography.body.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                        vertical: AppSpacing.s12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BILLED TO', style: AppTypography.labelSmall),
                          Text(
                            data.bill.customerName,
                            style: AppTypography.body.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.kDark,
                            ),
                          ),
                          Text(data.customerPhone, style: AppTypography.body.copyWith(fontSize: 13)),
                          SizedBox(height: AppSpacing.s12),
                          const Divider(height: 1, color: AppColors.kDivider),
                          SizedBox(height: AppSpacing.s12),
                          for (final item in data.items)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 20,
                                    child: Text(
                                      item.name,
                                      style: AppTypography.body.copyWith(fontSize: 13),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Text(
                                      '${item.qty}',
                                      style: AppTypography.body.copyWith(fontSize: 13),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 12,
                                    child: Text(
                                      Formatters.formatINR(item.amount),
                                      textAlign: TextAlign.right,
                                      style: AppTypography.body.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: AppSpacing.s12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('GRAND TOTAL', style: AppTypography.body.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.kOrange)),
                              Text(Formatters.formatINR(data.total), style: AppTypography.body.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.kOrange)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s24),
              StatusBadge(
                label: data.bill.status == BillStatus.sent ? 'Sent' : 'Failed',
                type: data.bill.status == BillStatus.sent
                    ? StatusBadgeType.active
                    : StatusBadgeType.failed,
              ),
              SizedBox(height: AppSpacing.s8),
              if (data.bill.sentAt != null)
                Text(
                  'Sent at ${Formatters.formatDateTime(data.bill.sentAt!)}',
                  style: AppTypography.body.copyWith(
                    fontSize: 13,
                    color: AppColors.kSecondary,
                  ),
                ),
              if (data.deliveredAt != null)
                Text(
                  'Delivered to customer WhatsApp at ${Formatters.formatTime(data.deliveredAt!)}',
                  style: AppTypography.body.copyWith(
                    fontSize: 13,
                    color: AppColors.kSecondary,
                  ),
                ),
              SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white24,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}
