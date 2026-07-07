part of '../pages/milk_directory_page.dart';

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});

  final _PaymentEntry payment;

  @override
  Widget build(BuildContext context) {
    return _DairyPanel(
      child: Row(
        children: [
          const _SoftIcon(icon: Icons.account_balance_wallet_rounded),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payment.party, style: AppTextStyles.titleMedium(context)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${payment.mode} - ${_formatShortDate(payment.date)}',
                  style: AppTextStyles.bodySmall(context),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _money(payment.amount),
                style: AppTextStyles.titleMedium(context),
              ),
              const SizedBox(height: AppSpacing.xs),
              _DairyStatusBadge(label: payment.status),
            ],
          ),
        ],
      ),
    );
  }
}

