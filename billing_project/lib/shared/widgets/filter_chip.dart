import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count,
    this.selectedColor,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected
        ? (selectedColor ?? AppColors.kDark)
        : AppColors.kBgCard;
    final textColor = isSelected ? Colors.white : AppColors.kSecondary;

    return Material(
      color: bgColor,
      shape: StadiumBorder(
        side: isSelected
            ? BorderSide.none
            : const BorderSide(color: AppColors.kBorderGray),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.body.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              if (count != null) ...[
                SizedBox(width: AppSpacing.s6),
                Text(
                  '($count)',
                  style: AppTypography.caption.copyWith(
                    color: isSelected ? Colors.white70 : AppColors.kMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
