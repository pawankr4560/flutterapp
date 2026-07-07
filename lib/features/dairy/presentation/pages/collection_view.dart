part of 'milk_directory_page.dart';

class _CollectionView extends StatelessWidget {
  const _CollectionView({
    required this.entries,
    required this.onSearch,
    required this.onAdd,
  });

  final List<_CollectionEntry> entries;
  final ValueChanged<String> onSearch;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Collection'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          96,
        ),
        children: [
          const Row(
            children: [
              Expanded(
                child: _DairySummaryCard(
                  title: 'Today Collection',
                  value: '120 L',
                  icon: Icons.water_drop_rounded,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DairySummaryCard(
                  title: 'Total Amount',
                  value: 'Rs. 6,400',
                  icon: Icons.payments_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppSearchAndFilter(
            hint: 'Search farmer or milk type',
            onChanged: onSearch,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final entry in entries) ...[
            _CollectionCard(entry: entry),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
