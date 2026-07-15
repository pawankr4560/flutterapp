part of 'inventory_directory_page.dart';

class _MaterialCategoriesScreen extends StatelessWidget {
  const _MaterialCategoriesScreen({
    required this.categories,
    required this.selectedCategory,
    required this.products,
    required this.onCategorySelected,
    required this.onOrder,
  });

  final List<_MaterialCategory> categories;
  final String selectedCategory;
  final List<_MaterialProduct> products;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<_MaterialProduct> onOrder;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const _EmptyConstructionMessage(
        message: 'No material categories available yet',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 560 ? 3 : 2;
            return GridView.builder(
              itemCount: categories.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: 1.02,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _MaterialCategoryCard(
                  category: category,
                  selected: category.name == selectedCategory,
                  onTap: () => onCategorySelected(category.name),
                );
              },
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        _SectionHeader(title: selectedCategory),
        const SizedBox(height: AppSpacing.sm),
        if (products.isEmpty)
          const _EmptyConstructionMessage(
            message: 'No materials available in this category yet',
          )
        else
          for (final product in products) ...[
            _MaterialCard(
              product: product,
              onOrder: () => onOrder(product),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
      ],
    );
  }
}

