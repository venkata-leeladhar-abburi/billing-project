import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    this.isFullScreen = true,
    this.message,
    this.color,
    super.key,
  });

  final bool isFullScreen;
  final String? message;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          color: color ?? AppColors.kOrange,
          strokeWidth: 3,
        ),
        if (message != null) ...[
          SizedBox(height: AppSpacing.s16),
          Text(
            message!,
            style: AppTypography.body.copyWith(
              fontSize: 14,
              color: AppColors.kMuted,
            ),
          ),
        ],
      ],
    );

    if (!isFullScreen) {
      return Center(child: content);
    }

    return Container(
      color: AppColors.kBgCard,
      alignment: Alignment.center,
      child: content,
    );
  }
}
