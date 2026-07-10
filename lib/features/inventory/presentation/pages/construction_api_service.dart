part of 'inventory_directory_page.dart';

class _ConstructionApiService {
  _ConstructionApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Uri get _dashboardUri => Uri.parse('${AppConfig.baseUrl}/construction/dashboard');
  Uri get _categoriesUri =>
      Uri.parse('${AppConfig.baseUrl}/construction/categories');
  Uri get _productsUri => Uri.parse('${AppConfig.baseUrl}/construction/products');
  Uri get _unitsUri => Uri.parse('${AppConfig.baseUrl}/construction/units');
  Uri get _quotesUri => Uri.parse('${AppConfig.baseUrl}/construction/quotes');
  Uri get _ordersUri => Uri.parse('${AppConfig.baseUrl}/construction/orders');
  Uri get _deliveriesUri =>
      Uri.parse('${AppConfig.baseUrl}/construction/deliveries');

  Future<_ConstructionDashboardData> fetchDashboard(String bearerToken) async {
    final response = await _apiClient.get(_dashboardUri, bearerToken: bearerToken);
    final data = _dataMap(response.body);
    return _ConstructionDashboardData.fromJson(data);
  }

  Future<List<_MaterialCategory>> fetchCategories(String bearerToken) async {
    final response = await _apiClient.get(_categoriesUri, bearerToken: bearerToken);
    return _dataList(response.body)
        .whereType<Map<String, dynamic>>()
        .map(_MaterialCategory.fromJson)
        .where((category) => category.id.isNotEmpty && category.name.isNotEmpty)
        .toList();
  }

  Future<List<_MaterialProduct>> fetchProducts(
    String bearerToken, {
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    final uri = categoryId == null || categoryId.isEmpty
        ? _productsUri
        : _productsUri.replace(
            queryParameters: {
              'categoryId': categoryId,
              'page': page.toString(),
              'limit': limit.toString(),
            },
          );
    final response = await _apiClient.get(uri, bearerToken: bearerToken);
    final items = _itemsList(response.body);
    return items
        .whereType<Map<String, dynamic>>()
        .map(_MaterialProduct.fromJson)
        .where((product) => product.id.isNotEmpty && product.name.isNotEmpty)
        .toList();
  }

  Future<List<_MaterialProduct>> fetchProductsForCategories(
    String bearerToken,
    List<_MaterialCategory> categories,
  ) async {
    final products = await fetchProducts(bearerToken);
    if (categories.isEmpty || products.isEmpty) {
      return products;
    }

    final categoryNamesById = {
      for (final category in categories) category.id: category.name,
    };
    return [
      for (final product in products)
        product.withCategoryName(
          categoryNamesById[product.categoryId] ?? product.category,
        ),
    ];
  }

  Future<List<_ConstructionUnit>> fetchUnits(String bearerToken) async {
    final response = await _apiClient.get(_unitsUri, bearerToken: bearerToken);
    return _dataList(response.body)
        .whereType<Map<String, dynamic>>()
        .map(_ConstructionUnit.fromJson)
        .where((unit) => unit.id.isNotEmpty && unit.name.isNotEmpty)
        .toList();
  }

  Future<List<_QuoteRequest>> fetchQuotes(String bearerToken) async {
    final response = await _apiClient.get(_quotesUri, bearerToken: bearerToken);
    return _dataList(response.body)
        .whereType<Map<String, dynamic>>()
        .map(_QuoteRequest.fromJson)
        .where((quote) => quote.id.isNotEmpty)
        .toList();
  }

  Future<List<_OrderEntry>> fetchOrders(String bearerToken) async {
    final response = await _apiClient.get(_ordersUri, bearerToken: bearerToken);
    final items = _itemsList(response.body);
    return items
        .whereType<Map<String, dynamic>>()
        .map(_OrderEntry.fromJson)
        .where((order) => order.id.isNotEmpty)
        .toList();
  }

  Future<_OrderEntry> createOrderFromQuote({
    required String bearerToken,
    required String quoteId,
  }) async {
    final response = await _apiClient.post(
      Uri.parse('${AppConfig.baseUrl}/construction/orders/from-quote/$quoteId'),
      bearerToken: bearerToken,
    );
    return _OrderEntry.fromJson(_dataMap(response.body));
  }

  Future<List<_DeliveryEntry>> fetchDeliveries(String bearerToken) async {
    final response = await _apiClient.get(
      _deliveriesUri,
      bearerToken: bearerToken,
    );
    return _dataList(response.body)
        .whereType<Map<String, dynamic>>()
        .map(_DeliveryEntry.fromJson)
        .where((delivery) => delivery.id.isNotEmpty)
        .toList();
  }

  Future<_QuoteRequest> createQuote({
    required String bearerToken,
    required String categoryId,
    required String productId,
    required double quantity,
    required String unitId,
    required double estimatedAmount,
    required String deliveryLocation,
    required DateTime requiredDate,
    required String contactNumber,
    required String notes,
  }) async {
    if (unitId.isEmpty) {
      throw Exception('Selected material does not have a unit ID.');
    }

    final response = await _apiClient.post(
      _quotesUri,
      bearerToken: bearerToken,
      body: {
        'categoryId': _apiId(categoryId),
        'productId': _apiId(productId),
        'quantity': quantity,
        'unitId': _apiId(unitId),
        'estimatedAmount': estimatedAmount,
        'deliveryLocation': deliveryLocation,
        'requiredDate': _apiDateTime(requiredDate),
        'contactNumber': contactNumber,
        if (notes.isNotEmpty) 'notes': notes,
      },
    );
    return _QuoteRequest.fromJson(_dataMap(response.body));
  }

  Map<String, dynamic> _dataMap(String body) {
    final decoded = _decode(body);
    return switch (decoded) {
      {'data': final Map<String, dynamic> data} => data,
      Map<String, dynamic> data => data,
      _ => <String, dynamic>{},
    };
  }

  List<dynamic> _dataList(String body) {
    final decoded = _decode(body);
    return switch (decoded) {
      {'data': final List<dynamic> data} => data,
      List<dynamic> data => data,
      _ => const [],
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

Object _apiId(String value) {
  return int.tryParse(value) ?? value;
}

String _apiDateTime(DateTime date) {
  return date.toUtc().toIso8601String();
}
