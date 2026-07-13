part of '../pages/inventory_directory_page.dart';

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({
    required this.quote,
    required this.accepting,
    required this.onAccept,
  });

  final _QuoteRequest quote;
  final bool accepting;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final finalAmount = quote.finalQuotedAmount > 0
        ? 'Final: ${_money(quote.finalQuotedAmount)}'
        : 'Awaiting final price';
    final status = _statusKey(quote.status);
    final canAccept =
        quote.finalQuotedAmount > 0 &&
        !{
          'accepted',
          'orderplaced',
          'convertedtoorder',
          'ordered',
          'placed',
          'completed',
          'rejected',
          'expired',
          'cancelled',
        }.contains(status);

    return _ConstructionPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quote #${quote.id}',
                  style: AppTextStyles.titleMedium(context),
                ),
              ),
              ConstructionStatusBadge(label: quote.status),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(quote.product, style: AppTextStyles.titleLarge(context)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${quote.quantity} - Estimate: ${_money(quote.estimatedAmount)}',
            style: AppTextStyles.bodyMedium(context),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(finalAmount, style: AppTextStyles.bodyMedium(context)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${_date(quote.date)} - ${quote.location}',
            style: AppTextStyles.bodySmall(context),
          ),
          if (canAccept) ...[
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: accepting ? null : onAccept,
              icon: accepting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_rounded),
              label: Text(accepting ? 'Placing order...' : 'Accept Quote'),
            ),
          ],
        ],
      ),
    );
  }
}
