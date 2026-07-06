import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/bill_model.dart';
import '../../core/utils/formatters.dart';
import 'app_card.dart';
import 'status_badge.dart';

class BillCard extends StatelessWidget {
  const BillCard({
    required this.bill,
    required this.onTap,
    this.showCustomerName = true,
    super.key,
  });

  final BillModel bill;
  final VoidCallback onTap;
  final bool showCustomerName;

  StatusBadgeType get _badgeType {
    switch (bill.status) {
      case BillStatus.sent:
        return StatusBadgeType.active;
      case BillStatus.failed:
        return StatusBadgeType.failed;
      case BillStatus.pending:
        return StatusBadgeType.pending;
    }
  }

  String get _badgeLabel {
    switch (bill.status) {
      case BillStatus.sent:
        return 'Sent';
      case BillStatus.failed:
        return 'Failed';
      case BillStatus.pending:
        return 'Pending';
    }
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showCustomerName)
                  Text(
                    bill.customerName,
                    style: AppTypography.body.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kDark,
                    ),
                  ),
                SizedBox(height: AppSpacing.s4),
                Text(
                  bill.billNumber,
                  style: AppTypography.caption,
                ),
                Text(
                  bill.sentAgo,
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.formatINR(bill.total),
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kDark,
                ),
              ),
              SizedBox(height: AppSpacing.s4),
              StatusBadge(label: _badgeLabel, type: _badgeType),
            ],
          ),
        ],
      ),
    );
  }
}
