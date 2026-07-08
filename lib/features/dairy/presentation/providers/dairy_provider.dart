import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/dairy_repository.dart';
import '../../domain/entities/milk_collection_log.dart';

/// Provides and mutates daily milk collection logs.
final dairyProvider =
    AsyncNotifierProvider<DairyNotifier, List<MilkCollectionLog>>(
  DairyNotifier.new,
);

/// Manages the dairy collection ledger.
class DairyNotifier extends AsyncNotifier<List<MilkCollectionLog>> {
  late final DairyRepository _repository;

  @override
  Future<List<MilkCollectionLog>> build() {
    _repository = ref.read(dairyRepositoryProvider);
    return _repository.listLogs();
  }

  Future<void> addLog(MilkCollectionLog log) async {
    await _repository.addLog(log);
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.listLogs);
  }
}
