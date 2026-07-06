import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/mock/mock_fixtures.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../domain/new_bill_notifier.dart';

class BillSentScreen extends ConsumerStatefulWidget {
  const BillSentScreen({super.key});

  @override
  ConsumerState<BillSentScreen> createState() => _BillSentScreenState();
}

class _BillSentScreenState extends ConsumerState<BillSentScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _creditColor {
    final pct = MockFixtures.billCredits / MockFixtures.billCreditsMax;
    if (pct > 0.5) return AppColors.kGreen;
    if (pct > 0.2) return AppColors.kWarning;
    return AppColors.kError;
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(newBillProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) context.go('/dashboard');
      },
      child: Scaffold(
        backgroundColor: AppColors.kBgCard,
        body: SafeArea(
          child: asyncState.when(
            loading: () => const LoadingOverlay(),
            error: (error, _) => const Center(child: Text('Could not load')),
            data: (data) => _buildBody(context, data),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NewBillState data) {
    final creditColor = _creditColor;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      children: [
        SizedBox(height: AppSpacing.s48),
        ScaleTransition(
          scale: _scale,
          child: FadeTransition(
            opacity: _fade,
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0FDF4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 56,
                  color: AppColors.kGreen,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.s24),
        Text(
          'Bill Sent!',
          textAlign: TextAlign.center,
          style: AppTypography.displaySerif.copyWith(fontSize: 28),
        ),
        SizedBox(height: AppSpacing.s8),
        Text(
          'Your customer will receive it on WhatsApp shortly.',
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(height: 1.6),
        ),
        SizedBox(height: AppSpacing.s24),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: AppCard(
            borderRadius: 16,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.selectedCustomer?.name ?? '—',
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.kDark,
                      ),
                    ),
                    Text(
                      Formatters.formatINR(data.total),
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.kOrange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.s8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Bill #${data.billNumber}', style: AppTypography.caption),
                    Text(
                      data.sentAt == null
                          ? ''
                          : 'Sent at ${Formatters.formatTime(data.sentAt!)}',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.s12),
                Text(
                  '1 bill credit used',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.s16),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              border: Border.all(color: const Color(0xFFBBF7D0)),
              borderRadius: AppSpacing.rPill,
            ),
            child: Text(
              '${MockFixtures.billCredits} bill credits remaining',
              style: AppTypography.body.copyWith(
                fontSize: 12,
                color: creditColor,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.s24),
        PrimaryButton(
          label: 'Send Another Bill',
          onTap: () {
            ref.read(newBillProvider.notifier).reset();
            context.go('/new-bill');
          },
        ),
        SizedBox(height: AppSpacing.s8),
        SecondaryButton(
          label: 'View Bill History',
          onTap: () => context.go('/bill-history'),
        ),
        SizedBox(height: AppSpacing.s16),
        GestureDetector(
          onTap: () => context.go('/dashboard'),
          child: Text(
            'Back to Dashboard',
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(
              fontSize: 13,
              color: AppColors.kOrange,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.s24),
      ],
    );
  }
}
