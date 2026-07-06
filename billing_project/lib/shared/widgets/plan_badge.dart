import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/models/plan_type.dart';

export '../../core/models/plan_type.dart';

class PlanBadge extends StatelessWidget {
  const PlanBadge({required this.plan, this.isLarge = false, super.key});

  final SubscriptionPlan plan;
  final bool isLarge;

  Color get _backgroundColor {
    switch (plan) {
      case SubscriptionPlan.basic:
        return const Color(0xFFF5F5F5);
      case SubscriptionPlan.pro:
        return const Color(0xFFF5F3FF);
      case SubscriptionPlan.business:
        return AppColors.kOrangeLight;
    }
  }

  Color get _textColor {
    switch (plan) {
      case SubscriptionPlan.basic:
        return AppColors.kSecondary;
      case SubscriptionPlan.pro:
        return const Color(0xFF7C3AED);
      case SubscriptionPlan.business:
        return AppColors.kOrange;
    }
  }

  String get _label {
    switch (plan) {
      case SubscriptionPlan.basic:
        return 'BASIC';
      case SubscriptionPlan.pro:
        return 'PRO';
      case SubscriptionPlan.business:
        return 'BUSINESS';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? AppSpacing.s12 : AppSpacing.s8,
        vertical: isLarge ? AppSpacing.s6 : AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AppSpacing.rPill,
      ),
      child: Text(
        _label,
        style: AppTypography.caption.copyWith(
          fontSize: isLarge ? 13 : 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: _textColor,
        ),
      ),
    );
  }
}
