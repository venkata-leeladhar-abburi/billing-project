import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class TabBarItem {
  const TabBarItem({required this.icon, required this.label, this.badgeCount});

  final IconData icon;
  final String label;
  final int? badgeCount;
}

class AppBottomTabBar extends StatelessWidget {
  const AppBottomTabBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<TabBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.kBgCard,
        border: Border(top: BorderSide(color: AppColors.kDivider)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(child: _buildTab(context, items[i], i)),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, TabBarItem item, int index) {
    final isActive = index == currentIndex;
    final color = isActive ? AppColors.kOrange : AppColors.kMuted;

    return InkWell(
      onTap: () => onTap(index),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s4,
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.kOrangeLight : Colors.transparent,
            borderRadius: AppSpacing.rPill,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.icon, size: 22, color: color),
                  SizedBox(height: AppSpacing.s2),
                  Text(
                    item.label,
                    style: AppTypography.navLabel.copyWith(color: color),
                  ),
                ],
              ),
              if (item.badgeCount != null && item.badgeCount! > 0)
                Positioned(
                  right: -4,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    decoration: const BoxDecoration(
                      color: AppColors.kError,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${item.badgeCount}',
                      style: const TextStyle(
                        fontFamily: AppTypography.kFontSans,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
