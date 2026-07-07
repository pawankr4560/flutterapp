import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/plot_repository.dart';
import '../../domain/entities/plot_listing.dart';

/// Provides plot listings for the Plot Management module.
final plotProvider = NotifierProvider<PlotNotifier, List<PlotListing>>(
  PlotNotifier.new,
);

/// Manages the in-memory plot listing directory.
class PlotNotifier extends Notifier<List<PlotListing>> {
  @override
  List<PlotListing> build() {
    return ref.read(plotRepositoryProvider).listListings();
  }
}
