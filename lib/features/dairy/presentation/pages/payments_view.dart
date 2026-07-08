part of 'milk_directory_page.dart';

class _PaymentsView extends StatelessWidget {
  const _PaymentsView({required this.payments, required this.summary});

  final List<_PaymentEntry> payments;
  final _PaymentsSummary summary;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
          children: [
            Expanded(
              child: _DairySummaryCard(
                title: 'Received',
                value: summary.received,
                icon: Icons.check_circle_rounded,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _DairySummaryCard(
                title: 'Pending',
                value: summary.pending,
                icon: Icons.pending_actions_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (payments.isEmpty)
          const _DairyEmptyMessage(message: 'No payments found')
        else
          for (final payment in payments) ...[
            _PaymentCard(payment: payment),
            const SizedBox(height: AppSpacing.sm),
          ],
      ],
    );
  }
}

