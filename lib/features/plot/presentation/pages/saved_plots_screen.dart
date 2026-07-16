part of 'plot_directory_page.dart';

class _SavedPlotsScreen extends StatefulWidget {
  const _SavedPlotsScreen();

  @override
  State<_SavedPlotsScreen> createState() => _SavedPlotsScreenState();
}

class _SavedPlotsScreenState extends State<_SavedPlotsScreen> {
  final _service = _PlotApiService();
  List<_PlotData> _plots = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Plots')),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _plots.isEmpty
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
                  final plot = _plots[index];
                  return _SavedPlotCard(
                    plot: plot,
                    onRemove: () => _remove(plot),
                  );
                },
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemCount: _plots.length,
              ),
      ),
    );
  }

  Future<void> _load() async {
    try {
      final plots = await _service.fetchSaved();
      if (mounted) setState(() { _plots = plots; _loading = false; });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _remove(_PlotData plot) async {
    try {
      await _service.removeSaved(plot.id);
      if (mounted) setState(() => _plots.removeWhere((item) => item.id == plot.id));
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

