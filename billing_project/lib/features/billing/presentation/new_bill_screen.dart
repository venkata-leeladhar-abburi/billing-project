import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/mock/mock_fixtures.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/bottom_action_bar.dart';
import '../../../shared/widgets/confirm_bottom_sheet.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/new_bill_notifier.dart';

class NewBillScreen extends ConsumerStatefulWidget {
  const NewBillScreen({super.key});

  @override
  ConsumerState<NewBillScreen> createState() => _NewBillScreenState();
}

class _NewBillScreenState extends ConsumerState<NewBillScreen> {
  final _searchController = TextEditingController();
  final _notesController = TextEditingController();
  final Map<String, _ItemControllers> _itemControllers = {};

  @override
  void dispose() {
    _searchController.dispose();
    _notesController.dispose();
    for (final c in _itemControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  _ItemControllers _controllersFor(NewBillItem item) {
    return _itemControllers.putIfAbsent(
      item.id,
      () => _ItemControllers(
        name: TextEditingController(text: item.name),
        qty: TextEditingController(text: item.qty.toString()),
        rate: TextEditingController(
          text: item.rate == 0 ? '' : item.rate.toString(),
        ),
      ),
    );
  }

  Future<bool> _confirmDiscard(bool hasItems) async {
    if (!hasItems) return true;
    final confirmed = await ConfirmBottomSheet.show(
      context,
      title: 'Discard this bill?',
      body: 'Your bill items will be lost.',
      confirmLabel: 'Discard',
      cancelLabel: 'Keep Editing',
      isDestructive: true,
    );
    return confirmed == true;
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(newBillProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.kDark),
          onPressed: () async {
            final hasItems =
                asyncState.value?.items.any((i) => i.name.isNotEmpty) ?? false;
            if (await _confirmDiscard(hasItems)) {
              if (context.mounted) context.go('/dashboard');
            }
          },
        ),
        title: Text(
          'New Bill',
          style: AppTypography.h3.copyWith(fontSize: 17),
        ),
      ),
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _buildBody(context, data),
      ),
      bottomNavigationBar: asyncState.maybeWhen(
        data: (data) => BottomActionBar(
          secondaryLabel: '1 credit will be used',
          creditInfo: '${MockFixtures.billCredits} remaining',
          creditInfoColor: _creditColor(),
          ctaLabel: 'Preview Bill →',
          isCtaLoading: false,
          onCtaTap: data.canSubmit ? () => context.push('/bill-preview') : null,
        ),
        orElse: () => const SizedBox(height: 72),
      ),
    );
  }

  Color _creditColor() {
    final pct = MockFixtures.billCredits / MockFixtures.billCreditsMax;
    if (pct > 0.5) return AppColors.kGreen;
    if (pct > 0.2) return AppColors.kWarning;
    return AppColors.kError;
  }

  Widget _buildBody(BuildContext context, NewBillState data) {
    final notifier = ref.read(newBillProvider.notifier);
    final query = _searchController.text.trim().toLowerCase();
    final filteredCustomers = query.isEmpty
        ? <MockCustomer>[]
        : data.customers
              .where(
                (c) =>
                    c.name.toLowerCase().contains(query) ||
                    c.phone.contains(query),
              )
              .toList();

    return ListView(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s16),
      children: [
        // ── CUSTOMER SECTION ──────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CUSTOMER', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s12),
                if (data.selectedCustomer != null)
                  _buildSelectedCustomerChip(data.selectedCustomer!, notifier)
                else ...[
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Search by name or number',
                      hintStyle: AppTypography.bodyLarge.copyWith(
                        color: AppColors.kMuted,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.kMuted,
                      ),
                      filled: true,
                      fillColor: AppColors.kBgCard,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                        vertical: AppSpacing.s16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.kBorderGray,
                        ),
                      ),
                    ),
                  ),
                  if (query.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.s8),
                    for (final customer in filteredCustomers)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          customer.name,
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.kDark,
                          ),
                        ),
                        subtitle: Text(
                          customer.phone,
                          style: AppTypography.caption,
                        ),
                        onTap: () {
                          notifier.selectCustomer(customer);
                          _searchController.clear();
                          setState(() {});
                        },
                      ),
                    if (filteredCustomers.isEmpty)
                      GestureDetector(
                        onTap: () {
                          notifier.addNewCustomerMock(
                            _searchController.text.trim(),
                          );
                          _searchController.clear();
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.s8,
                          ),
                          child: Text(
                            "Add '${_searchController.text.trim()}' as new customer →",
                            style: AppTypography.body.copyWith(
                              fontSize: 13,
                              color: AppColors.kOrange,
                            ),
                          ),
                        ),
                      ),
                  ],
                ],
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.s16),

        // ── BILL ITEMS SECTION ────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BILL ITEMS', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s12),
                Row(
                  children: [
                    Expanded(
                      flex: 20,
                      child: Text('Item', style: _columnHeaderStyle),
                    ),
                    Expanded(
                      flex: 10,
                      child: Text('Qty', style: _columnHeaderStyle),
                    ),
                    Expanded(
                      flex: 10,
                      child: Text('Rate', style: _columnHeaderStyle),
                    ),
                    Expanded(
                      flex: 12,
                      child: Text(
                        'Amount',
                        textAlign: TextAlign.right,
                        style: _columnHeaderStyle,
                      ),
                    ),
                  ],
                ),
                for (var i = 0; i < data.items.length; i++) ...[
                  const Divider(height: 1, color: AppColors.kDivider),
                  _buildItemRow(i, data.items[i], notifier),
                ],
                SizedBox(height: AppSpacing.s8),
                GestureDetector(
                  onTap: notifier.addItem,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.s8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.add,
                          size: 16,
                          color: AppColors.kOrange,
                        ),
                        SizedBox(width: AppSpacing.s4),
                        Text(
                          'Add item',
                          style: AppTypography.body.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.s16),

        // ── TOTALS SECTION ────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: AppCard(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTotalRow('Subtotal', data.subtotal),
                _buildTotalRow(
                  'GST (${(data.gstRate * 100).toStringAsFixed(0)}%)',
                  data.gst,
                ),
                SizedBox(height: AppSpacing.s8),
                const Divider(height: 1, color: AppColors.kDivider),
                SizedBox(height: AppSpacing.s8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: AppTypography.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kDark,
                      ),
                    ),
                    Text(
                      Formatters.formatINR(data.total),
                      style: AppTypography.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.s4),
                Text('GST included', style: AppTypography.caption),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.s16),

        // ── NOTES SECTION ─────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NOTES (OPTIONAL)', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s12),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  onChanged: notifier.updateNotes,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Add a note for this bill...',
                    hintStyle: AppTypography.bodyLarge.copyWith(
                      color: AppColors.kMuted,
                    ),
                    filled: true,
                    fillColor: AppColors.kBgCard,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.s16,
                      vertical: AppSpacing.s12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.kBorderGray),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.s48 + AppSpacing.s32),
      ],
    );
  }

  static final _columnHeaderStyle = AppTypography.caption.copyWith(
    fontSize: 10,
    color: const Color(0xFFCCCCCC),
  );

  Widget _buildSelectedCustomerChip(
    MockCustomer customer,
    NewBillNotifier notifier,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.kOrange),
        borderRadius: AppSpacing.rPill,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  customer.name,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.kDark,
                  ),
                ),
                if (customer.phone.isNotEmpty)
                  Text(customer.phone, style: AppTypography.caption),
              ],
            ),
          ),
          GestureDetector(
            onTap: notifier.clearCustomer,
            child: const Icon(Icons.close, size: 18, color: AppColors.kOrange),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(int index, NewBillItem item, NewBillNotifier notifier) {
    final controllers = _controllersFor(item);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 20,
            child: TextField(
              controller: controllers.name,
              style: AppTypography.body.copyWith(fontSize: 13),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Item name',
              ),
              onChanged: (value) => notifier.updateItem(index, name: value),
            ),
          ),
          Expanded(
            flex: 10,
            child: TextField(
              controller: controllers.qty,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTypography.body.copyWith(fontSize: 13),
              decoration: const InputDecoration(isDense: true, border: InputBorder.none),
              onChanged: (value) =>
                  notifier.updateItem(index, qty: int.tryParse(value) ?? 0),
            ),
          ),
          Expanded(
            flex: 10,
            child: TextField(
              controller: controllers.rate,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              style: AppTypography.body.copyWith(fontSize: 13),
              decoration: const InputDecoration(isDense: true, border: InputBorder.none),
              onChanged: (value) => notifier.updateItem(
                index,
                rate: double.tryParse(value) ?? 0,
              ),
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
    );
  }

  Widget _buildTotalRow(String label, double amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.body),
          Text(Formatters.formatINR(amount), style: AppTypography.body),
        ],
      ),
    );
  }
}

class _ItemControllers {
  _ItemControllers({
    required this.name,
    required this.qty,
    required this.rate,
  });

  final TextEditingController name;
  final TextEditingController qty;
  final TextEditingController rate;

  void dispose() {
    name.dispose();
    qty.dispose();
    rate.dispose();
  }
}
