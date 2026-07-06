import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.leadingIcon,
    this.trailingIcon,
    this.subLabel,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final String? subLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: onTap == null
              ? const Color(0xFFCCCCCC)
              : AppColors.kOrange,
          disabledBackgroundColor: const Color(0xFFCCCCCC),
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(label, style: AppTypography.buttonLabel),
                      if (subLabel != null)
                        Text(subLabel!, style: AppTypography.buttonSubLabel),
                    ],
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(trailingIcon, size: 18, color: Colors.white),
                  ],
                ],
              ),
      ),
    );
  }
}
