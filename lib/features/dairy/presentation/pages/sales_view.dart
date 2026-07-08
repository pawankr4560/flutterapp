part of 'milk_directory_page.dart';

class _SalesView extends StatelessWidget {
  const _SalesView({
    required this.sales,
    required this.summary,
    required this.onSearch,
    required this.onAdd,
  });

  final List<_SaleEntry> sales;
  final _SalesSummary summary;
  final ValueChanged<String> onSearch;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Sale'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          96,
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: _DairySummaryCard(
                  title: 'Today Sales',
                  value: summary.todaySales,
                  icon: Icons.payments_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DairySummaryCard(
                  title: 'Orders',
                  value: summary.orders.toString(),
                  icon: Icons.shopping_bag_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppSearchAndFilter(
            hint: 'Search customer or product',
            onChanged: onSearch,
          ),
          const SizedBox(height: AppSpacing.md),
          if (sales.isEmpty)
            const _DairyEmptyMessage(message: 'No sales found')
          else
            for (final sale in sales) ...[
              _SaleCard(sale: sale),
              const SizedBox(height: AppSpacing.sm),
            ],
        ],
      ),
    );
  }
}
