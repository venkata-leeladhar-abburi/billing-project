import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/mock/mock_fixtures.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/bottom_action_bar.dart';
import '../../../shared/widgets/dark_pill_button.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/success_toast.dart';
import '../domain/new_bill_notifier.dart';

enum _PreviewTab { bill, shopInfo, notes }

class BillPreviewScreen extends ConsumerStatefulWidget {
  const BillPreviewScreen({super.key});

  @override
  ConsumerState<BillPreviewScreen> createState() => _BillPreviewScreenState();
}

class _BillPreviewScreenState extends ConsumerState<BillPreviewScreen> {
  _PreviewTab _tab = _PreviewTab.bill;

  Future<void> _onSend() async {
    await ref.read(newBillProvider.notifier).sendBill();
    if (!mounted) return;

    final sent = ref.read(newBillProvider).value?.isSent ?? false;
    if (sent) {
      SuccessToast.show(context, message: 'Bill sent on WhatsApp ✓');
      context.go('/bill-sent');
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(newBillProvider);

    return Scaffold(
      backgroundColor: AppColors.kOrange,
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _buildBody(context, data),
      ),
      bottomNavigationBar: asyncState.maybeWhen(
        data: (data) => BottomActionBar(
          primaryLabel: Formatters.formatINR(data.total),
          secondaryLabel: data.selectedCustomer?.name ?? '',
          ctaLabel: 'Send on WhatsApp',
          ctaLeadingIcon: const Icon(
            Icons.chat,
            size: 18,
            color: Colors.white,
          ),
          isCtaLoading: data.isSubmitting,
          onCtaTap: data.canSubmit && !data.isSubmitting ? _onSend : null,
        ),
        orElse: () => const SizedBox(height: 72),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NewBillState data) {
    return Column(
      children: [
        // ── ORANGE GRADIENT HEADER ────────────────────────────
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            AppSpacing.s16,
            MediaQuery.of(context).padding.top + AppSpacing.s8,
            AppSpacing.s16,
            AppSpacing.s24,
          ),
          decoration: const BoxDecoration(gradient: AppColors.kGradientOrange),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _HeaderCircleButton(
                    icon: Icons.arrow_back,
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                  Text(
                    'Bill Preview',
                    style: AppTypography.h3.copyWith(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  _HeaderCircleButton(
                    icon: Icons.share,
                    onTap: () {
                      // TODO: share PDF via system share sheet when PDF generation is wired up
                    },
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.s16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.s16,
                  vertical: AppSpacing.s12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: AppSpacing.rSm,
                ),
                child: Text(
                  '${MockFixtures.shopName} · ${data.selectedCustomer?.name ?? '—'} · '
                  '${Formatters.formatINR(data.total)}',
                  style: AppTypography.body.copyWith(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── WHITE BODY ─────────────────────────────────────────
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.kBgCard,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                SizedBox(height: AppSpacing.s16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DarkPillButton(
                      label: 'Bill',
                      isSelected: _tab == _PreviewTab.bill,
                      onTap: () => setState(() => _tab = _PreviewTab.bill),
                    ),
                    SizedBox(width: AppSpacing.s8),
                    DarkPillButton(
                      label: 'Shop Info',
                      isSelected: _tab == _PreviewTab.shopInfo,
                      onTap: () => setState(() => _tab = _PreviewTab.shopInfo),
                    ),
                    SizedBox(width: AppSpacing.s8),
                    DarkPillButton(
                      label: 'Notes',
                      isSelected: _tab == _PreviewTab.notes,
                      onTap: () => setState(() => _tab = _PreviewTab.notes),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.s16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                    child: switch (_tab) {
                      _PreviewTab.bill => _buildBillTab(data),
                      _PreviewTab.shopInfo => _buildShopInfoTab(),
                      _PreviewTab.notes => _buildNotesTab(data),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBillTab(NewBillState data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kBorderGray),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // BILL HEADER
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        MockFixtures.shopName,
                        style: AppTypography.body.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        MockFixtures.shopGst,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // BILL META ROW
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BILL NO', style: AppTypography.labelSmall),
                    Text(
                      '#${data.billNumber}',
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.kDark,
                      ),
                    ),
                  ],
                ),
                Text(
                  Formatters.formatDateTime(DateTime.now()),
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),

          // BILLED TO
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BILLED TO', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s4),
                Text(
                  data.selectedCustomer?.name ?? '—',
                  style: AppTypography.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kDark,
                  ),
                ),
                if ((data.selectedCustomer?.phone ?? '').isNotEmpty)
                  Text(
                    data.selectedCustomer!.phone,
                    style: AppTypography.body.copyWith(fontSize: 13),
                  ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s12),
          const Divider(height: 1, color: AppColors.kDivider),

          // ITEMS TABLE
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            child: Column(
              children: [
                SizedBox(height: AppSpacing.s12),
                Row(
                  children: [
                    Expanded(
                      flex: 20,
                      child: Text('Item', style: _tableHeaderStyle),
                    ),
                    Expanded(
                      flex: 10,
                      child: Text('Qty', style: _tableHeaderStyle),
                    ),
                    Expanded(
                      flex: 10,
                      child: Text('Rate', style: _tableHeaderStyle),
                    ),
                    Expanded(
                      flex: 12,
                      child: Text(
                        'Amount',
                        textAlign: TextAlign.right,
                        style: _tableHeaderStyle,
                      ),
                    ),
                  ],
                ),
                for (final item in data.items) ...[
                  const Divider(height: 1, color: AppColors.kDivider),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.s8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 20,
                          child: Text(
                            item.name,
                            style: AppTypography.body.copyWith(
                              fontSize: 13,
                              color: AppColors.kDark,
                            ),
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
                          flex: 10,
                          child: Text(
                            item.rate.toStringAsFixed(0),
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
                              color: AppColors.kDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: AppSpacing.s8),
              ],
            ),
          ),

          // TOTALS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            child: Column(
              children: [
                _totalRow('Subtotal', data.subtotal),
                _totalRow('CGST (2.5%)', data.gst / 2),
                _totalRow('SGST (2.5%)', data.gst / 2),
                SizedBox(height: AppSpacing.s8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GRAND TOTAL',
                      style: AppTypography.body.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kOrange,
                      ),
                    ),
                    Text(
                      Formatters.formatINR(data.total),
                      style: AppTypography.body.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kOrange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.s12),
              ],
            ),
          ),

          // FOOTER
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s8,
            ),
            color: const Color(0xFFF8F8F8),
            child: Column(
              children: [
                Text(
                  'Thank you for shopping at ${MockFixtures.shopName}',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption,
                ),
                Text(
                  MockFixtures.shopPhone,
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopInfoTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow('Shop Name', MockFixtures.shopName),
        _infoRow('Address', '—'),
        _infoRow('GST Number', MockFixtures.shopGst),
        _infoRow('WhatsApp Number', MockFixtures.shopPhone),
      ],
    );
  }

  Widget _buildNotesTab(NewBillState data) {
    if (data.notes.trim().isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.s48),
        child: Center(
          child: Text(
            'No notes added',
            style: AppTypography.body.copyWith(
              fontSize: 14,
              color: const Color(0xFFCCCCCC),
            ),
          ),
        ),
      );
    }
    return Text(data.notes, style: AppTypography.body);
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelSmall),
          SizedBox(height: AppSpacing.s4),
          Text(
            value,
            style: AppTypography.body.copyWith(
              fontSize: 14,
              color: AppColors.kDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, double amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.body.copyWith(fontSize: 13)),
          Text(
            Formatters.formatINR(amount),
            style: AppTypography.body.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }

  static final _tableHeaderStyle = AppTypography.caption.copyWith(
    fontSize: 10,
    color: const Color(0xFFCCCCCC),
  );
}

class _HeaderCircleButton extends StatelessWidget {
  const _HeaderCircleButton({required this.icon, required this.onTap});

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
