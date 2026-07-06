import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/credits_notifier.dart';

class CreditsScreen extends ConsumerWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(creditsProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _buildBody(context, data),
      ),
    );
  }

  Color _statusColor(int current, int limit) {
    final pct = current / limit;
    if (pct > 0.5) return AppColors.kGreen;
    if (pct > 0.2) return AppColors.kWarning;
    return AppColors.kError;
  }

  Widget _buildBody(BuildContext context, CreditsState data) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GradientHeader(
          type: GradientHeaderType.purple,
          showBackButton: true,
          onBack: () => context.go('/dashboard'),
          title: 'Credits & Plan',
        ),
        Transform.translate(
          offset: const Offset(0, -20),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            child: AppCard(
              borderRadius: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.s12,
                      vertical: AppSpacing.s4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: AppSpacing.rPill,
                    ),
                    child: Text(
                      data.planName,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.s8),
                  Text(
                    'Renews on ${Formatters.formatDate(data.renewalDate)}',
                    style: AppTypography.body.copyWith(
                      fontSize: 13,
                      color: AppColors.kSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.s16),
                  const Divider(height: 1, color: AppColors.kDivider),
                  SizedBox(height: AppSpacing.s16),
                  _creditBar(
                    label: 'Bill Credits',
                    used: data.billCreditsLimit - data.billCredits,
                    total: data.billCreditsLimit,
                    remaining: data.billCredits,
                  ),
                  SizedBox(height: AppSpacing.s16),
                  _creditBar(
                    label: 'Msg Credits',
                    used: data.msgCreditsLimit - data.msgCredits,
                    total: data.msgCreditsLimit,
                    remaining: data.msgCredits,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Buy Extra Credits', style: AppTypography.labelSmall.copyWith(fontSize: 13)),
              SizedBox(height: AppSpacing.s12),
              for (final pack in data.packs) ...[
                AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pack.name, style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                            SizedBox(height: AppSpacing.s4),
                            Text(
                              '${pack.credits} ${pack.creditType == 'bill' ? 'bill credits' : 'marketing msgs'}',
                              style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kSecondary),
                            ),
                            SizedBox(height: AppSpacing.s4),
                            Text(
                              '${Formatters.formatINR(pack.perUnitCost)}/msg',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ),
                      IntrinsicWidth(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Formatters.formatINR(pack.price),
                              style: AppTypography.body.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: AppSpacing.s8),
                            SizedBox(
                              height: 32,
                              child: ElevatedButton(
                                onPressed: () => context.push('/credits/topup', extra: pack),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.kOrange,
                                  foregroundColor: Colors.white,
                                  shape: const StadiumBorder(),
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                                ),
                                child: const Text('Buy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.s8),
              ],
              SizedBox(height: AppSpacing.s16),
              Text('Recent Payments', style: AppTypography.labelSmall.copyWith(fontSize: 13)),
              SizedBox(height: AppSpacing.s12),
              for (final payment in data.recentPayments)
                AppCard(
                  margin: EdgeInsets.only(bottom: AppSpacing.s8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(payment.planName, style: AppTypography.body.copyWith(fontSize: 14)),
                            Text(Formatters.formatDate(payment.date), style: AppTypography.caption),
                          ],
                        ),
                      ),
                      Text(
                        '${Formatters.formatINR(payment.amount)} · Paid ✓',
                        style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kGreen),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _creditBar({
    required String label,
    required int used,
    required int total,
    required int remaining,
  }) {
    final color = _statusColor(remaining, total);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
            Text(
              '$remaining left',
              style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.s8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : used / total,
            minHeight: 6,
            backgroundColor: AppColors.kBorderGray,
            color: AppColors.kOrange,
          ),
        ),
        SizedBox(height: AppSpacing.s4),
        Text('$used/$total used', style: AppTypography.caption),
      ],
    );
  }
}
