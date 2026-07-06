import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/shop_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/filter_chip_row.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/plan_badge.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../domain/admin_mock_salespersons.dart';
import '../domain/all_shops_notifier.dart';

class AllShopsScreen extends ConsumerStatefulWidget {
  const AllShopsScreen({super.key});

  @override
  ConsumerState<AllShopsScreen> createState() => _AllShopsScreenState();
}

class _AllShopsScreenState extends ConsumerState<AllShopsScreen> {
  final _searchController = TextEditingController();
  String _statusFilter = 'all';
  String _planFilter = 'all';
  String? _salespersonFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    return parts.first[0].toUpperCase();
  }

  List<ShopModel> _applyFilters(List<ShopModel> shops) {
    final query = _searchController.text.trim().toLowerCase();
    return shops.where((shop) {
      final matchesQuery = query.isEmpty ||
          shop.shopName.toLowerCase().contains(query) ||
          shop.ownerName.toLowerCase().contains(query) ||
          shop.phone.contains(query) ||
          shop.city.toLowerCase().contains(query);
      if (!matchesQuery) return false;

      if (_salespersonFilter != null && shop.salespersonName != _salespersonFilter) return false;

      switch (_statusFilter) {
        case 'active':
          if (shop.status != ShopStatus.active) return false;
        case 'pending':
          if (shop.status != ShopStatus.pendingSetup) return false;
        case 'suspended':
          if (shop.status != ShopStatus.suspended) return false;
        case 'payment_failed':
          if (shop.autopayStatus != AutoPayStatus.failed) return false;
      }

      switch (_planFilter) {
        case 'basic':
          if (shop.plan != SubscriptionPlan.basic) return false;
        case 'pro':
          if (shop.plan != SubscriptionPlan.pro) return false;
        case 'business':
          if (shop.plan != SubscriptionPlan.business) return false;
      }

      return true;
    }).toList();
  }

  Future<void> _showAdvancedFilter(BuildContext context) async {
    final salespersons = buildMockSalespersons();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Padding(
          padding: EdgeInsets.all(AppSpacing.s16),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Advanced Filters', style: AppTypography.h3.copyWith(fontSize: 16)),
                SizedBox(height: AppSpacing.s16),
                Text('SALESPERSON', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s8),
                DropdownButtonFormField<String?>(
                  initialValue: _salespersonFilter,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.kBgPage,
                    contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.kBorderGray)),
                  ),
                  hint: const Text('All salespersons'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All salespersons')),
                    for (final s in salespersons) DropdownMenuItem(value: s.name, child: Text(s.name)),
                  ],
                  onChanged: (v) => setSheetState(() => _salespersonFilter = v),
                ),
                SizedBox(height: AppSpacing.s20),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: 'Reset',
                        onTap: () {
                          setSheetState(() => _salespersonFilter = null);
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {});
                          Navigator.of(sheetContext).pop();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.kOrange, minimumSize: const Size.fromHeight(48)),
                        child: const Text('Apply Filters', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(allShopsProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.kDark),
          onPressed: () => context.go('/admin/dashboard'),
        ),
        title: Text('All Shops', style: AppTypography.h3.copyWith(fontSize: 17)),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.kDark),
            onPressed: () => _showAdvancedFilter(context),
          ),
        ],
      ),
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (data) {
          final filtered = _applyFilters(data.shops);

          return Column(
            children: [
              Container(
                width: double.infinity,
                color: AppColors.kBgPage,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
                child: Text(
                  '${data.shops.length} shops · ${data.activeCount} active · ${Formatters.formatINR(data.mrr)} MRR',
                  style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kSecondary),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search shop name, owner, phone, city',
                    hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.kMuted),
                    prefixIcon: const Icon(Icons.search, color: AppColors.kMuted),
                    filled: true,
                    fillColor: AppColors.kBgCard,
                    contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.kBorderGray)),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.s12),
              FilterChipRow(
                chips: const [
                  FilterChipData(value: 'all', label: 'All'),
                  FilterChipData(value: 'active', label: 'Active'),
                  FilterChipData(value: 'pending', label: 'Pending'),
                  FilterChipData(value: 'suspended', label: 'Suspended'),
                  FilterChipData(value: 'payment_failed', label: 'Payment Failed'),
                ],
                selectedValue: _statusFilter,
                onSelect: (v) => setState(() => _statusFilter = v),
              ),
              SizedBox(height: AppSpacing.s8),
              FilterChipRow(
                chips: const [
                  FilterChipData(value: 'all', label: 'All Plans'),
                  FilterChipData(value: 'basic', label: 'Basic'),
                  FilterChipData(value: 'pro', label: 'Pro'),
                  FilterChipData(value: 'business', label: 'Business'),
                ],
                selectedValue: _planFilter,
                onSelect: (v) => setState(() => _planFilter = v),
              ),
              SizedBox(height: AppSpacing.s12),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(
                        type: EmptyStateType.generic,
                        title: 'No shops found',
                        subtitle: 'Try adjusting your filters',
                        ctaLabel: 'Clear Filters',
                        onCtaTap: () => setState(() {
                          _searchController.clear();
                          _statusFilter = 'all';
                          _planFilter = 'all';
                          _salespersonFilter = null;
                        }),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s4),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => SizedBox(height: AppSpacing.s8),
                        itemBuilder: (context, i) {
                          final shop = filtered[i];
                          return AppCard(
                            onTap: () => context.push('/admin/shops/${shop.id}'),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(color: AppColors.kOrangeLight, shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Text(_initials(shop.shopName), style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.kOrange)),
                                ),
                                SizedBox(width: AppSpacing.s12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(shop.shopName, style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                                      SizedBox(height: AppSpacing.s4),
                                      Text('Salesperson: ${shop.salespersonName ?? '—'}', style: AppTypography.caption.copyWith(fontSize: 11)),
                                      SizedBox(height: AppSpacing.s4),
                                      Text('${shop.city} · ${shop.businessType}', style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kSecondary)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    PlanBadge(plan: shop.plan),
                                    SizedBox(height: AppSpacing.s8),
                                    Row(
                                      children: [
                                        Text(Formatters.formatINR(shop.monthlyAmount), style: AppTypography.body.copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.kOrange)),
                                        SizedBox(width: AppSpacing.s8),
                                        Container(width: 8, height: 8, decoration: BoxDecoration(color: shop.status.dotColor, shape: BoxShape.circle)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
