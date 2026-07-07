part of 'milk_directory_page.dart';

class _SalesView extends StatelessWidget {
  const _SalesView({
    required this.sales,
    required this.onSearch,
    required this.onAdd,
  });

  final List<_SaleEntry> sales;
  final ValueChanged<String> onSearch;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          const Row(
            children: [
              Expanded(
                child: _DairySummaryCard(
                  title: 'Today Sales',
                  value: 'Rs. 8,500',
                  icon: Icons.payments_rounded,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DairySummaryCard(
                  title: 'Orders',
                  value: '24',
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
          for (final sale in sales) ...[
            _SaleCard(sale: sale),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}


