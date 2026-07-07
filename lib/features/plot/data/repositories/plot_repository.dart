import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/plot_listing.dart';

final plotRepositoryProvider = Provider<PlotRepository>((ref) {
  return InMemoryPlotRepository();
});

abstract class PlotRepository {
  List<PlotListing> listListings();
}

class InMemoryPlotRepository implements PlotRepository {
  final List<PlotListing> _listings = const [
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

  @override
  List<PlotListing> listListings() => List.unmodifiable(_listings);
}
