part of '../pages/inventory_directory_page.dart';

class _DeliveryTrackingCard extends StatelessWidget {
  const _DeliveryTrackingCard({required this.delivery});

  final _DeliveryEntry delivery;

  @override
  Widget build(BuildContext context) {
    return _ConstructionPanel(
      child: Column(
        children: [
          Row(
            children: [
              const _SoftIcon(icon: Icons.local_shipping_rounded),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delivery.material,
                      style: AppTextStyles.titleMedium(context),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      delivery.id.isEmpty ? 'Delivery in progress' : 'Tracking ID ${delivery.id}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall(context),
                    ),
                  ],
                ),
              ),
              ConstructionStatusBadge(label: delivery.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(children: [
            Expanded(child: _DeliveryInfo(icon: Icons.local_shipping_outlined, label: delivery.vehicle.isEmpty ? 'Vehicle pending' : delivery.vehicle)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _DeliveryInfo(icon: Icons.person_outline_rounded, label: delivery.driver.isEmpty ? 'Driver pending' : delivery.driver)),
          ]),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  delivery.progress >= 1 ? 'Delivered' : 'Estimated arrival  ${delivery.eta.isEmpty ? 'Updating' : delivery.eta}',
                  style: AppTextStyles.bodyMedium(context),
                ),
              ),
              Text(
                '${(delivery.progress * 100).round()}%',
                style: AppTextStyles.titleMedium(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          LinearProgressIndicator(
            value: delivery.progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ],
      ),
    );
  }
}

class _DeliveryInfo extends StatelessWidget {
  const _DeliveryInfo({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(children: [
        Icon(icon, size: 17, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySmall(context))),
      ]),
    );
  }
}

