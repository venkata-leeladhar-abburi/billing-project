import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/customer_model.dart';
import 'app_card.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({required this.customer, required this.onTap, super.key});

  final CustomerModel customer;
  final VoidCallback onTap;

  String get _initials {
    final parts = customer.name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
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
                  customer.name,
                  style: AppTypography.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kDark,
                  ),
                ),
                SizedBox(height: AppSpacing.s4),
                Text(
                  customer.phone,
                  style: AppTypography.caption.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${customer.totalBilled.toStringAsFixed(2)}',
                style: AppTypography.body.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kDark,
                ),
              ),
              SizedBox(height: AppSpacing.s4),
              Text(
                '${customer.billCount} bills',
                style: AppTypography.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
