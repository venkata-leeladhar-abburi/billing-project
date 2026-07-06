import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

enum CreditType { bill, msg }

class CreditBadge extends StatelessWidget {
  const CreditBadge({
    required this.currentCredits,
    required this.maxCredits,
    required this.type,
    this.showLabel = true,
    this.fontSize = 16,
    super.key,
  });

  final int currentCredits;
  final int maxCredits;
  final CreditType type;
  final bool showLabel;
  final double fontSize;

  Color get statusColor {
    final pct = currentCredits / maxCredits;
    if (pct > 0.5) return AppColors.kGreen;
    if (pct > 0.2) return AppColors.kWarning;
    return AppColors.kError;
  }

  IconData get _icon {
    return type == CreditType.bill
        ? Icons.receipt_long_outlined
        : Icons.campaign_outlined;
  }

  String get _label {
    return type == CreditType.bill ? 'Bill Credits' : 'Msg Credits';
  }

  @override
  Widget build(BuildContext context) {
    final color = statusColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_icon, size: fontSize + 2, color: color),
        SizedBox(width: AppSpacing.s6),
        Text(
          '$currentCredits/$maxCredits',
          style: AppTypography.body.copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        if (showLabel) ...[
          SizedBox(width: AppSpacing.s4),
          Text(
            _label,
            style: AppTypography.caption.copyWith(color: AppColors.kMuted),
          ),
        ],
      ],
    );
  }
}
