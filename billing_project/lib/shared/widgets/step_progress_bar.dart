import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

enum _StepState { completed, active, upcoming }

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    required this.stepLabels,
    required this.currentStep,
    required this.completedSteps,
    super.key,
  });

  final List<String> stepLabels;
  final int currentStep;
  final int completedSteps;

  _StepState _stateFor(int index) {
    if (index < completedSteps) return _StepState.completed;
    if (index == currentStep) return _StepState.active;
    return _StepState.upcoming;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < stepLabels.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                _buildCircle(i),
                SizedBox(height: AppSpacing.s4),
                Text(
                  stepLabels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTypography.kFontSans,
                    fontSize: 10,
                    fontWeight: _stateFor(i) == _StepState.active
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: switch (_stateFor(i)) {
                      _StepState.completed => AppColors.kMuted,
                      _StepState.active => AppColors.kOrange,
                      _StepState.upcoming => const Color(0xFFCCCCCC),
                    },
                  ),
                ),
              ],
            ),
          ),
          if (i != stepLabels.length - 1)
            Expanded(
              child: Container(
                height: 2,
                margin: EdgeInsets.only(bottom: 18),
                color: i < completedSteps
                    ? AppColors.kOrange
                    : const Color(0xFFE5E5E5),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildCircle(int index) {
    final state = _stateFor(index);

    final Color bgColor = switch (state) {
      _StepState.completed => AppColors.kGreen,
      _StepState.active => AppColors.kOrange,
      _StepState.upcoming => const Color(0xFFE5E5E5),
    };

    final Widget child = switch (state) {
      _StepState.completed => const Icon(Icons.check, size: 14, color: Colors.white),
      _StepState.active => Text(
          '${index + 1}',
          style: const TextStyle(
            fontFamily: AppTypography.kFontSans,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      _StepState.upcoming => Text(
          '${index + 1}',
          style: const TextStyle(
            fontFamily: AppTypography.kFontSans,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.kMuted,
          ),
        ),
    };

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: child,
    );
  }
}
