import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/dashboard/presentation/providers/navigation_provider.dart';

/// Premium persistent bottom navigation bar for dashboard tabs.
class DashboardBottomNavBar extends ConsumerWidget {
  const DashboardBottomNavBar({super.key});

  static const List<_DashboardTab> _tabs = [
    _DashboardTab(icon: Icons.home_rounded, label: 'Home'),
    _DashboardTab(icon: Icons.bar_chart_rounded, label: 'Reports'),
    _DashboardTab(icon: Icons.notifications_rounded, label: 'Alerts'),
    _DashboardTab(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(dashboardTabProvider);

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.overlay,
              blurRadius: AppSpacing.lg,
              offset: Offset(AppSpacing.xxs, AppSpacing.sm),
            ),
          ],
        ),
        child: Row(
          children: [
            for (var index = 0; index < _tabs.length; index++)
              Expanded(
                child: _BottomNavItem(
                  tab: _tabs[index],
                  isActive: selectedIndex == index,
                  onTap: () {
                    ref.read(dashboardTabProvider.notifier).selectTab(index);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Single dashboard tab item.
class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final _DashboardTab tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foregroundColor =
        isActive ? AppColors.primary : AppColors.textSecondary;
    final backgroundColor =
        isActive ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tab.icon, color: foregroundColor),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                tab.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall(context).copyWith(
                  color: foregroundColor,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Static tab metadata for the dashboard bottom bar.
class _DashboardTab {
  const _DashboardTab({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
