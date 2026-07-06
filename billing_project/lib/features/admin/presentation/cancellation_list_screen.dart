import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/cancellation_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/filter_chip_row.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/status_badge.dart';
import '../domain/admin_cancellation_list_notifier.dart';

class AdminCancellationListScreen extends ConsumerStatefulWidget {
  const AdminCancellationListScreen({super.key});

  @override
  ConsumerState<AdminCancellationListScreen> createState() => _AdminCancellationListScreenState();
}

class _AdminCancellationListScreenState extends ConsumerState<AdminCancellationListScreen> {
  String _filter = 'all';

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

  String _sortLabel(CancellationSort sort) {
    switch (sort) {
      case CancellationSort.newest:
        return 'Newest';
      case CancellationSort.oldest:
        return 'Oldest';
      case CancellationSort.planValue:
        return 'Plan Value';
    }
  }

  void _cycleSort(WidgetRef ref, CancellationSort current) {
    const order = [CancellationSort.newest, CancellationSort.oldest, CancellationSort.planValue];
    final next = order[(order.indexOf(current) + 1) % order.length];
    ref.read(adminCancellationListProvider.notifier).setSort(next);
  }

  Widget _requestCard(CancellationRequest r) {
    return AppCard(
      onTap: () => context.push('/admin/cancellations/${r.id}'),
      margin: EdgeInsets.only(bottom: AppSpacing.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(r.shopName, style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
              Text(r.salespersonName, style: AppTypography.caption.copyWith(fontSize: 11)),
            ],
          ),
          SizedBox(height: AppSpacing.s4),
          Text('Reason: ${r.reason}', maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kSecondary)),
          SizedBox(height: AppSpacing.s4),
          Text('Plan: ${r.planName} · ${Formatters.formatINR(r.monthlyAmount)}/mo', style: AppTypography.caption),
          SizedBox(height: AppSpacing.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Submitted: ${Formatters.formatRelativeTime(r.requestedDate)}', style: AppTypography.caption.copyWith(fontSize: 11)),
              StatusBadge(label: _statusLabel(r.status), type: _statusType(r.status)),
            ],
          ),
          if (r.status != CancellationStatus.pending) ...[
            SizedBox(height: AppSpacing.s4),
            Text('Actioned by ${r.salespersonName}', style: AppTypography.caption.copyWith(fontSize: 11)),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminCancellationListProvider);

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
        title: Text('Cancellation Requests', style: AppTypography.h3.copyWith(fontSize: 17)),
      ),
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (data) {
          final filtered = data.sorted.where((r) {
            switch (_filter) {
              case 'pending':
                return r.status == CancellationStatus.pending;
              case 'approved':
                return r.status == CancellationStatus.approved;
              case 'rejected':
                return r.status == CancellationStatus.rejected;
              default:
                return true;
            }
          }).toList();
          final pending = filtered.where((r) => r.status == CancellationStatus.pending).toList();
          final rest = filtered.where((r) => r.status != CancellationStatus.pending).toList();

          if (filtered.isEmpty) {
            return const EmptyState(
              type: EmptyStateType.generic,
              title: 'No cancellation requests',
              subtitle: 'All shops are active and in good standing',
            );
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.s16, AppSpacing.s12, AppSpacing.s16, AppSpacing.s12),
                child: Text(
                  '${data.pendingCount} pending · ${data.approvedCount} approved · ${data.rejectedCount} rejected',
                  style: AppTypography.body.copyWith(fontSize: 12, color: data.pendingCount > 0 ? AppColors.kError : AppColors.kSecondary),
                ),
              ),
              FilterChipRow(
                chips: const [
                  FilterChipData(value: 'all', label: 'All'),
                  FilterChipData(value: 'pending', label: 'Pending'),
                  FilterChipData(value: 'approved', label: 'Approved'),
                  FilterChipData(value: 'rejected', label: 'Rejected'),
                ],
                selectedValue: _filter,
                onSelect: (v) => setState(() => _filter = v),
              ),
              SizedBox(height: AppSpacing.s8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => _cycleSort(ref, data.sort),
                    child: Text('Sort: ${_sortLabel(data.sort)}', style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kOrange)),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.s8),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                  children: [
                    if (pending.isNotEmpty) ...[
                      Text('NEEDS ACTION (${pending.length})', style: AppTypography.labelSmall.copyWith(color: AppColors.kError)),
                      SizedBox(height: AppSpacing.s8),
                      for (final r in pending) _requestCard(r),
                      SizedBox(height: AppSpacing.s16),
                    ],
                    if (rest.isNotEmpty) ...[
                      Text('ALL REQUESTS', style: AppTypography.labelSmall),
                      SizedBox(height: AppSpacing.s8),
                      for (final r in rest) _requestCard(r),
                    ],
                    SizedBox(height: AppSpacing.s24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
