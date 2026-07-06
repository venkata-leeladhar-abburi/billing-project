import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import 'primary_button.dart';

enum EmptyStateType { bills, customers, campaigns, notifications, shops, generic }

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.type,
    this.subtitle,
    this.ctaLabel,
    this.onCtaTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? ctaLabel;
  final VoidCallback? onCtaTap;
  final EmptyStateType type;

  IconData get _icon {
    switch (type) {
      case EmptyStateType.bills:
        return Icons.receipt_long_outlined;
      case EmptyStateType.customers:
        return Icons.people_outline;
      case EmptyStateType.campaigns:
        return Icons.campaign_outlined;
      case EmptyStateType.notifications:
        return Icons.notifications_none;
      case EmptyStateType.shops:
        return Icons.storefront_outlined;
      case EmptyStateType.generic:
        return Icons.inbox_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0E0E0),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Icon(_icon, size: 56, color: const Color(0xFFE0E0E0)),
                  Positioned(
                    right: 28,
                    bottom: 28,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.kOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.s16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.kSecondary,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: AppSpacing.s8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  color: const Color(0xFFCCCCCC),
                ),
              ),
            ],
            if (ctaLabel != null) ...[
              SizedBox(height: AppSpacing.s24),
              PrimaryButton(
                label: ctaLabel!,
                isFullWidth: false,
                width: 220,
                onTap: onCtaTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
