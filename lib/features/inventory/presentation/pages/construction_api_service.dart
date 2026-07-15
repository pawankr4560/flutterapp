part of 'inventory_directory_page.dart';

class _ConstructionApiService {
  _ConstructionApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Uri get _dashboardUri =>
      Uri.parse('${AppConfig.baseUrl}/construction/dashboard');
  Uri get _categoriesUri =>
      Uri.parse('${AppConfig.baseUrl}/construction/categories');
  Uri get _productsUri =>
      Uri.parse('${AppConfig.baseUrl}/construction/products');
  Uri get _ordersUri => Uri.parse('${AppConfig.baseUrl}/construction/orders');
  Uri get _deliveriesUri =>
      Uri.parse('${AppConfig.baseUrl}/construction/deliveries');

  Future<_ConstructionDashboardData> fetchDashboard(String bearerToken) async {
    final response = await _apiClient.get(
      _dashboardUri,
      bearerToken: bearerToken,
    );
    final data = _dataMap(response.body);
    return _ConstructionDashboardData.fromJson(data);
  }

  Future<List<_MaterialCategory>> fetchCategories(String bearerToken) async {
    final response = await _apiClient.get(
      _categoriesUri,
      bearerToken: bearerToken,
    );
    return _dataList(response.body)
        .whereType<Map<String, dynamic>>()
        .map(_MaterialCategory.fromJson)
        .where((category) => category.id.isNotEmpty && category.name.isNotEmpty)
        .toList();
  }

  Future<List<_MaterialProduct>> fetchProducts(
    String bearerToken, {
    String? categoryId,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final uri = _productsUri.replace(
      queryParameters: {
        if (categoryId != null && categoryId.isNotEmpty)
          'categoryId': categoryId,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
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
    final categoryNamesById = {
      for (final category in categories) category.id: category.name,
    };
    final productGroups = categories.isEmpty
        ? [await _fetchAllProductPages(bearerToken)]
        : await Future.wait([
            for (final category in categories)
              _fetchAllProductPages(bearerToken, categoryId: category.id),
          ]);
    final productsById = <String, _MaterialProduct>{};
    for (final products in productGroups) {
      for (final product in products) {
        productsById[product.id] = product.withCategoryName(
          categoryNamesById[product.categoryId] ?? product.category,
        );
      }
    }
    return productsById.values.toList();
  }

  Future<List<_MaterialProduct>> _fetchAllProductPages(
    String bearerToken, {
    String? categoryId,
  }) async {
    const pageSize = 100;
    final products = <_MaterialProduct>[];
    final seenIds = <String>{};

    for (var page = 1; ; page++) {
      final pageItems = await fetchProducts(
        bearerToken,
        categoryId: categoryId,
        page: page,
        limit: pageSize,
      );
      final newItems = pageItems
          .where((product) => seenIds.add(product.id))
          .toList();
      products.addAll(newItems);
      if (pageItems.length < pageSize || newItems.isEmpty) break;
    }
    return products;
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

  Future<_OrderEntry> createOrder({
    required String bearerToken,
    required String categoryId,
    required String productId,
    required double quantity,
    required double price,
    required String unitId,
    required String deliveryLocation,
    required DateTime requiredDate,
    required String contactNumber,
    required String notes,
  }) async {
    final response = await _apiClient.post(
      _ordersUri,
      bearerToken: bearerToken,
      body: {
        'categoryId': _apiId(categoryId),
        'productId': _apiId(productId),
        'quantity': quantity,
        'price': price,
        'unitId': _apiId(unitId),
        'deliveryLocation': deliveryLocation,
        'requiredDate': _apiDateTime(requiredDate),
        'contactNumber': contactNumber,
        if (notes.isNotEmpty) 'notes': notes,
      },
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

  Map<String, dynamic> _dataMap(String body) {
    final decoded = _decode(body);
    return switch (decoded) {
      {'data': final Map<String, dynamic> data} => data,
      Map<String, dynamic> data => data,
      _ => <String, dynamic>{},
    };
  }

  List<dynamic> _dataList(String body) {
    return _collectionList(_decode(body));
  }

  List<dynamic> _itemsList(String body) {
    return _collectionList(_decode(body));
  }

  List<dynamic> _collectionList(Object? value) {
    if (value is List<dynamic>) return value;
    if (value is! Map<String, dynamic>) return const [];

    for (final key in const [
      'data',
      'items',
      'products',
      'categories',
      'units',
      'orders',
      'deliveries',
    ]) {
      final nested = value[key];
      if (nested is List<dynamic>) return nested;
      if (nested is Map<String, dynamic>) {
        final items = _collectionList(nested);
        if (items.isNotEmpty) return items;
      }
    }
    return const [];
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
