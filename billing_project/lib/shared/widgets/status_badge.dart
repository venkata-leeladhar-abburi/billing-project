import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

enum StatusBadgeType { active, pending, approved, rejected, failed, suspended, info }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    required this.type,
    this.showDot = true,
    this.fontSize = 11,
    super.key,
  });

  final String label;
  final StatusBadgeType type;
  final bool showDot;
  final double fontSize;

  Color get _backgroundColor {
    switch (type) {
      case StatusBadgeType.active:
      case StatusBadgeType.approved:
        return AppColors.kGreenLight;
      case StatusBadgeType.pending:
        return const Color(0xFFFFFBEB);
      case StatusBadgeType.rejected:
        return const Color(0xFFF5F5F5);
      case StatusBadgeType.failed:
      case StatusBadgeType.suspended:
        return const Color(0xFFFEF2F2);
      case StatusBadgeType.info:
        return AppColors.kBlueLight;
    }
  }

  Color get _textColor {
    switch (type) {
      case StatusBadgeType.active:
      case StatusBadgeType.approved:
        return AppColors.kGreen;
      case StatusBadgeType.pending:
        return AppColors.kWarning;
      case StatusBadgeType.rejected:
        return AppColors.kMuted;
      case StatusBadgeType.failed:
      case StatusBadgeType.suspended:
        return AppColors.kError;
      case StatusBadgeType.info:
        return AppColors.kBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _textColor;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AppSpacing.rPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: AppSpacing.s6),
          ],
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
