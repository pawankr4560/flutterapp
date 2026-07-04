import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/dashboard/presentation/providers/activities_provider.dart';
import 'package:finhub/features/dashboard/presentation/providers/modules_provider.dart';
import 'package:finhub/features/dashboard/presentation/providers/navigation_provider.dart';
import 'package:finhub/features/dashboard/presentation/widgets/bottom_nav_bar.dart';
import 'package:finhub/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:finhub/features/dashboard/presentation/widgets/notifications_tab.dart';
import 'package:finhub/features/dashboard/presentation/widgets/quick_action_grid.dart';
import 'package:finhub/features/dashboard/presentation/widgets/recent_activity_list.dart';
import 'package:finhub/features/dashboard/presentation/widgets/reports_tab.dart';
import 'package:finhub/features/profile/presentation/pages/profile_screen.dart';

/// Dashboard foundation page for FinHub business overview metrics.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                QuickActionGrid(modules: modules),
                const SizedBox(height: AppSpacing.xl),
                RecentActivityList(activities: activities),
              ],
            ),
          1 => const ReportsTab(),
          2 => const NotificationsTab(),
          _ => const ProfileScreen(),
        },
      ),
    );
  }
}
