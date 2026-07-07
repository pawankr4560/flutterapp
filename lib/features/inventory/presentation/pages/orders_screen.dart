part of 'inventory_directory_page.dart';

class _OrdersScreen extends StatelessWidget {
  const _OrdersScreen({required this.orders});

  final List<_OrderEntry> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemBuilder: (context, index) => _OrderCard(order: orders[index]),
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemCount: orders.length,
    );
  }
}

