part of 'inventory_directory_page.dart';

class _ConstructionDashboard extends StatelessWidget {
  const _ConstructionDashboard({
    required this.categories,
    required this.onBrowse,
    required this.onQuote,
    required this.onOrders,
    required this.onDelivery,
    required this.onCategoryTap,
  });

  final List<_MaterialCategory> categories;
  final VoidCallback onBrowse;
  final VoidCallback onQuote;
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
            final columns = constraints.maxWidth > 560 ? 4 : 2;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.45,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ConstructionSummaryCard(
                  title: 'Total Products',
                  value: '48',
                  icon: Icons.inventory_2_rounded,
                ),
                ConstructionSummaryCard(
                  title: 'Pending Quotes',
                  value: '6',
                  icon: Icons.request_quote_rounded,
                ),
                ConstructionSummaryCard(
                  title: 'Active Orders',
                  value: '3',
                  icon: Icons.receipt_long_rounded,
                ),
                ConstructionSummaryCard(
                  title: 'Deliveries Today',
                  value: '2',
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
            final columns = constraints.maxWidth > 560 ? 4 : 2;
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
                  title: 'Request Quote',
                  icon: Icons.request_quote_rounded,
                  onTap: onQuote,
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
        const _ActivityTile(
          icon: Icons.request_quote_rounded,
          title: 'Quote requested for TMT Steel',
          subtitle: 'Supplier confirmation pending',
        ),
        const SizedBox(height: AppSpacing.sm),
        const _ActivityTile(
          icon: Icons.check_circle_rounded,
          title: 'Cement order confirmed',
          subtitle: '100 bags scheduled for dispatch',
        ),
        const SizedBox(height: AppSpacing.sm),
        const _ActivityTile(
          icon: Icons.local_shipping_rounded,
          title: 'Sand delivery scheduled',
          subtitle: 'Expected today evening',
        ),
      ],
    );
  }
}

