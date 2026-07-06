import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/bottom_action_bar.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/credits_notifier.dart';
import '../domain/topup_notifier.dart';

class TopupScreen extends ConsumerStatefulWidget {
  const TopupScreen({required this.pack, super.key});

  final TopupPack pack;

  @override
  ConsumerState<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends ConsumerState<TopupScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(topupProvider.notifier).setPack(widget.pack));
  }

  Future<void> _onPay() async {
    await ref.read(topupProvider.notifier).pay();
    if (!mounted) return;
    final paid = ref.read(topupProvider).value?.isPaid ?? false;
    if (paid) context.go('/credits/topup-success');
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(topupProvider);

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
        title: Text('Buy Credits', style: AppTypography.h3.copyWith(fontSize: 17)),
      ),
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _buildBody(context, data),
      ),
      bottomNavigationBar: asyncState.maybeWhen(
        data: (data) => BottomActionBar(
          primaryLabel: Formatters.formatINR(data.total),
          ctaLabel: 'Pay Now',
          isCtaLoading: data.isPaying,
          onCtaTap: data.isPaying ? null : _onPay,
        ),
        orElse: () => const SizedBox(height: 72),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TopupState data) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.s16),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.pack.name, style: AppTypography.body.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
              SizedBox(height: AppSpacing.s4),
              Text(
                '${data.pack.credits} ${data.pack.creditType == 'bill' ? 'bill credits' : 'marketing msgs'}',
                style: AppTypography.body.copyWith(fontSize: 14, color: AppColors.kSecondary),
              ),
              SizedBox(height: AppSpacing.s8),
              GestureDetector(
                onTap: () => context.pop(),
                child: Text(
                  'Change pack',
                  style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kOrange),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.s16),
        AppCard(
          child: Column(
            children: [
              _row('Pack price', Formatters.formatINR(data.pack.price)),
              _row('GST (18%)', Formatters.formatINR(data.gst)),
              SizedBox(height: AppSpacing.s8),
              const Divider(height: 1, color: AppColors.kDivider),
              SizedBox(height: AppSpacing.s8),
              _row('Total', Formatters.formatINR(data.total), bold: true),
              SizedBox(height: AppSpacing.s8),
              Text(
                'Credits added instantly after payment',
                style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kGreen),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.s16),
        AppCard(
          child: Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined, color: AppColors.kBlue),
              SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pay via Razorpay', style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                    SizedBox(height: AppSpacing.s4),
                    Text('UPI · Cards · Net Banking', style: AppTypography.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(
              fontSize: bold ? 16 : 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              color: bold ? AppColors.kDark : AppColors.kSecondary,
            ),
          ),
          Text(
            value,
            style: AppTypography.body.copyWith(
              fontSize: bold ? 16 : 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              color: bold ? AppColors.kDark : AppColors.kSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
