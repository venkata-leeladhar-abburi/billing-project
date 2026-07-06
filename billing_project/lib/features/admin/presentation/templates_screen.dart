import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/filter_chip_row.dart';
import '../../../shared/widgets/icon_container.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/template_model.dart';
import '../domain/templates_notifier.dart';

class TemplatesScreen extends ConsumerStatefulWidget {
  const TemplatesScreen({super.key});

  @override
  ConsumerState<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends ConsumerState<TemplatesScreen> {
  String _filter = 'all';

  String _statusLabel(MetaApprovalStatus status) {
    switch (status) {
      case MetaApprovalStatus.approved:
        return '✓ Approved';
      case MetaApprovalStatus.pending:
        return '⏳ Pending';
      case MetaApprovalStatus.rejected:
        return '✗ Rejected';
      case MetaApprovalStatus.inactive:
        return 'Inactive';
    }
  }

  Color _statusColor(MetaApprovalStatus status) {
    switch (status) {
      case MetaApprovalStatus.approved:
        return AppColors.kGreen;
      case MetaApprovalStatus.pending:
        return AppColors.kWarning;
      case MetaApprovalStatus.rejected:
        return AppColors.kError;
      case MetaApprovalStatus.inactive:
        return AppColors.kMuted;
    }
  }

  Color _statusBg(MetaApprovalStatus status) {
    switch (status) {
      case MetaApprovalStatus.approved:
        return AppColors.kGreenLight;
      case MetaApprovalStatus.pending:
        return const Color(0xFFFFFBEB);
      case MetaApprovalStatus.rejected:
        return const Color(0xFFFEF2F2);
      case MetaApprovalStatus.inactive:
        return const Color(0xFFF5F5F5);
    }
  }

  List<TemplateModel> _applyFilter(List<TemplateModel> templates) {
    switch (_filter) {
      case 'active':
        return templates.where((t) => t.isActive).toList();
      case 'pending':
        return templates.where((t) => t.status == MetaApprovalStatus.pending).toList();
      case 'rejected':
        return templates.where((t) => t.status == MetaApprovalStatus.rejected).toList();
      case 'inactive':
        return templates.where((t) => !t.isActive).toList();
      default:
        return templates;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(templatesProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('WhatsApp Templates', style: AppTypography.h3.copyWith(fontSize: 17)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.kDark),
            onPressed: () => context.push('/admin/templates/add'),
          ),
        ],
      ),
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (data) {
          final filtered = _applyFilter(data.templates);
          return ListView(
            padding: EdgeInsets.all(AppSpacing.s16),
            children: [
              AppCard(
                backgroundColor: data.aisensyConnected ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                leftBorderColor: data.aisensyConnected ? AppColors.kGreen : AppColors.kError,
                child: Text(
                  data.aisensyConnected ? 'AiSensy API connected · Templates synced just now' : 'AiSensy connection failed. Check API settings.',
                  style: AppTypography.body.copyWith(fontSize: 13, color: data.aisensyConnected ? AppColors.kGreen : AppColors.kError),
                ),
              ),
              SizedBox(height: AppSpacing.s16),
              FilterChipRow(
                padding: EdgeInsets.zero,
                chips: const [
                  FilterChipData(value: 'all', label: 'All'),
                  FilterChipData(value: 'active', label: 'Active'),
                  FilterChipData(value: 'pending', label: 'Pending Approval'),
                  FilterChipData(value: 'rejected', label: 'Rejected'),
                  FilterChipData(value: 'inactive', label: 'Inactive'),
                ],
                selectedValue: _filter,
                onSelect: (v) => setState(() => _filter = v),
              ),
              SizedBox(height: AppSpacing.s16),
              for (final t in filtered) ...[
                AppCard(
                  onTap: () => context.push('/admin/templates/${t.id}'),
                  margin: EdgeInsets.only(bottom: AppSpacing.s8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const IconContainer(
                            icon: Icons.storefront_outlined,
                            iconColor: AppColors.kOrange,
                            backgroundColor: AppColors.kOrangeLight,
                            size: 40,
                          ),
                          SizedBox(width: AppSpacing.s12),
                          Expanded(child: Text(t.businessType, style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700))),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
                            decoration: BoxDecoration(color: _statusBg(t.status), borderRadius: AppSpacing.rPill),
                            child: Text(_statusLabel(t.status), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor(t.status))),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.s12),
                      Text(t.templateName, style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kSecondary, fontStyle: FontStyle.italic)),
                      SizedBox(height: AppSpacing.s4),
                      Text(t.category == TemplateCategory.marketing ? 'Marketing' : 'Utility', style: AppTypography.caption.copyWith(fontSize: 11)),
                      SizedBox(height: AppSpacing.s8),
                      Text(t.body, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTypography.body.copyWith(fontSize: 13)),
                      SizedBox(height: AppSpacing.s12),
                      const Divider(height: 1),
                      SizedBox(height: AppSpacing.s8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => context.push('/admin/templates/${t.id}'),
                            child: Text('Edit', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kOrange, fontWeight: FontWeight.w600)),
                          ),
                          Switch(
                            value: t.isActive,
                            activeThumbColor: AppColors.kOrange,
                            onChanged: (_) => ref.read(templatesProvider.notifier).toggleActive(t.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              AppCard(
                backgroundColor: AppColors.kBlueLight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.kBlue, size: 20),
                    SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Template Approval Process', style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.kBlue)),
                          SizedBox(height: AppSpacing.s4),
                          Text(
                            'New or edited templates must be submitted to Meta for approval. This typically takes 24-48 hours. Avoid editing approved templates without good reason — re-approval is required.',
                            style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kBlue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s24),
            ],
          );
        },
      ),
    );
  }
}
