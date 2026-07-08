import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finhub/core/constants/app_config.dart';
import 'package:finhub/data/api/api_client.dart';
import 'package:finhub/data/api/api_exception.dart';
import 'package:finhub/features/auth/application/services/auth_session.dart';

import '../../domain/entities/inventory_item.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return HttpInventoryRepository();
});

abstract class InventoryRepository {
  Future<List<InventoryItem>> listItems();

  Future<void> addItem(InventoryItem item);

  Future<void> updateStock(String itemId, int newStock);
}

class HttpInventoryRepository implements InventoryRepository {
  HttpInventoryRepository({
    ApiClient? apiClient,
    String Function()? bearerTokenProvider,
  })  : _apiClient = apiClient ?? ApiClient(),
        _bearerTokenProvider =
            bearerTokenProvider ?? (() => AuthSession.instance.bearerToken);

  final ApiClient _apiClient;
  final String Function() _bearerTokenProvider;

  Uri get _itemsUri => Uri.parse('${AppConfig.baseUrl}/construction/products');

  @override
  Future<List<InventoryItem>> listItems() async {
    final response = await _apiClient.get(
      _itemsUri,
      bearerToken: _bearerTokenProvider(),
    );
    return _itemsFromResponse(response.body);
  }

  @override
  Future<void> addItem(InventoryItem item) async {
    await _apiClient.post(
      _itemsUri,
      bearerToken: _bearerTokenProvider(),
      body: item.toJson(),
    );
  }

  @override
  Future<void> updateStock(String itemId, int newStock) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/construction/products/$itemId/stock');
    await _apiClient.put(
      uri,
      bearerToken: _bearerTokenProvider(),
      body: {'currentStock': newStock},
    );
  }

  List<InventoryItem> _itemsFromResponse(String body) {
    try {
      final decoded = body.trim().isEmpty ? null : jsonDecode(body);
      final items = switch (decoded) {
        {'data': {'items': final List<dynamic> values}} => values,
        {'items': final List<dynamic> values} => values,
        {'data': final List<dynamic> values} => values,
        List<dynamic> values => values,
        _ => const <dynamic>[],
      };
      return items
          .whereType<Map<String, dynamic>>()
          .map(InventoryItem.fromJson)
          .where((item) => item.id.isNotEmpty)
          .toList();
    } catch (_) {
      throw const ApiException('Unable to parse inventory response.');
    }
  }
}

class InMemoryInventoryRepository implements InventoryRepository {
  List<InventoryItem> _items = const [
    InventoryItem(
      id: 'item-cement-50kg',
      name: 'Cement 50kg bag',
      category: 'Raw materials',
      currentStock: 80,
      lowStockThreshold: 20,
      costPrice: 390,
      sellingPrice: 420,
    ),
    InventoryItem(
      id: 'item-steel-rods-12mm',
      name: 'Steel rods 12mm',
      category: 'Raw materials',
      currentStock: 6,
      lowStockThreshold: 15,
      costPrice: 790,
      sellingPrice: 850,
    ),
    InventoryItem(
      id: 'item-pvc-pipe-fittings',
      name: 'PVC pipe fittings',
      category: 'Plumbing',
      currentStock: 0,
      lowStockThreshold: 25,
      costPrice: 45,
      sellingPrice: 60,
    ),
    InventoryItem(
      id: 'item-paint-20l',
      name: 'Paint 20L drum',
      category: 'Finishing',
      currentStock: 24,
      lowStockThreshold: 10,
      costPrice: 1900,
      sellingPrice: 2200,
    ),
    InventoryItem(
      id: 'item-sand-truck',
      name: 'River sand truck',
      category: 'Raw materials',
      currentStock: 12,
      lowStockThreshold: 8,
      costPrice: 5200,
      sellingPrice: 5800,
    ),
    InventoryItem(
      id: 'item-electric-wire',
      name: 'Electric wire bundle',
      category: 'Electrical',
      currentStock: 4,
      lowStockThreshold: 12,
      costPrice: 1100,
      sellingPrice: 1350,
    ),
  ];

  @override
  Future<List<InventoryItem>> listItems() async => List.unmodifiable(_items);

  @override
  Future<void> addItem(InventoryItem item) async {
    _items = [..._items, item];
  }

  @override
  Future<void> updateStock(String itemId, int newStock) async {
    _items = [
      for (final item in _items)
        if (item.id == itemId)
          InventoryItem(
            id: item.id,
            name: item.name,
            category: item.category,
            currentStock: newStock,
            lowStockThreshold: item.lowStockThreshold,
            costPrice: item.costPrice,
            sellingPrice: item.sellingPrice,
          )
        else
          item,
    ];
  }
}
