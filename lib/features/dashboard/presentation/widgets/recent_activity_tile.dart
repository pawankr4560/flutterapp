import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_card.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/dashboard/domain/entities/recent_activity.dart';

/// Dashboard tile that displays one recent cross-business activity.
class RecentActivityTile extends StatelessWidget {
  const RecentActivityTile({super.key, required this.activity});

  final RecentActivity activity;

  @override
  Widget build(BuildContext context) {
    final accentColor = _colorFromHex(activity.hexColor);
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.xxl,
            height: AppSpacing.xxl,
            decoration: BoxDecoration(
              color: accentColor.withValues(
                alpha: AppSpacing.xxs / AppSpacing.xl,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(_iconFromName(activity.iconName), color: accentColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium(context).copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  activity.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            activity.timeAgo,
            style: AppTextStyles.bodySmall(context).copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFromHex(String value) {
    final normalized = value.replaceFirst('#', '');
    final colorValue = int.tryParse('FF$normalized', radix: 16);
    return colorValue == null ? AppColors.primary : Color(colorValue);
  }

  IconData _iconFromName(String value) {
    return switch (value) {
      'check_circle' => Icons.check_circle_rounded,
      'warning' => Icons.warning_rounded,
      'water_drop' => Icons.water_drop_rounded,
      'directions_car' => Icons.directions_car_rounded,
      _ => Icons.notifications_rounded,
    };
  }
}
