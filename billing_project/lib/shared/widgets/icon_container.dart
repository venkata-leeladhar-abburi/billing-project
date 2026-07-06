import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  const IconContainer({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.size = 48,
    this.iconSize = 24,
    this.borderRadius = 12,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double size;
  final double iconSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}
