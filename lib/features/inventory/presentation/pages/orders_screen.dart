part of 'inventory_directory_page.dart';

class _OrdersScreen extends StatelessWidget {
  const _OrdersScreen({required this.orders});

  final List<_OrderEntry> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const _EmptyConstructionMessage(message: 'No orders found');
    }

    final active = orders.where((order) {
      final status = order.status.toLowerCase();
      return status != 'delivered' && status != 'cancelled';
    }).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        _OrderOverview(total: orders.length, active: active),
        const SizedBox(height: AppSpacing.lg),
        Text('Order history', style: AppTextStyles.titleMedium(context)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Track material requests and upcoming arrivals.',
          style: AppTextStyles.bodySmall(context),
        ),
        const SizedBox(height: AppSpacing.md),
        for (var index = 0; index < orders.length; index++) ...[
          _OrderCard(order: orders[index]),
          if (index != orders.length - 1)
            const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _OrderOverview extends StatelessWidget {
  const _OrderOverview({required this.total, required this.active});

  final int total;
  final int active;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primaryContainer],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          Expanded(child: _metric(context, '$active', 'Active orders')),
          Container(
            width: 1,
            height: 44,
            color: colorScheme.onPrimary.withValues(alpha: 0.25),
          ),
          Expanded(child: _metric(context, '$total', 'Total orders')),
        ],
      ),
    );
  }

  Widget _metric(BuildContext context, String value, String label) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Column(
      children: [
        Text(value, style: AppTextStyles.titleLarge(context).copyWith(color: onPrimary)),
        Text(label, style: AppTextStyles.bodySmall(context).copyWith(color: onPrimary.withValues(alpha: 0.8))),
      ],
    );
  }
}

