import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';

/// Modern fintech dashboard header for the FinHub overview page.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good Morning 👋', style: AppTextStyles.bodyMedium(context)),
              const SizedBox(height: AppSpacing.xs),
              Text('FinHub', style: AppTextStyles.headlineLarge(context)),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'One App. Multiple Businesses.',
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const _HeaderIconButton(icon: Icons.notifications_none_rounded),
        const SizedBox(width: AppSpacing.sm),
        const CircleAvatar(
          radius: AppRadius.large,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          child: Icon(Icons.person_rounded),
        ),
      ],
    );
  }
}

/// Compact icon action used in the dashboard header.
class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.large),
      surfaceTintColor: AppColors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: Container(
          width: AppSpacing.xxl,
          height: AppSpacing.xxl,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
