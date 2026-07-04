import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/milk_collection_log.dart';

/// Provides and mutates daily milk collection logs.
final dairyProvider =
    NotifierProvider<DairyNotifier, List<MilkCollectionLog>>(
  DairyNotifier.new,
);

/// Manages the in-memory dairy collection ledger.
class DairyNotifier extends Notifier<List<MilkCollectionLog>> {
  @override
  List<MilkCollectionLog> build() {
    final now = DateTime.now();

    return [
      MilkCollectionLog(
        id: 'milk-log-ram-morning',
        farmerName: 'Ram Singh',
        shift: 'Morning',
        quantityInLiters: 12.5,
        fatPercentage: 4.5,
        ratePerLiter: 50,
        date: now,
      ),
      MilkCollectionLog(
        id: 'milk-log-shyam-morning',
        farmerName: 'Shyam Lal',
        shift: 'Morning',
        quantityInLiters: 8,
        fatPercentage: 5.2,
        ratePerLiter: 55,
        date: now,
      ),
      MilkCollectionLog(
        id: 'milk-log-ram-evening',
        farmerName: 'Ram Singh',
        shift: 'Evening',
        quantityInLiters: 10,
        fatPercentage: 4.2,
        ratePerLiter: 48,
        date: now,
      ),
    ];
  }

  void addLog(MilkCollectionLog log) {
    state = [...state, log];
  }
}
