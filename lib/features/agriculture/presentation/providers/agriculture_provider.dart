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
    NotifierProvider<AgricultureNotifier, AgricultureState>(
  AgricultureNotifier.new,
);

/// Manages in-memory agriculture records.
class AgricultureNotifier extends Notifier<AgricultureState> {
  late final AgricultureRepository _repository;

  @override
  AgricultureState build() {
    _repository = ref.read(agricultureRepositoryProvider);
    return _currentState();
  }

  AgricultureState _currentState() {
    return AgricultureState(
      fields: _repository.listFields(),
      stockItems: _repository.listStockItems(),
    );
  }

  void logSpray({
    required String fieldId,
    required DateTime applicationDate,
  }) {
    _repository.logSpray(
      fieldId: fieldId,
      applicationDate: applicationDate,
    );
    state = _currentState();
  }
}
