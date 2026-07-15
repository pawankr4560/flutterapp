part of '../pages/inventory_directory_page.dart';

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final _OrderEntry order;

  @override
  Widget build(BuildContext context) {
    return _ConstructionPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.id,
                  style: AppTextStyles.titleMedium(context),
                ),
              ),
              ConstructionStatusBadge(label: order.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(order.material, style: AppTextStyles.titleLarge(context)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _OrderDetail(icon: Icons.inventory_2_outlined, label: 'Quantity', value: order.quantity)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _OrderDetail(icon: Icons.payments_outlined, label: 'Order value', value: order.amount)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: AppSpacing.sm),
          _OrderMeta(icon: Icons.event_outlined, text: order.deliveryDate.isEmpty ? 'Date to be confirmed' : 'Expected ${order.deliveryDate}'),
          const SizedBox(height: AppSpacing.xs),
          _OrderMeta(icon: Icons.location_on_outlined, text: order.location.isEmpty ? 'Delivery location pending' : order.location),
        ],
      ),
    );
  }
}

class _OrderDetail extends StatelessWidget {
  const _OrderDetail({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, size: 16), const SizedBox(width: AppSpacing.xs), Text(label, style: AppTextStyles.bodySmall(context))]),
        const SizedBox(height: AppSpacing.xs),
        Text(value.isEmpty ? '—' : value, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.labelLarge(context)),
      ]),
    );
  }
}

class _OrderMeta extends StatelessWidget {
  const _OrderMeta({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
      const SizedBox(width: AppSpacing.sm),
      Expanded(child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySmall(context))),
    ]);
  }
}

