import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isFullWidth = true,
    this.borderColor,
    this.textColor,
    this.leadingIcon,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isFullWidth;
  final Color? borderColor;
  final Color? textColor;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    final resolvedBorderColor = isDisabled
        ? const Color(0xFFEEEEEE)
        : (borderColor ?? AppColors.kBorderGray);
    final resolvedTextColor = isDisabled
        ? const Color(0xFFCCCCCC)
        : (textColor ?? AppColors.kDark);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 48,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.kBgCard,
          side: BorderSide(color: resolvedBorderColor, width: 1.5),
          shape: const StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: resolvedTextColor,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: 18, color: resolvedTextColor),
                    SizedBox(width: AppSpacing.s8),
                  ],
                  Text(
                    label,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: resolvedTextColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
