part of 'inventory_directory_page.dart';

class _DeliveryTrackingScreen extends StatelessWidget {
  const _DeliveryTrackingScreen({required this.deliveries});

  final List<_DeliveryEntry> deliveries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemBuilder: (context, index) {
        return _DeliveryTrackingCard(delivery: deliveries[index]);
      },
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemCount: deliveries.length,
    );
  }
}

