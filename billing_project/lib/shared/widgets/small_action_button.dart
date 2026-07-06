import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class SmallActionButton extends StatelessWidget {
  const SmallActionButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.backgroundColor,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.kOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.rSm),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontFamily: AppTypography.kFontSans,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
