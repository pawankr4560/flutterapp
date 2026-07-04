import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_spacing.dart';

/// Reusable section header with optional subtitle and action.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final action = actionText == null
        ? null
        : TextButton(
            onPressed: onAction,
            child: Text(
              actionText!,
              style: AppTextStyles.labelLarge(context).copyWith(
                color: AppColors.primary,
              ),
            ),
          );

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < AppSpacing.xxl * 7;
        final titleContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.titleLarge(context)),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(subtitle!, style: AppTextStyles.bodyMedium(context)),
            ],
          ],
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleContent,
              if (action != null) ...[
                const SizedBox(height: AppSpacing.xs),
                action,
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: titleContent),
            if (action != null) ...[
              const SizedBox(width: AppSpacing.md),
              action,
            ],
          ],
        );
      },
    );
  }
}
