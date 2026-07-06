import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import 'filter_chip.dart';

class FilterChipData {
  const FilterChipData({required this.value, required this.label, this.count});

  final String value;
  final String label;
  final int? count;
}

class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    required this.chips,
    required this.selectedValue,
    required this.onSelect,
    this.padding,
    this.allowMultiSelect = false,
    super.key,
  });

  final List<FilterChipData> chips;
  final String selectedValue;
  final ValueChanged<String> onSelect;
  final EdgeInsets? padding;
  final bool allowMultiSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding ?? EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Row(
        children: [
          for (var i = 0; i < chips.length; i++) ...[
            AppFilterChip(
              label: chips[i].label,
              count: chips[i].count,
              isSelected: chips[i].value == selectedValue,
              onTap: () => onSelect(chips[i].value),
            ),
            if (i != chips.length - 1) SizedBox(width: AppSpacing.s8),
          ],
        ],
      ),
    );
  }
}
