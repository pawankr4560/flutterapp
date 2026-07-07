part of 'plot_directory_page.dart';

class _SavedPlotsScreen extends StatelessWidget {
  const _SavedPlotsScreen({required this.plots});

  final List<_PlotData> plots;

  @override
  Widget build(BuildContext context) {
    final savedPlots = plots.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Plots')),
      body: SafeArea(
        child: savedPlots.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: PlotEmptyStateWidget(
                  title: 'No saved plots',
                  message: 'Saved properties will appear here.',
                  icon: Icons.favorite_border_rounded,
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemBuilder: (context, index) {
                  final plot = savedPlots[index];
                  return _SavedPlotCard(plot: plot);
                },
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemCount: savedPlots.length,
              ),
      ),
    );
  }
}

