import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import 'app_card.dart';

enum InfoBannerType { info, warning, error, success }

class InfoBanner extends StatefulWidget {
  const InfoBanner({
    required this.message,
    required this.type,
    this.actionLabel,
    this.onAction,
    this.isDismissible = false,
    this.customIcon,
    super.key,
  });

  final String message;
  final InfoBannerType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isDismissible;
  final IconData? customIcon;

  @override
  State<InfoBanner> createState() => _InfoBannerState();
}

class _InfoBannerState extends State<InfoBanner> {
  bool _dismissed = false;

  Color get _borderColor {
    switch (widget.type) {
      case InfoBannerType.info:
        return AppColors.kBlue;
      case InfoBannerType.warning:
        return AppColors.kWarning;
      case InfoBannerType.error:
        return AppColors.kError;
      case InfoBannerType.success:
        return AppColors.kGreen;
    }
  }

  Color get _backgroundColor {
    switch (widget.type) {
      case InfoBannerType.info:
        return AppColors.kBlueLight;
      case InfoBannerType.warning:
        return const Color(0xFFFFFBEB);
      case InfoBannerType.error:
        return const Color(0xFFFEF2F2);
      case InfoBannerType.success:
        return AppColors.kGreenLight;
    }
  }

  Color get _textColor {
    switch (widget.type) {
      case InfoBannerType.info:
        return const Color(0xFF1E40AF);
      case InfoBannerType.warning:
        return const Color(0xFF92400E);
      case InfoBannerType.error:
        return const Color(0xFF991B1B);
      case InfoBannerType.success:
        return const Color(0xFF14532D);
    }
  }

  IconData get _icon {
    if (widget.customIcon != null) return widget.customIcon!;
    switch (widget.type) {
      case InfoBannerType.info:
        return Icons.info_outline;
      case InfoBannerType.warning:
        return Icons.warning_amber_outlined;
      case InfoBannerType.error:
        return Icons.error_outline;
      case InfoBannerType.success:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    final color = _borderColor;

    return AppCard(
      backgroundColor: _backgroundColor,
      borderColor: _backgroundColor,
      leftBorderColor: color,
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: AppSpacing.s12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon, size: 20, color: color),
          SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message,
                  style: AppTypography.body.copyWith(
                    fontSize: 13,
                    height: 1.5,
                    color: _textColor,
                  ),
                ),
                if (widget.actionLabel != null)
                  Padding(
                    padding: EdgeInsets.only(top: AppSpacing.s4),
                    child: GestureDetector(
                      onTap: widget.onAction,
                      child: Text(
                        widget.actionLabel!,
                        style: AppTypography.body.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kOrange,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (widget.isDismissible)
            GestureDetector(
              onTap: () => setState(() => _dismissed = true),
              child: Icon(Icons.close, size: 18, color: _textColor),
            ),
        ],
      ),
    );
  }
}
