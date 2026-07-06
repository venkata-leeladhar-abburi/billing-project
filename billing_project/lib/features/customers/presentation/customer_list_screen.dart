import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/customer_model.dart';
import '../../../shared/widgets/customer_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/filter_chip_row.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/customer_notifier.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() =>
      _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final _searchController = TextEditingController();
  String _filter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CustomerModel> _applyFilters(List<CustomerModel> customers) {
    final query = _searchController.text.trim().toLowerCase();
    final now = DateTime.now();

    return customers.where((customer) {
      final matchesQuery =
          query.isEmpty ||
          customer.name.toLowerCase().contains(query) ||
          customer.phone.contains(query);
      if (!matchesQuery) return false;

      switch (_filter) {
        case 'billed_recently':
          return customer.lastBilledAt != null &&
              now.difference(customer.lastBilledAt!).inDays <= 7;
        case 'high_value':
          return customer.totalBilled > 10000;
        case 'new':
          return customer.addedAt != null &&
              now.difference(customer.addedAt!).inDays <= 30;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(customerProvider);

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
        title: Text('Customers', style: AppTypography.h3.copyWith(fontSize: 17)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.kDark),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_add_alt, color: AppColors.kDark),
            onPressed: () => context.push('/customers/add'),
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

  Widget _buildBody(BuildContext context, CustomerListState data) {
    final filtered = _applyFilters(data.customers);

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.kBgPage,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s12,
          ),
          child: Row(
            children: [
              Text(
                '${data.customers.length} customers',
                style: AppTypography.body.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kDark,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // TODO: wire CSV import (Pro/Business plan only) when backend ready
                },
                child: Text(
                  'Import',
                  style: AppTypography.body.copyWith(
                    fontSize: 13,
                    color: AppColors.kOrange,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search by name or phone number',
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
            FilterChipData(value: 'billed_recently', label: 'Billed Recently'),
            FilterChipData(value: 'high_value', label: 'High Value'),
            FilterChipData(value: 'new', label: 'New'),
          ],
          selectedValue: _filter,
          onSelect: (value) => setState(() => _filter = value),
        ),
        SizedBox(height: AppSpacing.s12),
        Expanded(
          child: filtered.isEmpty
              ? (data.customers.isEmpty
                    ? EmptyState(
                        type: EmptyStateType.customers,
                        title: 'No customers yet',
                        subtitle: 'Add your first customer to get started',
                        ctaLabel: 'Add Customer',
                        onCtaTap: () => context.push('/customers/add'),
                      )
                    : Center(
                        child: Text(
                          'No matching customers',
                          style: AppTypography.body.copyWith(
                            color: AppColors.kMuted,
                          ),
                        ),
                      ))
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.s16,
                    vertical: AppSpacing.s4,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: AppSpacing.s8),
                  itemBuilder: (context, index) {
                    final customer = filtered[index];
                    return CustomerCard(
                      customer: customer,
                      onTap: () => context.push('/customers/${customer.id}'),
                    );
                  },
                ),
        ),
        SizedBox(height: AppSpacing.s16),
      ],
    );
  }
}
