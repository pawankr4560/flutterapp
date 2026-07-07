part of 'milk_directory_page.dart';

class _ProductsScreen extends StatefulWidget {
  const _ProductsScreen({required this.products, required this.onAdd});

  final List<_ProductEntry> products;
  final Future<void> Function() onAdd;

  @override
  State<_ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<_ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await widget.onAdd();
          if (mounted) setState(() {});
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Product'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 520 ? 3 : 2;
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                96,
              ),
              itemCount: widget.products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: 0.92,
              ),
              itemBuilder: (context, index) {
                return _ProductGridCard(product: widget.products[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

