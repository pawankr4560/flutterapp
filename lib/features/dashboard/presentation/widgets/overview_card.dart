import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';

/// Metric card used in the dashboard business overview section.
class OverviewCard extends StatelessWidget {
  const OverviewCard({
    super.key,
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final double width;
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSpacing.xxl,
              height: AppSpacing.xxl,
              decoration: BoxDecoration(
                color: color.withValues(alpha: AppSpacing.xxs / AppSpacing.xl),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: AppTextStyles.bodyMedium(context)),
            const SizedBox(height: AppSpacing.xs),
            Text(value, style: AppTextStyles.headlineMedium(context)),
          ],
        ),
      ),
    );
  }
}
