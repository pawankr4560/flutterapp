import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/dashboard/presentation/providers/activities_provider.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:finhub/features/dashboard/presentation/providers/modules_provider.dart';
import 'package:finhub/features/dashboard/presentation/providers/navigation_provider.dart';
import 'package:finhub/features/dashboard/presentation/widgets/bottom_nav_bar.dart';
import 'package:finhub/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:finhub/features/dashboard/presentation/widgets/overview_card.dart';
import 'package:finhub/features/dashboard/presentation/widgets/quick_action_grid.dart';
import 'package:finhub/features/dashboard/presentation/widgets/recent_activity_list.dart';
import 'package:finhub/features/profile/presentation/pages/profile_screen.dart';

/// Dashboard foundation page for FinHub business overview metrics.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);
    final modules = ref.watch(businessModulesProvider);
    final activities = ref.watch(recentActivitiesProvider);
    final selectedTab = ref.watch(dashboardTabProvider);

    return Scaffold(
      bottomNavigationBar: const DashboardBottomNavBar(),
      body: SafeArea(
        child: switch (selectedTab) {
          0 => ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                const DashboardHeader(),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  "Today's Overview",
                  style: AppTextStyles.titleLarge(context),
                ),
                const SizedBox(height: AppSpacing.md),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isTablet =
                        constraints.maxWidth >= AppSpacing.xxl * 12;
                    final columns = isTablet ? 4 : 2;
                    final spacing = AppSpacing.md;
                    final cardWidth =
                        (constraints.maxWidth - spacing * (columns - 1)) /
                            columns;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        OverviewCard(
                          width: cardWidth,
                          title: "Today's Income",
                          value: _formatCurrency(summary.totalIncome),
                          icon: Icons.payments_rounded,
                          color: AppColors.primary,
                        ),
                        OverviewCard(
                          width: cardWidth,
                          title: 'Pending EMI',
                          value: summary.pendingEmi.toString(),
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.warning,
                        ),
                        OverviewCard(
                          width: cardWidth,
                          title: 'Bookings',
                          value: summary.bookings.toString(),
                          icon: Icons.directions_car_rounded,
                          color: AppColors.success,
                        ),
                        OverviewCard(
                          width: cardWidth,
                          title: 'Inventory Alerts',
                          value: summary.inventoryAlerts.toString(),
                          icon: Icons.inventory_2_rounded,
                          color: AppColors.error,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                QuickActionGrid(modules: modules),
                const SizedBox(height: AppSpacing.xl),
                RecentActivityList(activities: activities),
              ],
            ),
          1 => const _DashboardPlaceholder(title: 'Reports Screen Coming Soon'),
          2 => const _DashboardPlaceholder(title: 'Alerts Screen Coming Soon'),
          _ => const ProfileScreen(),
        },
      ),
    );
  }

  String _formatCurrency(int value) {
    final text = value.toString();
    final buffer = StringBuffer();

    for (var index = 0; index < text.length; index++) {
      final remaining = text.length - index;
      buffer.write(text[index]);
      if (remaining > 1 && remaining % 2 == 0) {
        buffer.write(',');
      }
    }

    return '₹$buffer';
  }
}

/// Placeholder body for dashboard tabs that are not implemented yet.
class _DashboardPlaceholder extends StatelessWidget {
  const _DashboardPlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.titleLarge(context),
        ),
      ),
    );
  }
}
