import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/plot_listing.dart';

/// Provides plot listings for the Plot Management module.
final plotProvider = NotifierProvider<PlotNotifier, List<PlotListing>>(
  PlotNotifier.new,
);

/// Manages the in-memory plot listing directory.
class PlotNotifier extends Notifier<List<PlotListing>> {
  @override
  List<PlotListing> build() {
    return const [
      PlotListing(
        id: 'plot-green-valley-a12',
        plotNumber: 'A-12',
        projectName: 'Green Valley',
        location: 'North Block',
        areaSqFt: 1200,
        price: 1800000,
        status: 'Available',
        facing: 'East',
      ),
      PlotListing(
        id: 'plot-green-valley-b07',
        plotNumber: 'B-07',
        projectName: 'Green Valley',
        location: 'Central Avenue',
        areaSqFt: 1500,
        price: 2350000,
        status: 'Booked',
        facing: 'West',
      ),
      PlotListing(
        id: 'plot-lakeview-c03',
        plotNumber: 'C-03',
        projectName: 'Lakeview Estate',
        location: 'Lake Side',
        areaSqFt: 1800,
        price: 3200000,
        status: 'Available',
        facing: 'North',
      ),
      PlotListing(
        id: 'plot-lakeview-d18',
        plotNumber: 'D-18',
        projectName: 'Lakeview Estate',
        location: 'Garden Road',
        areaSqFt: 1000,
        price: 1450000,
        status: 'Sold',
        facing: 'South',
      ),
    ];
  }
}
