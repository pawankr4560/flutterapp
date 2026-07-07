part of 'milk_directory_page.dart';

class _PaymentsView extends StatelessWidget {
  const _PaymentsView({required this.payments});

  final List<_PaymentEntry> payments;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        const Row(
          children: [
            Expanded(
              child: _DairySummaryCard(
                title: 'Received',
                value: 'Rs. 15,500',
                icon: Icons.check_circle_rounded,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _DairySummaryCard(
                title: 'Pending',
                value: 'Rs. 12,000',
                icon: Icons.pending_actions_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final payment in payments) ...[
          _PaymentCard(payment: payment),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

