part of 'milk_directory_page.dart';

class _DairyApiService {
  _DairyApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Uri get _dashboardUri => Uri.parse('${AppConfig.baseUrl}/dairy/dashboard');
  Uri get _productsUri => Uri.parse('${AppConfig.baseUrl}/dairy/products');
  Uri get _collectionsUri => Uri.parse('${AppConfig.baseUrl}/dairy/collections');
  Uri get _salesUri => Uri.parse('${AppConfig.baseUrl}/dairy/sales');
  Uri get _customersUri => Uri.parse('${AppConfig.baseUrl}/dairy/customers');
  Uri get _paymentsUri => Uri.parse('${AppConfig.baseUrl}/dairy/payments');
  Uri get _reportsUri => Uri.parse('${AppConfig.baseUrl}/dairy/reports');

  Future<_DairyDashboardData> fetchDashboard(String bearerToken) async {
    final response = await _apiClient.get(_dashboardUri, bearerToken: bearerToken);
    return _DairyDashboardData.fromJson(_dataMap(response.body));
  }

  Future<List<_ProductEntry>> fetchProducts(String bearerToken) async {
    final response = await _apiClient.get(_productsUri, bearerToken: bearerToken);
    return _itemsList(response.body)
        .whereType<Map<String, dynamic>>()
        .map(_ProductEntry.fromJson)
        .where((product) => product.name.isNotEmpty)
        .toList();
  }

  Future<_CollectionListResponse> fetchCollections(String bearerToken) async {
    final response = await _apiClient.get(_collectionsUri, bearerToken: bearerToken);
    return _CollectionListResponse.fromJson(_dataMap(response.body));
  }

  Future<_SalesListResponse> fetchSales(String bearerToken) async {
    final response = await _apiClient.get(_salesUri, bearerToken: bearerToken);
    return _SalesListResponse.fromJson(_dataMap(response.body));
  }

  Future<List<_CustomerEntry>> fetchCustomers(String bearerToken) async {
    final response = await _apiClient.get(_customersUri, bearerToken: bearerToken);
    return _itemsList(response.body)
        .whereType<Map<String, dynamic>>()
        .map(_CustomerEntry.fromJson)
        .where((customer) => customer.name.isNotEmpty)
        .toList();
  }

  Future<_PaymentsListResponse> fetchPayments(String bearerToken) async {
    final response = await _apiClient.get(_paymentsUri, bearerToken: bearerToken);
    return _PaymentsListResponse.fromJson(_dataMap(response.body));
  }

  Future<List<_ReportEntry>> fetchReports(String period, String bearerToken) async {
    final uri = _reportsUri.replace(queryParameters: {'period': period});
    final response = await _apiClient.get(uri, bearerToken: bearerToken);
    final data = _dataMap(response.body);
    return _asList(data['reports'])
        .whereType<Map<String, dynamic>>()
        .map(_ReportEntry.fromJson)
        .where((report) => report.title.isNotEmpty)
        .toList();
  }

  Future<_ProductEntry> createProduct(
    _ProductEntry entry,
    String bearerToken,
  ) async {
    final response = await _apiClient.post(
      _productsUri,
      bearerToken: bearerToken,
      body: {
        'name': entry.name,
        'unit': entry.unit,
        'stock': entry.stock,
        'purchasePrice': entry.purchasePrice,
        'sellingPrice': entry.sellingPrice,
      },
    );
    return _ProductEntry.fromJson(_dataMap(response.body));
  }

  Future<_CollectionEntry> createCollection(
    _CollectionEntry entry,
    String bearerToken,
  ) async {
    final response = await _apiClient.post(
      _collectionsUri,
      bearerToken: bearerToken,
      body: {
        'farmerName': entry.farmer,
        'milkType': entry.milkType,
        'quantity': entry.quantity,
        'fat': entry.fat,
        'rate': entry.rate,
        'collectionDate': _apiDate(entry.date),
      },
    );
    return _CollectionEntry.fromJson(_dataMap(response.body));
  }

  Future<_SaleEntry> createSale(_SaleEntry entry, String bearerToken) async {
    final response = await _apiClient.post(
      _salesUri,
      bearerToken: bearerToken,
      body: {
        'customerName': entry.customer,
        'productName': entry.product,
        'quantity': entry.quantity,
        'rate': entry.rate,
        'paymentStatus': entry.status,
        'saleDate': _apiDate(entry.date),
      },
    );
    return _SaleEntry.fromJson(_dataMap(response.body));
  }

  Future<_CustomerEntry> createCustomer(
    _CustomerEntry entry,
    String bearerToken,
  ) async {
    final response = await _apiClient.post(
      _customersUri,
      bearerToken: bearerToken,
      body: {
        'name': entry.name,
        'phone': entry.phone,
        'type': entry.type,
        'openingBalance': entry.balance,
        'address': entry.address,
      },
    );
    return _CustomerEntry.fromJson(_dataMap(response.body));
  }

  Map<String, dynamic> _dataMap(String body) {
    final decoded = _decode(body);
    return switch (decoded) {
      {'data': final Map<String, dynamic> data} => data,
      Map<String, dynamic> data => data,
      _ => <String, dynamic>{},
    };
  }

  List<dynamic> _itemsList(String body) {
    final decoded = _decode(body);
    return switch (decoded) {
      {'data': {'items': final List<dynamic> items}} => items,
      {'items': final List<dynamic> items} => items,
      {'data': final List<dynamic> data} => data,
      List<dynamic> data => data,
      _ => const [],
    };
  }

  Object? _decode(String body) {
    if (body.isEmpty) return null;
    return jsonDecode(body);
  }
}

String _apiDate(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
