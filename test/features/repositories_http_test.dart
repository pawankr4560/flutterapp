import 'dart:convert';

import 'package:finhub/data/api/api_client.dart';
import 'package:finhub/features/agriculture/application/services/agriculture_service.dart';
import 'package:finhub/features/agriculture/data/repositories/agriculture_repository.dart';
import 'package:finhub/features/dairy/data/repositories/dairy_repository.dart';
import 'package:finhub/features/inventory/data/repositories/inventory_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('HttpInventoryRepository parses item lists and sends bearer auth', () async {
    final requests = <http.BaseRequest>[];
    final repository = HttpInventoryRepository(
      bearerTokenProvider: () => 'inventory-token',
      apiClient: ApiClient(
        client: _FakeHttpClient((request) async {
          requests.add(request);
          return _response(
            jsonEncode({
              'data': {
                'items': [
                  {
                    'id': 'prod-1',
                    'name': 'Cement',
                    'categoryName': 'Raw materials',
                    'stock': 12,
                    'rate': 420,
                  },
                  {'id': null, 'name': 'ignored'},
                ],
              },
            }),
          );
        }),
      ),
    );

    final items = await repository.listItems();

    expect(items, hasLength(1));
    expect(items.single.id, 'prod-1');
    expect(items.single.category, 'Raw materials');
    expect(items.single.sellingPrice, 420);
    expect(requests.single.headers['Authorization'], 'Bearer inventory-token');
  });

  test('HttpDairyRepository parses collection logs', () async {
    final repository = HttpDairyRepository(
      bearerTokenProvider: () => 'dairy-token',
      apiClient: ApiClient(
        client: _FakeHttpClient((request) async {
          expect(request.headers['Authorization'], 'Bearer dairy-token');
          return _response(
            jsonEncode({
              'data': {
                'items': [
                  {
                    'id': 'col-1',
                    'farmerName': 'Rahul Sharma',
                    'milkType': 'Cow',
                    'quantity': 20,
                    'fat': 4.5,
                    'rate': 42,
                    'collectionDate': '2026-07-08',
                  },
                ],
              },
            }),
          );
        }),
      ),
    );

    final logs = await repository.listLogs();

    expect(logs, hasLength(1));
    expect(logs.single.farmerName, 'Rahul Sharma');
    expect(logs.single.quantityInLiters, 20);
    expect(logs.single.ratePerLiter, 42);
  });

  test('HttpAgricultureRepository parses dashboard fields and stock', () async {
    final repository = HttpAgricultureRepository(
      bearerTokenProvider: () => 'agri-token',
      service: AgricultureService(
        apiClient: ApiClient(
          client: _FakeHttpClient((request) async {
            expect(request.headers['Authorization'], 'Bearer agri-token');
            return _response(
              jsonEncode({
                'data': {
                  'fields': [
                    {
                      'id': 'field-1',
                      'name': 'North block',
                      'crop': 'Wheat',
                      'areaAcres': 4.5,
                      'status': 'Healthy',
                      'lastSprayedDate': '2026-06-28',
                    },
                  ],
                  'stockItems': [
                    {
                      'id': 'stock-1',
                      'name': 'Urea granules',
                      'quantity': 35,
                      'unit': 'kg',
                      'status': 'Sufficient',
                    },
                  ],
                },
              }),
            );
          }),
        ),
      ),
    );

    final fields = await repository.listFields();
    final stockItems = await repository.listStockItems();

    expect(fields.single.name, 'North block');
    expect(stockItems.single.quantityLabel, '35 kg in stock');
  });
}

class _FakeHttpClient extends http.BaseClient {
  _FakeHttpClient(this._handler);

  final Future<http.StreamedResponse> Function(http.BaseRequest request)
      _handler;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _handler(request);
  }
}

http.StreamedResponse _response(String body, {int statusCode = 200}) {
  return http.StreamedResponse(
    Stream.value(utf8.encode(body)),
    statusCode,
    headers: {'content-type': 'application/json'},
  );
}
