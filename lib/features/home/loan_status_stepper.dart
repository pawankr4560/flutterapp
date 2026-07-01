import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

class LoanStatusStepper extends StatelessWidget {
  const LoanStatusStepper({
    super.key,
    required this.currentStep,
  });

  final int currentStep;

  static const List<String> _steps = [
    'Submitted',
    'Under review',
    'Approved',
    'Disbursed',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_steps.length * 2 - 1, (index) {
        if (index.isEven) {
          final stepIndex = index ~/ 2;
          final isActive = stepIndex <= currentStep;

          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.accent : AppColors.surfaceMuted,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? AppColors.accent : AppColors.border,
                      width: 1.4,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${stepIndex + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _steps[stepIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            height: 2,
            color: index ~/ 2 < currentStep ? AppColors.accent : AppColors.border,
          ),
        );
      }),
    );
  }
}
