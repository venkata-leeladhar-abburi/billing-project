import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.serifWord,
    this.actionLabel,
    this.onAction,
    this.showArrow = true,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? serifWord;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showArrow;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: AppTypography.h2,
                  children: [
                    TextSpan(text: title),
                    if (serifWord != null)
                      TextSpan(
                        text: serifWord,
                        style: AppTypography.h1Serif.copyWith(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: AppColors.kOrange,
                        ),
                      ),
                  ],
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: AppSpacing.s4),
                Text(
                  subtitle!,
                  style: AppTypography.caption.copyWith(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionLabel!,
                  style: AppTypography.body.copyWith(
                    fontSize: 13,
                    color: AppColors.kOrange,
                  ),
                ),
                if (showArrow) ...[
                  SizedBox(width: AppSpacing.s4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: AppColors.kOrange,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
