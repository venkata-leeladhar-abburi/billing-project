import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/bill_model.dart';
import '../../../shared/widgets/bill_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/filter_chip_row.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/bill_history_notifier.dart';

class BillHistoryScreen extends ConsumerStatefulWidget {
  const BillHistoryScreen({this.customerId, super.key});

  final String? customerId;

  @override
  ConsumerState<BillHistoryScreen> createState() => _BillHistoryScreenState();
}

class _BillHistoryScreenState extends ConsumerState<BillHistoryScreen> {
  bool _searchVisible = false;
  final _searchController = TextEditingController();
  String _filter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BillModel> _applyFilters(List<BillModel> bills) {
    final now = DateTime.now();
    final query = _searchController.text.trim().toLowerCase();

    return bills.where((bill) {
      if (widget.customerId != null && bill.customerId != widget.customerId) {
        return false;
      }
      final matchesQuery =
          query.isEmpty ||
          bill.customerName.toLowerCase().contains(query) ||
          bill.total.toString().contains(query);
      if (!matchesQuery) return false;

      if (bill.sentAt == null) return _filter == 'all';
      final diff = now.difference(bill.sentAt!);
      switch (_filter) {
        case 'today':
          return diff.inHours < 24 && now.day == bill.sentAt!.day;
        case 'this_week':
          return diff.inDays <= 7;
        case 'this_month':
          return diff.inDays <= 31;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(billHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.kDark),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text(
          'Bill History',
          style: AppTypography.h3.copyWith(fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.kDark),
            onPressed: () => setState(() => _searchVisible = !_searchVisible),
          ),
        ],
      ),
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _buildBody(context, data),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BillHistoryState data) {
    final filtered = _applyFilters(data.bills);

    return Column(
      children: [
        if (_searchVisible)
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.s16,
              AppSpacing.s12,
              AppSpacing.s16,
              0,
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search by customer name or amount',
                hintStyle: AppTypography.bodyLarge.copyWith(
                  color: AppColors.kMuted,
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.kMuted),
                filled: true,
                fillColor: AppColors.kBgCard,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.s16,
                  vertical: AppSpacing.s16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.kBorderGray),
                ),
              ),
            ),
          ),
        SizedBox(height: AppSpacing.s12),
        FilterChipRow(
          chips: const [
            FilterChipData(value: 'all', label: 'All'),
            FilterChipData(value: 'today', label: 'Today'),
            FilterChipData(value: 'this_week', label: 'This Week'),
            FilterChipData(value: 'this_month', label: 'This Month'),
          ],
          selectedValue: _filter,
          onSelect: (value) => setState(() => _filter = value),
        ),
        SizedBox(height: AppSpacing.s12),
        Expanded(
          child: data.bills.isEmpty
              ? EmptyState(
                  type: EmptyStateType.bills,
                  title: 'No bills yet',
                  subtitle: 'Tap New Bill to send your first bill',
                  ctaLabel: 'Send a Bill',
                  onCtaTap: () => context.go('/new-bill'),
                )
              : filtered.isEmpty
              ? Center(
                  child: Text(
                    'No matching bills',
                    style: AppTypography.body.copyWith(color: AppColors.kMuted),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.s16,
                    vertical: AppSpacing.s4,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: AppSpacing.s8),
                  itemBuilder: (context, index) {
                    final bill = filtered[index];
                    return BillCard(
                      bill: bill,
                      onTap: () => context.push('/bill/${bill.id}'),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
