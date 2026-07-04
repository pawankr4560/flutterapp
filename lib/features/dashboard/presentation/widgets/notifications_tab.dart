import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';

/// Notifications tab for business alerts and reminders.
class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  static const List<_NotificationItem> _items = [
    _NotificationItem(
      title: 'EMI due today',
      message: 'Rahul Sharma has an EMI payment due today.',
      time: '10 mins ago',
      icon: Icons.account_balance_wallet_rounded,
      color: AppColors.primary,
      status: 'Action',
    ),
    _NotificationItem(
      title: 'Low stock alert',
      message: 'Steel rods 12mm is below reorder threshold.',
      time: '24 mins ago',
      icon: Icons.inventory_2_rounded,
      color: AppColors.warning,
      status: 'Warning',
    ),
    _NotificationItem(
      title: 'Booking confirmed',
      message: 'Swift Dzire booking for Neha Gupta is confirmed.',
      time: '1 hr ago',
      icon: Icons.directions_car_rounded,
      color: AppColors.success,
      status: 'Success',
    ),
    _NotificationItem(
      title: 'Site visit pending',
      message: 'Green Valley Plot 14 visit request needs confirmation.',
      time: '2 hrs ago',
      icon: Icons.real_estate_agent_rounded,
      color: AppColors.error,
      status: 'Pending',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('Notifications', style: AppTextStyles.headlineLarge(context)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Important alerts from all your businesses.',
          style: AppTextStyles.bodyLarge(context).copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        for (final item in _items) ...[
          _NotificationTile(item: item),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final _NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.xxl,
            height: AppSpacing.xxl,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
            child: Icon(item.icon, color: item.color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: AppTextStyles.titleMedium(context),
                      ),
                    ),
                    _StatusBadge(label: item.status, color: item.color),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  item.message,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(item.time, style: AppTextStyles.bodySmall(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall(context).copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    required this.status,
  });

  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;
  final String status;
}
