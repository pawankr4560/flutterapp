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
                      '${delivery.vehicle} - ${delivery.driver}',
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'ETA: ${delivery.eta}',
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

