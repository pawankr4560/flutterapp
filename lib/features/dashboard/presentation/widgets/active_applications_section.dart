import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_theme.dart';
import 'package:finhub/features/loan/data/models/loan_application.dart';
import 'package:finhub/features/loan/presentation/widgets/loan_status_stepper.dart';

class ActiveApplicationsSection extends StatelessWidget {
  const ActiveApplicationsSection({
    super.key,
    required this.applications,
    required this.onViewAll,
    required this.onApplicationTap,
  });

  final List<LoanApplication> applications;
  final VoidCallback onViewAll;
  final void Function(String applicationId) onApplicationTap;

  @override
  Widget build(BuildContext context) {
    if (applications.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayed = applications.length > 2 ? applications.sublist(0, 2) : applications;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var application in displayed) ...[
          _ActiveApplicationTile(
            application: application,
            onTap: () => onApplicationTap(application.id),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (applications.length > 2)
          TextButton(
            onPressed: onViewAll,
            child: const Text('View all applications →'),
          ),
      ],
    );
  }
}

class _ActiveApplicationTile extends StatelessWidget {
  const _ActiveApplicationTile({
    required this.application,
    required this.onTap,
  });

  final LoanApplication application;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.assignment_outlined,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.type,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Application ID: ${application.id}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              LoanStatusStepper(currentStep: application.stepsCompleted - 1),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Amount ₹${application.amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


