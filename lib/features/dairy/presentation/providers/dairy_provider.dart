import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/dairy_repository.dart';
import '../../domain/entities/milk_collection_log.dart';

/// Provides and mutates daily milk collection logs.
final dairyProvider =
    NotifierProvider<DairyNotifier, List<MilkCollectionLog>>(
  DairyNotifier.new,
);

/// Manages the in-memory dairy collection ledger.
class DairyNotifier extends Notifier<List<MilkCollectionLog>> {
  late final DairyRepository _repository;

  @override
  List<MilkCollectionLog> build() {
    _repository = ref.read(dairyRepositoryProvider);
    return _repository.listLogs();
  }

  void addLog(MilkCollectionLog log) {
    _repository.addLog(log);
    state = _repository.listLogs();
  }
}
