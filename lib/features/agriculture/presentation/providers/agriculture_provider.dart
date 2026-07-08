import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/agriculture_repository.dart';
import '../../domain/entities/agriculture_stock_item.dart';
import '../../domain/entities/field_record.dart';

/// Agriculture module state containing fields and pesticide stock.
class AgricultureState {
  const AgricultureState({
    required this.fields,
    required this.stockItems,
  });

  final List<FieldRecord> fields;
  final List<AgricultureStockItem> stockItems;
}

/// Provides field records and pesticide/fertilizer stock.
final agricultureProvider =
    AsyncNotifierProvider<AgricultureNotifier, AgricultureState>(
  AgricultureNotifier.new,
);

/// Manages agriculture records.
class AgricultureNotifier extends AsyncNotifier<AgricultureState> {
  late final AgricultureRepository _repository;

  @override
  Future<AgricultureState> build() {
    _repository = ref.read(agricultureRepositoryProvider);
    return _currentState();
  }

  Future<AgricultureState> _currentState() async {
    return AgricultureState(
      fields: await _repository.listFields(),
      stockItems: await _repository.listStockItems(),
    );
  }

  Future<void> logSpray({
    required String fieldId,
    required DateTime applicationDate,
  }) async {
    await _repository.logSpray(
      fieldId: fieldId,
      applicationDate: applicationDate,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(_currentState);
  }
}
