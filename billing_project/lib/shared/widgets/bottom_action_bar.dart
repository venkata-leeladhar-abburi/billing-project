import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    required this.ctaLabel,
    required this.onCtaTap,
    this.primaryLabel,
    this.secondaryLabel,
    this.isCtaLoading = false,
    this.ctaLeadingIcon,
    this.creditInfo,
    this.creditInfoColor,
    this.showTopBorder = true,
    super.key,
  });

  final String? primaryLabel;
  final String? secondaryLabel;
  final String ctaLabel;
  final VoidCallback? onCtaTap;
  final bool isCtaLoading;
  final Widget? ctaLeadingIcon;
  final String? creditInfo;
  final Color? creditInfoColor;
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      decoration: BoxDecoration(
        color: AppColors.kBgCard,
        border: showTopBorder
            ? const Border(top: BorderSide(color: AppColors.kDivider))
            : null,
      ),
      child: Row(
        children: [
          if (primaryLabel != null || secondaryLabel != null || creditInfo != null)
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (primaryLabel != null)
                      Text(
                        primaryLabel!,
                        style: AppTypography.h3.copyWith(
                          fontSize: 18,
                          height: 1.1,
                        ),
                      ),
                    if (secondaryLabel != null)
                      Text(
                        secondaryLabel!,
                        style: AppTypography.caption.copyWith(height: 1.1),
                      ),
                    if (creditInfo != null)
                      Text(
                        creditInfo!,
                        style: AppTypography.caption.copyWith(
                          fontSize: 11,
                          height: 1.1,
                          color: creditInfoColor ?? AppColors.kMuted,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          SizedBox(width: AppSpacing.s12),
          ElevatedButton(
            onPressed: isCtaLoading ? null : onCtaTap,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(140, 48),
              backgroundColor: onCtaTap == null
                  ? const Color(0xFFCCCCCC)
                  : AppColors.kOrange,
              disabledBackgroundColor: const Color(0xFFCCCCCC),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              elevation: 0,
            ),
            child: isCtaLoading
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
                      if (ctaLeadingIcon != null)
                        Padding(
                          padding: EdgeInsets.only(right: AppSpacing.s8),
                          child: ctaLeadingIcon,
                        ),
                      Text(ctaLabel, style: AppTypography.buttonLabel),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
