import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  @override
  AgricultureState build() {
    return AgricultureState(
      fields: [
        FieldRecord(
          id: 'field-north-block',
          name: 'North block',
          crop: 'Wheat',
          areaAcres: 4.5,
          status: 'Healthy',
          lastSprayedDate: DateTime(2026, 6, 28),
        ),
        FieldRecord(
          id: 'field-river-side',
          name: 'River side plot',
          crop: 'Cotton',
          areaAcres: 2.8,
          status: 'Needs attention',
          lastSprayedDate: DateTime(2026, 6, 20),
        ),
        FieldRecord(
          id: 'field-east-acre',
          name: 'East acre',
          crop: 'Paddy',
          areaAcres: 3.2,
          status: 'Healthy',
          lastSprayedDate: DateTime(2026, 6, 25),
        ),
      ],
      stockItems: const [
        AgricultureStockItem(
          id: 'stock-chlorpyrifos',
          name: 'Chlorpyrifos 20% EC',
          quantityLabel: '18 litres in stock',
          status: 'Sufficient',
        ),
        AgricultureStockItem(
          id: 'stock-urea',
          name: 'Urea granules',
          quantityLabel: '35 kg in stock',
          status: 'Sufficient',
        ),
        AgricultureStockItem(
          id: 'stock-neem-oil',
          name: 'Neem oil concentrate',
          quantityLabel: '2.5 litres in stock',
          status: 'Low stock',
        ),
        AgricultureStockItem(
          id: 'stock-dap',
          name: 'DAP fertilizer',
          quantityLabel: '0 kg in stock',
          status: 'Out of stock',
        ),
      ],
    );
  }

  void logSpray({
    required String fieldId,
    required DateTime applicationDate,
  }) {
    state = AgricultureState(
      fields: [
        for (final field in state.fields)
          field.id == fieldId
              ? field.copyWith(
                  status: 'Healthy',
                  lastSprayedDate: applicationDate,
                )
              : field,
      ],
      stockItems: state.stockItems,
    );
  }
}
