import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/milk_collection_log.dart';

final dairyRepositoryProvider = Provider<DairyRepository>((ref) {
  return InMemoryDairyRepository();
});

abstract class DairyRepository {
  List<MilkCollectionLog> listLogs();

  void addLog(MilkCollectionLog log);
}

class InMemoryDairyRepository implements DairyRepository {
  InMemoryDairyRepository() {
    final now = DateTime.now();
    _logs = [
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

  late List<MilkCollectionLog> _logs;

  @override
  List<MilkCollectionLog> listLogs() => List.unmodifiable(_logs);

  @override
  void addLog(MilkCollectionLog log) {
    _logs = [..._logs, log];
  }
}
