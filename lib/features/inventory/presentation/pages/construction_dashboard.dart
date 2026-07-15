part of 'inventory_directory_page.dart';

class _ConstructionDashboard extends StatelessWidget {
  const _ConstructionDashboard({
    required this.dashboard,
    required this.categories,
    required this.onBrowse,
    required this.onOrders,
    required this.onDelivery,
    required this.onCategoryTap,
  });

  final _ConstructionDashboardData dashboard;
  final List<_MaterialCategory> categories;
  final VoidCallback onBrowse;
  final VoidCallback onOrders;
  final VoidCallback onDelivery;
  final ValueChanged<String> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 560 ? 3 : 2;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.45,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ConstructionSummaryCard(
                  title: 'Total Products',
                  value: dashboard.totalProducts.toString(),
                  icon: Icons.inventory_2_rounded,
                ),
                ConstructionSummaryCard(
                  title: 'Active Orders',
                  value: dashboard.activeOrders.toString(),
                  icon: Icons.receipt_long_rounded,
                ),
                ConstructionSummaryCard(
                  title: 'Deliveries Today',
                  value: dashboard.deliveriesToday.toString(),
                  icon: Icons.local_shipping_rounded,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        const _SectionHeader(title: 'Quick Actions'),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 560 ? 3 : 2;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.72,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ConstructionQuickActionCard(
                  title: 'Browse Materials',
                  icon: Icons.warehouse_rounded,
                  onTap: onBrowse,
                ),
                ConstructionQuickActionCard(
                  title: 'My Orders',
                  icon: Icons.receipt_long_rounded,
                  onTap: onOrders,
                ),
                ConstructionQuickActionCard(
                  title: 'Track Delivery',
                  icon: Icons.local_shipping_rounded,
                  onTap: onDelivery,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        const _SectionHeader(title: 'Categories'),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 168,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final category = categories[index];
              return SizedBox(
                width: 210,
                child: _MaterialCategoryCard(
                  category: category,
                  onTap: () => onCategoryTap(category.name),
                ),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemCount: categories.length,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const _SectionHeader(title: 'Recent Activities'),
        const SizedBox(height: AppSpacing.sm),
        if (dashboard.recentActivities.isEmpty)
          _EmptyConstructionMessage(message: 'No recent activities yet')
        else
          for (final activity in dashboard.recentActivities) ...[
            _ActivityTile(
              icon: _activityIcon(activity.type),
              title: activity.title,
              subtitle: activity.subtitle,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
      ],
    );
  }
}

IconData _activityIcon(String type) {
  return switch (type.toUpperCase()) {
    'ORDER' => Icons.check_circle_rounded,
    'DELIVERY' => Icons.local_shipping_rounded,
    _ => Icons.info_rounded,
  };
}

