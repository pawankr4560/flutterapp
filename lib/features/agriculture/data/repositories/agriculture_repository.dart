import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/features/agriculture/application/services/agriculture_service.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';

import '../../domain/entities/agriculture_stock_item.dart';
import '../../domain/entities/field_record.dart';

final agricultureRepositoryProvider = Provider<AgricultureRepository>((ref) {
  return HttpAgricultureRepository();
});

abstract class AgricultureRepository {
  Future<List<FieldRecord>> listFields();

  Future<List<AgricultureStockItem>> listStockItems();

  Future<void> logSpray({
    required String fieldId,
    required DateTime applicationDate,
  });
}

class HttpAgricultureRepository implements AgricultureRepository {
  HttpAgricultureRepository({
    AgricultureService? service,
    String Function()? bearerTokenProvider,
  })  : _service = service ?? AgricultureService(),
        _bearerTokenProvider =
            bearerTokenProvider ?? (() => AuthSession.instance.bearerToken);

  final AgricultureService _service;
  final String Function() _bearerTokenProvider;
  AgricultureDashboardData? _cachedDashboard;

  @override
  Future<List<FieldRecord>> listFields() async {
    final dashboard = await _fetchDashboard();
    return dashboard.fields;
  }

  @override
  Future<List<AgricultureStockItem>> listStockItems() async {
    final dashboard = await _fetchDashboard();
    return dashboard.stockItems;
  }

  @override
  Future<void> logSpray({
    required String fieldId,
    required DateTime applicationDate,
  }) async {
    final dashboard = await _fetchDashboard();
    final field = dashboard.fields.firstWhere((field) => field.id == fieldId);
    final products = await _service.fetchSprayProducts(_bearerTokenProvider());
    final product = products.isEmpty
        ? const SprayProduct(
            id: '',
            name: '',
            dosagePerAcre: 0,
            dosageUnit: '',
            displayLabel: '',
          )
        : products.first;
    await _service.logSpray(
      bearerToken: _bearerTokenProvider(),
      field: field,
      product: product,
      applicationDate: applicationDate,
    );
    _cachedDashboard = null;
  }

  Future<AgricultureDashboardData> _fetchDashboard() async {
    final cached = _cachedDashboard;
    if (cached != null) return cached;
    final dashboard = await _service.fetchDashboard(_bearerTokenProvider());
    _cachedDashboard = dashboard;
    return dashboard;
  }
}

class InMemoryAgricultureRepository implements AgricultureRepository {
  List<FieldRecord> _fields = [
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
  ];

  final List<AgricultureStockItem> _stockItems = const [
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
  ];

  @override
  Future<List<FieldRecord>> listFields() async => List.unmodifiable(_fields);

  @override
  Future<List<AgricultureStockItem>> listStockItems() async {
    return List.unmodifiable(_stockItems);
  }

  @override
  Future<void> logSpray({
    required String fieldId,
    required DateTime applicationDate,
  }) async {
    _fields = [
      for (final field in _fields)
        field.id == fieldId
            ? field.copyWith(
                status: 'Healthy',
                lastSprayedDate: applicationDate,
              )
            : field,
    ];
  }
}
