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
import '../../../shared/widgets/status_badge.dart';
import '../domain/cancellation_list_notifier.dart';
import '../../../core/models/cancellation_model.dart';

class CancellationListScreen extends ConsumerStatefulWidget {
  const CancellationListScreen({super.key});

  @override
  ConsumerState<CancellationListScreen> createState() => _CancellationListScreenState();
}

class _CancellationListScreenState extends ConsumerState<CancellationListScreen> {
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cancellationListProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Cancellation Requests', style: AppTypography.h3.copyWith(fontSize: 17)),
      ),
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (data) {
          final filtered = data.requests.where((r) {
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

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.s16, AppSpacing.s12, AppSpacing.s16, AppSpacing.s12),
                child: Text(
                  '${data.requests.length} requests · ${data.pendingCount} pending',
                  style: AppTypography.caption,
                ),
              ),
              FilterChipRow(
                selectedValue: _filter,
                onSelect: (v) => setState(() => _filter = v),
                chips: [
                  FilterChipData(value: 'all', label: 'All'),
                  FilterChipData(value: 'pending', label: 'Pending', count: data.pendingCount),
                  FilterChipData(value: 'approved', label: 'Approved', count: data.approvedCount),
                  FilterChipData(value: 'rejected', label: 'Rejected', count: data.rejectedCount),
                ],
              ),
              SizedBox(height: AppSpacing.s12),
              Expanded(
                child: filtered.isEmpty
                    ? const EmptyState(
                        type: EmptyStateType.generic,
                        title: 'No requests found',
                        subtitle: 'There are no cancellation requests matching this filter.',
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(AppSpacing.s16, 0, AppSpacing.s16, AppSpacing.s24),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => SizedBox(height: AppSpacing.s8),
                        itemBuilder: (context, i) {
                          final r = filtered[i];
                          return AppCard(
                            onTap: () => context.push('/salesperson/cancellations/${r.id}'),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(r.shopName, style: AppTypography.body.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
                                      SizedBox(height: AppSpacing.s4),
                                      Text('${r.ownerName} · ${r.planName} · ${Formatters.formatINR(r.monthlyAmount)}/mo', style: AppTypography.caption),
                                      SizedBox(height: AppSpacing.s4),
                                      Text('Reason: ${r.reason}', style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kSecondary)),
                                      SizedBox(height: AppSpacing.s4),
                                      Text(Formatters.formatRelativeTime(r.requestedDate), style: AppTypography.caption.copyWith(fontSize: 11)),
                                    ],
                                  ),
                                ),
                                StatusBadge(label: _statusLabel(r.status), type: _statusType(r.status)),
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
