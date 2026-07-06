import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/filter_chip_row.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/admin_mock_salespersons.dart';
import '../domain/salesperson_list_notifier.dart';

class SalespersonListScreen extends ConsumerStatefulWidget {
  const SalespersonListScreen({super.key});

  @override
  ConsumerState<SalespersonListScreen> createState() => _SalespersonListScreenState();
}

class _SalespersonListScreenState extends ConsumerState<SalespersonListScreen> {
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

  List<SalespersonModel> _applyFilters(List<SalespersonModel> people) {
    final query = _searchController.text.trim().toLowerCase();
    return people.where((p) {
      final matchesQuery = query.isEmpty || p.name.toLowerCase().contains(query) || p.phone.contains(query);
      if (!matchesQuery) return false;
      switch (_filter) {
        case 'active':
          return p.isActive;
        case 'inactive':
          return !p.isActive;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salespersonListProvider);

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
        title: Text('Salespersons', style: AppTypography.h3.copyWith(fontSize: 17)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt, color: AppColors.kDark),
            onPressed: () => context.push('/admin/salespersons/add'),
          ),
        ],
      ),
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (data) {
          final filtered = _applyFilters(data.salespersons);
          final active = data.salespersons.where((s) => s.isActive).length;

          return Column(
            children: [
              Container(
                width: double.infinity,
                color: AppColors.kBgPage,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
                child: Text(
                  '${data.salespersons.length} salespersons · $active active · ${data.totalShopsManaged} shops managed total',
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
                    hintText: 'Search by name or phone',
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
                  FilterChipData(value: 'inactive', label: 'Inactive'),
                ],
                selectedValue: _filter,
                onSelect: (v) => setState(() => _filter = v),
              ),
              SizedBox(height: AppSpacing.s12),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(
                        type: EmptyStateType.generic,
                        title: 'No salespersons yet',
                        subtitle: 'Add your first sales team member',
                        ctaLabel: 'Add Salesperson',
                        onCtaTap: () => context.push('/admin/salespersons/add'),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s4),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => SizedBox(height: AppSpacing.s8),
                        itemBuilder: (context, i) {
                          final person = filtered[i];
                          return AppCard(
                            onTap: () => context.push('/admin/salespersons/${person.id}'),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(color: AppColors.kOrangeLight, shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Text(_initials(person.name), style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.kOrange)),
                                ),
                                SizedBox(width: AppSpacing.s12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(person.name, style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                                      SizedBox(height: AppSpacing.s4),
                                      Text(person.phone, style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kSecondary)),
                                      SizedBox(height: AppSpacing.s4),
                                      Text('Added on: ${Formatters.formatDate(person.addedDate)}', style: AppTypography.caption),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${shopCountFor(person.name)} shops', style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
                                    SizedBox(height: AppSpacing.s8),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(color: person.isActive ? AppColors.kGreen : AppColors.kError, shape: BoxShape.circle),
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
