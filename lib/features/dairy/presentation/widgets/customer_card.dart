part of '../pages/milk_directory_page.dart';

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer});

  final _CustomerEntry customer;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _teal.withValues(alpha: 0.12),
            foregroundColor: _teal,
            child: Text(customer.name.characters.first),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer.name, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(customer.phone, style: AppTextStyles.bodySmall(context)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _DairyStatusBadge(label: customer.type),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _money(customer.balance),
                style: AppTextStyles.bodySmall(context),
              ),
            ],
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

