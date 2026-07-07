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
          const SizedBox(height: AppSpacing.sm),
          Text(order.material, style: AppTextStyles.titleLarge(context)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${order.quantity} - ${order.amount}',
            style: AppTextStyles.bodyMedium(context),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${order.deliveryDate} - ${order.location}',
            style: AppTextStyles.bodySmall(context),
          ),
        ],
      ),
    );
  }
}

