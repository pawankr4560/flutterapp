import 'package:flutter/material.dart';

import 'package:finhub/core/theme/app_colors.dart';
import 'package:finhub/core/theme/app_text_styles.dart';
import 'package:finhub/core/widgets/app_radius.dart';
import 'package:finhub/core/widgets/app_spacing.dart';
import 'package:finhub/features/plot/presentation/widgets/plot_listing_card.dart';

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
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedFilter = 'Location';
  bool _isGrid = false;

  static final List<_PlotData> _plots = [
    (
      id: 'green-valley-a12',
      title: 'Green Valley Premium Plot',
      location: 'Indore Bypass, Madhya Pradesh',
      area: '1,500 sq.ft',
      price: 'Rs. 42.5L',
      status: 'Available',
      propertyType: 'Residential Plot',
      roadWidth: '30 ft',
      electricity: 'Available',
      water: 'Borewell + municipal line',
      registration: 'RERA verified',
      description:
          'A well-planned residential plot inside a gated community with wide internal roads, street lighting, and strong connectivity to schools, hospitals, and the city bypass.',
      sellerName: 'Amit Verma',
      sellerPhone: '+91 98765 43210',
      images: [
        'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
      ],
      amenities: ['Gated', 'Road', 'Water', 'Electricity'],
    ),
    (
      id: 'lakeview-c03',
      title: 'Lakeview Corner Plot',
      location: 'Rau Road, Indore',
      area: '1,800 sq.ft',
      price: 'Rs. 58L',
      status: 'Booked',
      propertyType: 'Corner Plot',
      roadWidth: '40 ft',
      electricity: 'Available',
      water: 'Municipal line',
      registration: 'Registry ready',
      description:
          'Corner-facing plot with lake approach road, premium frontage, and a peaceful residential neighborhood suited for a spacious family home.',
      sellerName: 'Neha Sharma',
      sellerPhone: '+91 91234 56780',
      images: [
        'https://images.unsplash.com/photo-1472396961693-142e6e269027?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80',
      ],
      amenities: ['Corner', 'Park', 'Water', 'Security'],
    ),
    (
      id: 'sunrise-b07',
      title: 'Sunrise Enclave Plot',
      location: 'Ujjain Road, Indore',
      area: '1,200 sq.ft',
      price: 'Rs. 31.8L',
      status: 'Available',
      propertyType: 'Residential Plot',
      roadWidth: '25 ft',
      electricity: 'Available',
      water: 'Borewell',
      registration: 'Clear title',
      description:
          'Budget-friendly plot in a fast-growing corridor with clean title, nearby public transport, and reliable access to basic civic amenities.',
      sellerName: 'Rohit Jain',
      sellerPhone: '+91 99887 76655',
      images: [
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80',
      ],
      amenities: ['Loan', 'Road', 'School', 'Drainage'],
    ),
    (
      id: 'royal-heights-d18',
      title: 'Royal Heights East Facing',
      location: 'Super Corridor, Indore',
      area: '2,400 sq.ft',
      price: 'Rs. 82L',
      status: 'Sold',
      propertyType: 'Villa Plot',
      roadWidth: '45 ft',
      electricity: 'Underground cabling',
      water: 'Dual water connection',
      registration: 'Registered',
      description:
          'Large east-facing plot in a premium address with wide roads, landscaped open spaces, and quick access to commercial hubs.',
      sellerName: 'Karan Malhotra',
      sellerPhone: '+91 90909 11223',
      images: [
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
      ],
      amenities: ['Premium', 'Club', 'Park', 'Security'],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => _push(context, _SavedPlotsScreen(plots: _plots)),
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
                        onViewDetails: () => _openDetails(plot),
                      );
                    },
                  )
                else
                  for (final plot in filteredPlots) ...[
                    _PlotCardFromData(
                      plot: plot,
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

  void _openDetails(_PlotData plot) {
    _push(context, _PlotDetailsScreen(plot: plot));
  }
}

