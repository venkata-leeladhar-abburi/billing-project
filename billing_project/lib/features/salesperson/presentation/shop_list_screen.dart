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
import '../domain/shop_list_notifier.dart';

class ShopListScreen extends ConsumerStatefulWidget {
  const ShopListScreen({super.key});

  @override
  ConsumerState<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends ConsumerState<ShopListScreen> {
  final _searchController = TextEditingController();
  String _filter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  List<ShopModel> _applyFilters(List<ShopModel> shops) {
    final query = _searchController.text.trim().toLowerCase();

    return shops.where((shop) {
      final matchesQuery = query.isEmpty ||
          shop.shopName.toLowerCase().contains(query) ||
          shop.ownerName.toLowerCase().contains(query);
      if (!matchesQuery) return false;

      switch (_filter) {
        case 'active':
          return shop.status == ShopStatus.active;
        case 'pending':
          return shop.status == ShopStatus.pendingSetup;
        case 'suspended':
          return shop.status == ShopStatus.suspended;
        case 'basic':
          return shop.plan == SubscriptionPlan.basic;
        case 'pro':
          return shop.plan == SubscriptionPlan.pro;
        case 'business':
          return shop.plan == SubscriptionPlan.business;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(shopListProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.kDark),
          onPressed: () => context.go('/salesperson/dashboard'),
        ),
        title: Text('My Shops', style: AppTypography.h3.copyWith(fontSize: 17)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt, color: AppColors.kDark),
            onPressed: () => context.push('/salesperson/shops/add/details'),
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

  Widget _buildBody(BuildContext context, ShopListState data) {
    final filtered = _applyFilters(data.shops);
    final active = data.shops.where((s) => s.status == ShopStatus.active).length;
    final pending = data.shops.where((s) => s.status == ShopStatus.pendingSetup).length;

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.kBgPage,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
          child: Text(
            '${data.shops.length} shops · $active active · $pending pending setup',
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
              hintText: 'Search shop name or owner name',
              hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.kMuted),
              prefixIcon: const Icon(Icons.search, color: AppColors.kMuted),
              filled: true,
              fillColor: AppColors.kBgCard,
              contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
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
            FilterChipData(value: 'active', label: 'Active'),
            FilterChipData(value: 'pending', label: 'Pending Setup'),
            FilterChipData(value: 'suspended', label: 'Suspended'),
            FilterChipData(value: 'basic', label: 'Basic'),
            FilterChipData(value: 'pro', label: 'Pro'),
            FilterChipData(value: 'business', label: 'Business'),
          ],
          selectedValue: _filter,
          onSelect: (value) => setState(() => _filter = value),
        ),
        SizedBox(height: AppSpacing.s12),
        Expanded(
          child: filtered.isEmpty
              ? EmptyState(
                  type: EmptyStateType.shops,
                  title: data.shops.isEmpty ? 'No shops found' : 'No shops found',
                  subtitle: data.shops.isEmpty ? 'Add your first shop to get started' : 'Try a different filter',
                  ctaLabel: 'Add New Shop',
                  onCtaTap: () => context.push('/salesperson/shops/add/details'),
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s4),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => SizedBox(height: AppSpacing.s8),
                  itemBuilder: (context, index) {
                    final shop = filtered[index];
                    return AppCard(
                      onTap: () => context.push('/salesperson/shops/${shop.id}'),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(color: AppColors.kOrangeLight, shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: Text(
                              _initials(shop.shopName),
                              style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.kOrange),
                            ),
                          ),
                          SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(shop.shopName, style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                                SizedBox(height: AppSpacing.s4),
                                Text('Owner: ${shop.ownerName}', style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kSecondary)),
                                if (shop.addedDate != null)
                                  Text('Added: ${Formatters.formatDate(shop.addedDate!)}', style: AppTypography.caption),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              PlanBadge(plan: shop.plan),
                              SizedBox(height: AppSpacing.s8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(color: shop.status.dotColor, shape: BoxShape.circle),
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
  }
}
