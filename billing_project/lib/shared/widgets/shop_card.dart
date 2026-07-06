import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/shop_model.dart';
import 'app_card.dart';
import 'plan_badge.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({
    required this.shop,
    required this.onTap,
    this.showSalesperson = false,
    super.key,
  });

  final ShopModel shop;
  final VoidCallback onTap;
  final bool showSalesperson;

  String get _initials {
    final parts = shop.shopName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = showSalesperson
        ? (shop.salespersonName ?? '')
        : shop.ownerName;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.kOrangeLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _initials,
              style: AppTypography.body.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.kOrange,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.shopName,
                  style: AppTypography.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kDark,
                  ),
                ),
                SizedBox(height: AppSpacing.s4),
                Text(subtitle, style: AppTypography.caption.copyWith(fontSize: 12)),
                Text(
                  shop.businessType,
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PlanBadge(plan: shop.plan),
              SizedBox(height: AppSpacing.s4),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: shop.status.dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
