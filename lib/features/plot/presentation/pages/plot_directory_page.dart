import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:finhub/core/constants/app_config.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/plot/presentation/widgets/plot_listing_card.dart';
import 'package:finhub/data/api/api_client.dart';
import 'package:finhub/data/api/api_exception.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';

part 'plot_api_service.dart';
part '../widgets/plot_data.dart';
part 'plot_details_screen.dart';
part 'book_visit_screen.dart';
part 'saved_plots_screen.dart';
part 'my_visits_screen.dart';
part '../widgets/plot_card_from_data.dart';
part '../widgets/listing_header.dart';
part '../widgets/info_grid.dart';
part '../widgets/amenities_grid.dart';
part '../widgets/map_placeholder.dart';
part '../widgets/saved_plot_card.dart';
part '../widgets/visit_hero.dart';
part '../widgets/floating_button.dart';
part '../widgets/map_pattern_painter.dart';
part '../widgets/plot_formatters.dart';

class PlotDirectoryPage extends StatefulWidget {
  const PlotDirectoryPage({super.key});

  @override
  State<PlotDirectoryPage> createState() => _PlotDirectoryPageState();
}

class _PlotDirectoryPageState extends State<PlotDirectoryPage> {
  final _service = _PlotApiService();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedFilter = 'Location';
  bool _isGrid = false;
  List<_PlotData> _plots = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPlots();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Plot Purchase')),
        body: Center(
          child: FilledButton(onPressed: _loadPlots, child: const Text('Retry')),
        ),
      );
    }
    final filteredPlots = _plots.where((plot) {
      final query = _query.trim().toLowerCase();
      if (query.isEmpty) return true;
      return plot.title.toLowerCase().contains(query) ||
          plot.location.toLowerCase().contains(query) ||
          plot.area.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plot Purchase'),
        actions: [
          IconButton(
            tooltip: 'Saved plots',
            icon: const Icon(Icons.favorite_border_rounded),
            onPressed: () => _push(context, const _SavedPlotsScreen()),
          ),
          IconButton(
            tooltip: 'My visits',
            icon: const Icon(Icons.event_note_rounded),
            onPressed: () => _push(context, const MyVisitsScreen()),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 720;
            final crossAxisCount = constraints.maxWidth >= 980 ? 3 : 2;

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                PlotSearchBar(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: FilterChipRow(
                        filters: const [
                          'Location',
                          'Budget',
                          'Area',
                          'Property Type',
                        ],
                        selectedFilter: _selectedFilter,
                        onSelected: (value) {
                          setState(() => _selectedFilter = value);
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    SegmentedButton<bool>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: false,
                          icon: Icon(Icons.view_agenda_rounded),
                        ),
                        ButtonSegment(
                          value: true,
                          icon: Icon(Icons.grid_view_rounded),
                        ),
                      ],
                      selected: {_isGrid},
                      onSelectionChanged: (value) {
                        setState(() => _isGrid = value.first);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _ListingHeader(count: filteredPlots.length),
                const SizedBox(height: AppSpacing.md),
                if (filteredPlots.isEmpty)
                  const PlotEmptyStateWidget(
                    title: 'No plots found',
                    message: 'Try a different search or filter combination.',
                  )
                else if (_isGrid || isTablet)
                  GridView.builder(
                    itemCount: filteredPlots.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: constraints.maxWidth >= 980
                          ? 0.78
                          : 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final plot = filteredPlots[index];
                      return _PlotCardFromData(
                        plot: plot,
                        isCompact: true,
                        onFavorite: () => _toggleSaved(plot),
                        onViewDetails: () => _openDetails(plot),
                      );
                    },
                  )
                else
                  for (final plot in filteredPlots) ...[
                    _PlotCardFromData(
                      plot: plot,
                      onFavorite: () => _toggleSaved(plot),
                      onViewDetails: () => _openDetails(plot),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openDetails(_PlotData plot) async {
    try {
      final details = await _service.fetchPlot(plot.id);
      if (mounted) _push(context, _PlotDetailsScreen(plot: details));
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _loadPlots() async {
    setState(() { _loading = true; _error = null; });
    try {
      final plots = await _service.fetchPlots();
      if (mounted) setState(() { _plots = plots; _loading = false; });
    } catch (error) {
      if (mounted) setState(() { _error = error.toString(); _loading = false; });
    }
  }

  Future<void> _toggleSaved(_PlotData plot) async {
    try {
      if (plot.isSaved) {
        await _service.removeSaved(plot.id);
      } else {
        await _service.savePlot(plot.id);
      }
      if (!mounted) return;
      setState(() {
        final index = _plots.indexWhere((item) => item.id == plot.id);
        if (index >= 0) _plots[index] = _copyPlot(plot, isSaved: !plot.isSaved);
      });
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

