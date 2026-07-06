import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/confirm_bottom_sheet.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/success_toast.dart';
import '../domain/cancellation_detail_notifier.dart';
import '../../../core/models/cancellation_model.dart';

class CancellationDetailScreen extends ConsumerStatefulWidget {
  const CancellationDetailScreen({required this.requestId, super.key});

  final String requestId;

  @override
  ConsumerState<CancellationDetailScreen> createState() => _CancellationDetailScreenState();
}

class _CancellationDetailScreenState extends ConsumerState<CancellationDetailScreen> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
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

  Future<void> _call(String phone) async {
    await launchUrl(Uri.parse('tel:$phone'));
  }

  Future<void> _whatsapp(String phone) async {
    final number = phone.replaceAll('+', '').replaceAll(' ', '');
    await launchUrl(Uri.parse('https://wa.me/$number'), mode: LaunchMode.externalApplication);
  }

  Future<void> _onApprove(String shopName) async {
    final confirmed = await ConfirmBottomSheet.show(
      context,
      title: 'Approve this cancellation request?',
      body: "$shopName's account will be deactivated at the end of the current billing cycle.",
      confirmLabel: 'Confirm Approve',
    );
    if (confirmed != true || !mounted) return;

    await ref.read(cancellationDetailProvider(widget.requestId).notifier).approve(notes: _notesController.text.trim());
    if (mounted) {
      SuccessToast.show(context, message: 'Request approved');
      context.go('/salesperson/cancellations');
    }
  }

  Future<void> _onReject() async {
    final reasonController = TextEditingController();
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.s16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reason for rejection', style: AppTypography.h3.copyWith(fontSize: 16)),
                SizedBox(height: AppSpacing.s12),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Explain why this request is being rejected...',
                    filled: true,
                    fillColor: AppColors.kBgPage,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(height: AppSpacing.s16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(sheetContext).pop(true),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: const BorderSide(color: AppColors.kError),
                    ),
                    child: const Text('Confirm Reject', style: TextStyle(color: AppColors.kError)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (confirmed != true || !mounted) return;

    final notes = reasonController.text.trim().isNotEmpty ? reasonController.text.trim() : _notesController.text.trim();
    await ref.read(cancellationDetailProvider(widget.requestId).notifier).reject(notes: notes);
    if (mounted) {
      SuccessToast.show(context, message: 'Request rejected', backgroundColor: AppColors.kError, icon: Icons.cancel_outlined);
      context.go('/salesperson/cancellations');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cancellationDetailProvider(widget.requestId));

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (r) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              GradientHeader(
                type: GradientHeaderType.orange,
                showBackButton: true,
                height: 120,
                title: 'Cancellation Request',
              ),
              Padding(
                padding: EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.shopName, style: AppTypography.h3.copyWith(fontSize: 16)),
                                SizedBox(height: AppSpacing.s4),
                                Text(r.ownerName, style: AppTypography.caption),
                              ],
                            ),
                          ),
                          StatusBadge(label: _statusLabel(r.status), type: _statusType(r.status)),
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
                          _DetailRow(label: 'Request ID', value: '#REQ-${r.id}'),
                          _DetailRow(label: 'Submitted By', value: 'Shopkeeper'),
                          _DetailRow(label: 'Plan', value: '${r.planName} · ${Formatters.formatINR(r.monthlyAmount)}/mo'),
                          _DetailRow(label: 'Reason', value: r.reason),
                          _DetailRow(label: 'Submitted At', value: Formatters.formatDateTime(r.requestedDate)),
                          if (r.notes.isNotEmpty) _DetailRow(label: 'Notes', value: r.notes),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    AppCard(
                      backgroundColor: const Color(0xFFFEF2F2),
                      borderColor: const Color(0xFFFECACA),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: AppColors.kError, size: 20),
                          SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: Text(
                              'Approving this request will stop the shop\'s AutoPay mandate and deactivate access at the end of the current billing cycle.',
                              style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kError),
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
                          Text('CONTACT SHOP OWNER', style: AppTypography.labelSmall),
                          SizedBox(height: AppSpacing.s12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _call(r.ownerPhone),
                                  icon: const Icon(Icons.call_outlined, size: 18),
                                  label: const Text('Call'),
                                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                                ),
                              ),
                              SizedBox(width: AppSpacing.s12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _whatsapp(r.ownerPhone),
                                  icon: const Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.kGreen),
                                  label: const Text('WhatsApp', style: TextStyle(color: AppColors.kGreen)),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(44),
                                    side: const BorderSide(color: AppColors.kGreen),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (r.status == CancellationStatus.pending) ...[
                      SizedBox(height: AppSpacing.s16),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NOTES (OPTIONAL)', style: AppTypography.labelSmall),
                            SizedBox(height: AppSpacing.s8),
                            TextField(
                              controller: _notesController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Add a note about this decision...',
                                filled: true,
                                fillColor: AppColors.kBgPage,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.kBorderGray),
                                ),
                              ),
                            ),
                          ],
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
              decoration: const BoxDecoration(
                color: AppColors.kBgCard,
                border: Border(top: BorderSide(color: AppColors.kBorderGray)),
              ),
              child: SafeArea(
                top: false,
                child: Row(
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
                        onPressed: () => _onApprove(state.value!.shopName),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kGreen,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: const Text('Approve', style: TextStyle(color: Colors.white)),
                      ),
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
          Expanded(
            child: Text(value, textAlign: TextAlign.right, style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
