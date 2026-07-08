part of 'milk_directory_page.dart';

class _DairyHomeView extends StatelessWidget {
  const _DairyHomeView({
    required this.dashboard,
    required this.products,
    required this.onOpenCollection,
    required this.onOpenSales,
    required this.onOpenCustomers,
    required this.onOpenProducts,
  });

  final _DairyDashboardData dashboard;
  final List<_ProductEntry> products;
  final VoidCallback onOpenCollection;
  final VoidCallback onOpenSales;
  final VoidCallback onOpenCustomers;
  final VoidCallback onOpenProducts;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 520 ? 4 : 2;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.42,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _DairySummaryCard(
                  title: 'Today Collection',
                  value: dashboard.todayCollection,
                  icon: Icons.water_drop_rounded,
                ),
                _DairySummaryCard(
                  title: 'Today Sales',
                  value: dashboard.todaySales,
                  icon: Icons.payments_rounded,
                ),
                _DairySummaryCard(
                  title: 'Pending Payment',
                  value: dashboard.pendingPayment,
                  icon: Icons.pending_actions_rounded,
                ),
                _DairySummaryCard(
                  title: 'Products',
                  value: dashboard.productsCount.toString(),
                  icon: Icons.inventory_2_rounded,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        const _DairySectionHeader(title: 'Quick Actions'),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 520 ? 4 : 2;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _DairyQuickActionCard(
                  title: 'Add Collection',
                  icon: Icons.add_rounded,
                  onTap: onOpenCollection,
                ),
                _DairyQuickActionCard(
                  title: 'New Sale',
                  icon: Icons.receipt_long_rounded,
                  onTap: onOpenSales,
                ),
                _DairyQuickActionCard(
                  title: 'Add Customer',
                  icon: Icons.person_add_alt_1_rounded,
                  onTap: onOpenCustomers,
                ),
                _DairyQuickActionCard(
                  title: 'Add Product',
                  icon: Icons.add_business_rounded,
                  onTap: onOpenProducts,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        const _DairySectionHeader(title: 'Products'),
        const SizedBox(height: AppSpacing.sm),
        if (products.isEmpty)
          const _DairyEmptyMessage(message: 'No products added yet')
        else
          SizedBox(
            height: 126,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>
                  _DairyProductMiniCard(product: products[index]),
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemCount: products.length,
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        const _DairySectionHeader(title: 'Recent Activities'),
        const SizedBox(height: AppSpacing.sm),
        if (dashboard.recentActivities.isEmpty)
          const _DairyEmptyMessage(message: 'No recent activities yet')
        else
          for (final activity in dashboard.recentActivities) ...[
            _DairyActivityTile(
              icon: _activityIcon(activity.type),
              title: activity.title,
              subtitle: activity.subtitle,
              time: activity.time,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
      ],
    );
  }
}

IconData _activityIcon(String type) {
  return switch (type.toUpperCase()) {
    'COLLECTION' => Icons.water_drop_rounded,
    'SALE' => Icons.point_of_sale_rounded,
    'PAYMENT' => Icons.account_balance_wallet_rounded,
    _ => Icons.info_rounded,
  };
}

