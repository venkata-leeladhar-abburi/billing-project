import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = AppColors.kBgCard,
    this.borderRadius = 12.0,
    this.borderColor = AppColors.kBorderGray,
    this.borderWidth = 1.0,
    this.onTap,
    this.shadow = AppColors.kShadowCard,
    this.leftBorderColor,
    this.leftBorderWidth = 4.0,
    this.margin,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final BoxShadow shadow;
  final Color? leftBorderColor;
  final double leftBorderWidth;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [shadow],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              decoration: leftBorderColor == null
                  ? null
                  : BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: leftBorderColor!,
                          width: leftBorderWidth,
                        ),
                      ),
                    ),
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
