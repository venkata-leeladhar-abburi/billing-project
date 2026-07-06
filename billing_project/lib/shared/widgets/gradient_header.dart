import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

enum GradientHeaderType { purple, orange, sky, navy }

class GradientHeader extends StatelessWidget {
  const GradientHeader({
    required this.type,
    this.title,
    this.subtitle,
    this.showBackButton = false,
    this.onBack,
    this.leadingWidget,
    this.trailingWidget,
    this.height = 180.0,
    this.bottomOverlap,
    this.overlapAmount = 20.0,
    super.key,
  });

  final GradientHeaderType type;
  final String? title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final double height;
  final Widget? bottomOverlap;
  final double overlapAmount;

  LinearGradient get _gradient {
    switch (type) {
      case GradientHeaderType.purple:
        return AppColors.kGradientPurple;
      case GradientHeaderType.orange:
        return AppColors.kGradientOrange;
      case GradientHeaderType.sky:
        return AppColors.kGradientSky;
      case GradientHeaderType.navy:
        return AppColors.kGradientNavy;
    }
  }

  Color get _titleColor {
    switch (type) {
      case GradientHeaderType.sky:
        return AppColors.kNavy;
      case GradientHeaderType.purple:
      case GradientHeaderType.orange:
      case GradientHeaderType.navy:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomOverlap != null ? overlapAmount : 0,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            constraints: BoxConstraints(minHeight: height),
            width: double.infinity,
            decoration: BoxDecoration(gradient: _gradient),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.s16,
              MediaQuery.of(context).padding.top + AppSpacing.s8,
              AppSpacing.s16,
              AppSpacing.s12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (showBackButton)
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: _titleColor),
                        onPressed: onBack ?? () => context.pop(),
                      )
                    else
                      ?leadingWidget,
                    const Spacer(),
                    ?trailingWidget,
                  ],
                ),
                if (title != null) ...[
                  SizedBox(height: AppSpacing.s12),
                  Text(
                    title!,
                    style: AppTypography.h2.copyWith(color: _titleColor),
                  ),
                ],
                if (subtitle != null) ...[
                  SizedBox(height: AppSpacing.s4),
                  Text(
                    subtitle!,
                    style: AppTypography.body.copyWith(
                      color: _titleColor.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (bottomOverlap != null)
            Positioned(
              left: AppSpacing.s16,
              right: AppSpacing.s16,
              bottom: -overlapAmount,
              child: bottomOverlap!,
            ),
        ],
      ),
    );
  }
}
