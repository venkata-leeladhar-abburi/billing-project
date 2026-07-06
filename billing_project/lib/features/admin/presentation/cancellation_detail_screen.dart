import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/cancellation_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/success_toast.dart';
import '../domain/admin_cancellation_detail_notifier.dart';

class AdminCancellationDetailScreen extends ConsumerStatefulWidget {
  const AdminCancellationDetailScreen({required this.requestId, super.key});

  final String requestId;

  @override
  ConsumerState<AdminCancellationDetailScreen> createState() => _AdminCancellationDetailScreenState();
}

class _AdminCancellationDetailScreenState extends ConsumerState<AdminCancellationDetailScreen> {
  final _adminNotesController = TextEditingController();

  @override
  void dispose() {
    _adminNotesController.dispose();
    super.dispose();
  }

  StatusBadgeType _statusType(CancellationStatus status) {
    switch (status) {
      case CancellationStatus.pending:
        return StatusBadgeType.pending;
      case CancellationStatus.approved:
        return StatusBadgeType.approved;
      case CancellationStatus.rejected:
        return StatusBadgeType.rejected;
    }
  }

  String _statusLabel(CancellationStatus status) {
    switch (status) {
      case CancellationStatus.pending:
        return 'Pending';
      case CancellationStatus.approved:
        return 'Approved';
      case CancellationStatus.rejected:
        return 'Rejected';
    }
  }

  Future<void> _onApprove(CancellationRequest r) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.s16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confirm cancellation for ${r.shopName}? This will cancel their Razorpay AutoPay mandate and deactivate the shop at the end of the billing cycle.',
                textAlign: TextAlign.center,
                style: AppTypography.body,
              ),
              SizedBox(height: AppSpacing.s16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(sheetContext).pop(true),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.kGreen, minimumSize: const Size.fromHeight(48)),
                  child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true || !mounted) return;

    await ref.read(adminCancellationDetailProvider(widget.requestId).notifier).approve(adminNotes: _adminNotesController.text.trim());
    if (mounted) {
      SuccessToast.show(context, message: 'Cancellation approved');
      context.go('/admin/cancellations');
    }
  }

  Future<void> _onReject() async {
    await ref.read(adminCancellationDetailProvider(widget.requestId).notifier).reject(adminNotes: _adminNotesController.text.trim());
    if (mounted) {
      SuccessToast.show(context, message: 'Request rejected', backgroundColor: AppColors.kError, icon: Icons.cancel_outlined);
      context.go('/admin/cancellations');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminCancellationDetailProvider(widget.requestId));

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (r) {
          final endDate = DateTime(r.requestedDate.year, r.requestedDate.month + 1, r.requestedDate.day);
          final daysLeft = endDate.difference(DateTime.now()).inDays.clamp(0, 999);

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              GradientHeader(
                type: GradientHeaderType.orange,
                showBackButton: true,
                height: 110,
                title: 'Cancellation Request',
                subtitle: '#REQ-${r.id}',
              ),
              Padding(
                padding: EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(r.shopName, style: AppTypography.h3.copyWith(fontSize: 16)),
                              StatusBadge(label: _statusLabel(r.status), type: _statusType(r.status)),
                            ],
                          ),
                          SizedBox(height: AppSpacing.s4),
                          Text('${r.ownerName} · ${r.ownerPhone}', style: AppTypography.caption),
                          SizedBox(height: AppSpacing.s8),
                          GestureDetector(
                            onTap: () => context.push('/admin/shops'),
                            child: Text('Managed by: ${r.salespersonName}', style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kBlue)),
                          ),
                          SizedBox(height: AppSpacing.s8),
                          Text('${r.planName} · ${Formatters.formatINR(r.monthlyAmount)}/mo', style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('REQUEST DETAILS', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          _DetailRow(label: 'Submitted By', value: 'Shopkeeper'),
                          _DetailRow(label: 'Submitted At', value: Formatters.formatDateTime(r.requestedDate)),
                          _DetailRow(label: 'Reason', value: r.reason),
                          if (r.notes.isNotEmpty) _DetailRow(label: 'Shopkeeper Note', value: r.notes),
                          _DetailRow(
                            label: 'Salesperson Action',
                            value: r.salespersonAction == CancellationStatus.approved
                                ? 'Approved'
                                : (r.salespersonAction == CancellationStatus.rejected ? 'Rejected' : 'Pending Review'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      backgroundColor: const Color(0xFFFEF2F2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.attach_money, color: AppColors.kError, size: 20),
                          SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Monthly revenue lost: ${Formatters.formatINR(r.monthlyAmount)}', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kError, fontWeight: FontWeight.w600)),
                                SizedBox(height: AppSpacing.s4),
                                Text('Remaining billing period: $daysLeft days (until ${Formatters.formatDate(endDate)})', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kError)),
                                SizedBox(height: AppSpacing.s4),
                                Text('AutoPay mandate ID: mandate_${r.id}xyz', style: AppTypography.caption.copyWith(fontSize: 11)),
                                SizedBox(height: AppSpacing.s8),
                                Text('Approving will cancel Razorpay mandate mandate_${r.id}xyz', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kError)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CANCELLATION TERMS', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          _DetailRow(label: 'Shop Access Ends', value: Formatters.formatDate(endDate)),
                          _DetailRow(label: 'Data Retention', value: '90 days post-cancellation'),
                          _DetailRow(label: 'AutoPay Cancellation', value: 'Immediate upon approval'),
                          SizedBox(height: AppSpacing.s8),
                          Text('Shop can re-subscribe anytime', style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kGreen)),
                        ],
                      ),
                    ),
                    if (r.status == CancellationStatus.pending) ...[
                      SizedBox(height: AppSpacing.s16),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ADMIN NOTES (INTERNAL)', style: AppTypography.labelSmall),
                            SizedBox(height: AppSpacing.s4),
                            Text('These notes are not visible to the shopkeeper', style: AppTypography.caption.copyWith(fontSize: 11)),
                            SizedBox(height: AppSpacing.s8),
                            TextField(
                              controller: _adminNotesController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Add internal notes...',
                                filled: true,
                                fillColor: AppColors.kBgPage,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      SizedBox(height: AppSpacing.s16),
                      AppCard(
                        child: Text(
                          r.status == CancellationStatus.approved
                              ? 'Approved by Leeladhar on ${Formatters.formatDate(DateTime.now())}. Razorpay AutoPay mandate cancelled.'
                              : 'Rejected by Leeladhar on ${Formatters.formatDate(DateTime.now())}.',
                          style: AppTypography.body.copyWith(fontSize: 13, color: r.status == CancellationStatus.approved ? AppColors.kGreen : AppColors.kMuted),
                        ),
                      ),
                    ],
                    SizedBox(height: AppSpacing.s24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: state.value?.status == CancellationStatus.pending
          ? Container(
              padding: EdgeInsets.all(AppSpacing.s16),
              decoration: const BoxDecoration(color: AppColors.kBgCard, border: Border(top: BorderSide(color: AppColors.kBorderGray))),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${Formatters.formatINR(state.value!.monthlyAmount)}/mo will be lost', style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kError, fontWeight: FontWeight.w700)),
                    SizedBox(height: AppSpacing.s8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _onReject,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              side: const BorderSide(color: AppColors.kError),
                            ),
                            child: const Text('Reject', style: TextStyle(color: AppColors.kError)),
                          ),
                        ),
                        SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _onApprove(state.value!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.kGreen,
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: const Text('Approve', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption),
          SizedBox(width: AppSpacing.s12),
          Expanded(child: Text(value, textAlign: TextAlign.right, style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
