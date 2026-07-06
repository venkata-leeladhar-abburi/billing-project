import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/mock/mock_fixtures.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../domain/bulk_message_notifier.dart';

class TemplateSelectScreen extends ConsumerWidget {
  const TemplateSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(bulkMessageProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        leading: TextButton(
          onPressed: () => context.pop(),
          child: Text('Cancel', style: AppTypography.body.copyWith(color: AppColors.kSecondary)),
        ),
        leadingWidth: 80,
        title: Text('Choose Template', style: AppTypography.h3.copyWith(fontSize: 17)),
      ),
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _buildBody(context, ref, data),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, BulkMessageState data) {
    final notifier = ref.read(bulkMessageProvider.notifier);

    return ListView(
      padding: EdgeInsets.all(AppSpacing.s16),
      children: [
        Text(
          'Templates for: Clothing',
          style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kSecondary),
        ),
        SizedBox(height: AppSpacing.s16),
        for (final template in data.templates) ...[
          _TemplateCard(
            template: template,
            isSelected: data.selectedTemplate?.id == template.id,
            onTap: () {
              notifier.selectTemplate(template);
              context.pop();
            },
          ),
          SizedBox(height: AppSpacing.s8),
        ],
        AppCard(
          onTap: () {
            // TODO: custom message compose flow — still needs an AiSensy-approved
            // template under the hood per AiSensy policy restrictions
          },
          child: Row(
            children: [
              const Icon(Icons.edit_outlined, color: AppColors.kOrange, size: 20),
              SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Write Custom Message', style: AppTypography.h3.copyWith(fontSize: 14)),
                    SizedBox(height: AppSpacing.s4),
                    Text(
                      'Type your own WhatsApp message',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.isSelected,
    required this.onTap,
  });

  final MockTemplate template;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      borderColor: isSelected ? AppColors.kOrange : AppColors.kBorderGray,
      borderWidth: isSelected ? 1.5 : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.s8,
                    vertical: AppSpacing.s4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kOrangeLight,
                    borderRadius: AppSpacing.rXs,
                  ),
                  child: Text(
                    template.metaStatus.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.kOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.kOrange, size: 20),
            ],
          ),
          SizedBox(height: AppSpacing.s8),
          Text(
            template.displayName,
            style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: AppSpacing.s4),
          Text(
            template.body,
            maxLines: 3,
            style: AppTypography.body.copyWith(fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}
