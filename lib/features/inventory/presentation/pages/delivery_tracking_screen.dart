part of 'inventory_directory_page.dart';

class _DeliveryTrackingScreen extends StatelessWidget {
  const _DeliveryTrackingScreen({required this.deliveries});

  final List<_DeliveryEntry> deliveries;

  @override
  Widget build(BuildContext context) {
    if (deliveries.isEmpty) {
      return const _EmptyConstructionMessage(message: 'No deliveries found');
    }

    final inTransit = deliveries.where((item) => item.progress < 1).length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Row(
            children: [
              const _SoftIcon(icon: Icons.route_rounded),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('$inTransit deliveries on the move', style: AppTextStyles.titleMedium(context)),
                  const SizedBox(height: AppSpacing.xxs),
                  Text('Live status updates every few seconds', style: AppTextStyles.bodySmall(context)),
                ]),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Delivery timeline', style: AppTextStyles.titleMedium(context)),
        const SizedBox(height: AppSpacing.md),
        for (var index = 0; index < deliveries.length; index++) ...[
          _DeliveryTrackingCard(delivery: deliveries[index]),
          if (index != deliveries.length - 1) const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

