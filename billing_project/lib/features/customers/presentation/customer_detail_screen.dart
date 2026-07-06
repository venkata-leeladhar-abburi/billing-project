import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/status_badge.dart';
import '../domain/customer_detail_notifier.dart';

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({required this.customerId, super.key});

  final String customerId;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(customerDetailProvider(customerId));

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _buildBody(context, ref, data),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CustomerDetailState data,
  ) {
    final customer = data.customer;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ── ORANGE GRADIENT HEADER ────────────────────────────
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            AppSpacing.s16,
            MediaQuery.of(context).padding.top + AppSpacing.s8,
            AppSpacing.s16,
            AppSpacing.s48,
          ),
          decoration: const BoxDecoration(gradient: AppColors.kGradientOrange),
          child: Row(
            children: [
              _CircleIconButton(
                icon: Icons.arrow_back,
                onTap: () => context.pop(),
              ),
              const Spacer(),
              Text(
                customer.name,
                style: AppTypography.h3.copyWith(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              _CircleIconButton(
                icon: Icons.edit_outlined,
                onTap: () {
                  // TODO: inline edit mode for name/phone/notes when backend ready
                },
              ),
            ],
          ),
        ),

        // ── CUSTOMER SUMMARY CARD ──────────────────────────────
        Transform.translate(
          offset: const Offset(0, -32),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            child: AppCard(
              borderRadius: 16,
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppColors.kOrangeLight,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials(customer.name),
                      style: AppTypography.body.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kOrange,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.s12),
                  Text(
                    customer.name,
                    style: AppTypography.h2.copyWith(fontSize: 18),
                  ),
                  SizedBox(height: AppSpacing.s4),
                  Text(
                    customer.phone,
                    style: AppTypography.body.copyWith(
                      color: AppColors.kSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.s12),
                  StatusBadge(
                    label: data.businessType,
                    type: StatusBadgeType.info,
                    showDot: false,
                  ),
                  SizedBox(height: AppSpacing.s20),
                  const Divider(height: 1, color: AppColors.kDivider),
                  SizedBox(height: AppSpacing.s16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatColumn(
                          value: '${customer.billCount}',
                          label: 'Total Bills',
                        ),
                      ),
                      Expanded(
                        child: _StatColumn(
                          value: Formatters.formatINR(customer.totalBilled),
                          label: 'Total Billed',
                        ),
                      ),
                      Expanded(
                        child: _StatColumn(
                          value: customer.lastBilledAt == null
                              ? '—'
                              : Formatters.formatDate(customer.lastBilledAt!),
                          label: 'Last Bill Date',
                        ),
                      ),
                    ],
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
              // ── QUICK ACTIONS ROW ───────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _SmallPillButton(
                      label: 'New Bill',
                      filled: true,
                      onTap: () => context.push('/new-bill'),
                    ),
                  ),
                  SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: _SmallPillButton(
                      label: 'Send Message',
                      filled: false,
                      onTap: () => context.push('/bulk-message'),
                    ),
                  ),
                  SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: _SmallPillButton(
                      label: 'Call',
                      filled: false,
                      onTap: () => launchUrl(Uri(scheme: 'tel', path: customer.phone)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.s24),

              // ── BILL HISTORY ─────────────────────────────────
              Row(
                children: [
                  Text(
                    'Bills',
                    style: AppTypography.labelSmall.copyWith(fontSize: 13),
                  ),
                  SizedBox(width: AppSpacing.s4),
                  Text(
                    '(${data.bills.length})',
                    style: AppTypography.labelSmall.copyWith(fontSize: 13),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.s12),
              for (final bill in data.bills.take(10)) ...[
                AppCard(
                  onTap: () => context.push('/bill/${bill.billId}'),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.s16,
                    vertical: AppSpacing.s12,
                  ),
                  margin: EdgeInsets.only(bottom: AppSpacing.s8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bill.billNumber,
                              style: AppTypography.body.copyWith(
                                fontSize: 14,
                                color: AppColors.kDark,
                              ),
                            ),
                            SizedBox(height: AppSpacing.s4),
                            Text(bill.sentAgo, style: AppTypography.caption),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Formatters.formatINR(bill.total),
                            style: AppTypography.body.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.kDark,
                            ),
                          ),
                          SizedBox(height: AppSpacing.s4),
                          StatusBadge(
                            label: bill.status == 'sent' ? 'Sent' : 'Failed',
                            type: bill.status == 'sent'
                                ? StatusBadgeType.active
                                : StatusBadgeType.failed,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              if (data.bills.length > 10)
                GestureDetector(
                  onTap: () => context.push('/bill-history?customerId=$customerId'),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.s8),
                    child: Text(
                      'View All →',
                      style: AppTypography.body.copyWith(
                        fontSize: 13,
                        color: AppColors.kOrange,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: AppSpacing.s24),

              // ── NOTES SECTION ────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notes', style: AppTypography.labelSmall.copyWith(fontSize: 13)),
                  GestureDetector(
                    onTap: () {
                      // TODO: inline note editing when backend ready
                    },
                    child: Text(
                      'Edit note',
                      style: AppTypography.body.copyWith(
                        fontSize: 13,
                        color: AppColors.kOrange,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.s8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.s16),
                decoration: BoxDecoration(
                  color: AppColors.kBgPage,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data.note?.isNotEmpty == true
                      ? data.note!
                      : 'No notes added',
                  style: AppTypography.body.copyWith(
                    color: data.note?.isNotEmpty == true
                        ? AppColors.kSecondary
                        : const Color(0xFFCCCCCC),
                  ),
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

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.body.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.kDark,
          ),
        ),
        SizedBox(height: AppSpacing.s4),
        Text(label, style: AppTypography.labelSmall, textAlign: TextAlign.center),
      ],
    );
  }
}

class _SmallPillButton extends StatelessWidget {
  const _SmallPillButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: filled
          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kOrange,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                label,
                style: AppTypography.body.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.kDark,
                side: const BorderSide(color: AppColors.kBorderGray),
                shape: const StadiumBorder(),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                label,
                style: AppTypography.body.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kDark,
                ),
              ),
            ),
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
