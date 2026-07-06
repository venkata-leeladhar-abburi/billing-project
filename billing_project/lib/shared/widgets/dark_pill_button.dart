import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class DarkPillButton extends StatelessWidget {
  const DarkPillButton({
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final textColor = isSelected ? Colors.white : AppColors.kSecondary;

    return Material(
      color: isSelected ? AppColors.kDark : Colors.transparent,
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: textColor),
                SizedBox(width: AppSpacing.s6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTypography.kFontSans,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
