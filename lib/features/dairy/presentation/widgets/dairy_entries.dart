part of '../pages/milk_directory_page.dart';

class _DairyDashboardData {
  const _DairyDashboardData({
    this.todayCollection = '0 L',
    this.todaySales = 'Rs. 0',
    this.pendingPayment = 'Rs. 0',
    this.productsCount = 0,
    this.recentActivities = const [],
  });

  factory _DairyDashboardData.fromJson(Map<String, dynamic> json) {
    return _DairyDashboardData(
      todayCollection: _displayValue(
        json['todayCollection'],
        fallback: '0 L',
        numericSuffix: ' L',
      ),
      todaySales: _displayValue(
        json['todaySales'],
        fallback: 'Rs. 0',
        currency: true,
      ),
      pendingPayment: _displayValue(
        json['pendingPayment'],
        fallback: 'Rs. 0',
        currency: true,
      ),
      productsCount: _asInt(json['productsCount']),
      recentActivities: _asList(json['recentActivities'])
          .whereType<Map<String, dynamic>>()
          .map(_DairyActivityEntry.fromJson)
          .where((activity) => activity.title.isNotEmpty)
          .toList(),
    );
  }

  final String todayCollection;
  final String todaySales;
  final String pendingPayment;
  final int productsCount;
  final List<_DairyActivityEntry> recentActivities;
}

class _DairyActivityEntry {
  const _DairyActivityEntry({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  factory _DairyActivityEntry.fromJson(Map<String, dynamic> json) {
    return _DairyActivityEntry(
      type: _asString(json['type']),
      title: _asString(json['title']),
      subtitle: _asString(json['subtitle']),
      time: _asString(json['time']),
    );
  }

  final String type;
  final String title;
  final String subtitle;
  final String time;
}

class _CollectionListResponse {
  const _CollectionListResponse({
    required this.summary,
    required this.items,
  });

  factory _CollectionListResponse.fromJson(Map<String, dynamic> json) {
    return _CollectionListResponse(
      summary: _CollectionSummary.fromJson(_asMap(json['summary'])),
      items: _asList(json['items'])
          .whereType<Map<String, dynamic>>()
          .map(_CollectionEntry.fromJson)
          .where((entry) => entry.farmer.isNotEmpty)
          .toList(),
    );
  }

  final _CollectionSummary summary;
  final List<_CollectionEntry> items;
}

class _CollectionSummary {
  const _CollectionSummary({
    this.todayCollection = '0 L',
    this.totalAmount = 'Rs. 0',
  });

  factory _CollectionSummary.fromJson(Map<String, dynamic> json) {
    return _CollectionSummary(
      todayCollection: _asString(json['todayCollection'], fallback: '0 L'),
      totalAmount: _asString(json['totalAmount'], fallback: 'Rs. 0'),
    );
  }

  final String todayCollection;
  final String totalAmount;
}

class _SalesListResponse {
  const _SalesListResponse({
    required this.summary,
    required this.items,
  });

  factory _SalesListResponse.fromJson(Map<String, dynamic> json) {
    return _SalesListResponse(
      summary: _SalesSummary.fromJson(_asMap(json['summary'])),
      items: _asList(json['items'])
          .whereType<Map<String, dynamic>>()
          .map(_SaleEntry.fromJson)
          .where((entry) => entry.customer.isNotEmpty)
          .toList(),
    );
  }

  final _SalesSummary summary;
  final List<_SaleEntry> items;
}

class _SalesSummary {
  const _SalesSummary({
    this.todaySales = 'Rs. 0',
    this.orders = 0,
  });

  factory _SalesSummary.fromJson(Map<String, dynamic> json) {
    return _SalesSummary(
      todaySales: _asString(json['todaySales'], fallback: 'Rs. 0'),
      orders: _asInt(json['orders']),
    );
  }

  final String todaySales;
  final int orders;
}

class _PaymentsListResponse {
  const _PaymentsListResponse({
    required this.summary,
    required this.items,
  });

  factory _PaymentsListResponse.fromJson(Map<String, dynamic> json) {
    final items = _asList(json['items'])
        .whereType<Map<String, dynamic>>()
        .map(_PaymentEntry.fromJson)
        .where((entry) => entry.party.isNotEmpty)
        .toList();
    return _PaymentsListResponse(
      summary: _PaymentsSummary.fromJson(_asMap(json['summary']), items),
      items: items,
    );
  }

  final _PaymentsSummary summary;
  final List<_PaymentEntry> items;
}

class _PaymentsSummary {
  const _PaymentsSummary({
    this.received = 'Rs. 0',
    this.pending = 'Rs. 0',
  });

  factory _PaymentsSummary.fromJson(
    Map<String, dynamic> json,
    List<_PaymentEntry> fallbackItems,
  ) {
    final received = fallbackItems
        .where((entry) => entry.status.toLowerCase() == 'received')
        .fold<double>(0, (sum, entry) => sum + entry.amount);
    final pending = fallbackItems
        .where((entry) => entry.status.toLowerCase() == 'pending')
        .fold<double>(0, (sum, entry) => sum + entry.amount);
    return _PaymentsSummary(
      received: _asString(json['received'], fallback: _money(received)),
      pending: _asString(json['pending'], fallback: _money(pending)),
    );
  }

  final String received;
  final String pending;
}

class _ReportEntry {
  const _ReportEntry({
    required this.key,
    required this.title,
    required this.value,
    required this.progress,
  });

  factory _ReportEntry.fromJson(Map<String, dynamic> json) {
    return _ReportEntry(
      key: _asString(json['key']),
      title: _asString(json['title']),
      value: _asString(json['value']),
      progress: (_asDouble(json['progress']) ?? 0).clamp(0, 1).toDouble(),
    );
  }

  final String key;
  final String title;
  final String value;
  final double progress;
}

class _CollectionEntry {
  const _CollectionEntry(
    this.farmer,
    this.milkType,
    this.quantity,
    this.fat,
    this.rate,
    this.date,
  );

  final String farmer;
  final String milkType;
  final double quantity;
  final double fat;
  final double rate;
  final DateTime date;

  factory _CollectionEntry.fromJson(Map<String, dynamic> json) {
    return _CollectionEntry(
      _asString(json['farmerName'], fallback: _asString(json['farmer'])),
      _asString(json['milkType']),
      _asDouble(json['quantity']) ?? 0,
      _asDouble(json['fat']) ?? 0,
      _asDouble(json['rate']) ?? 0,
      _asDate(json['collectionDate']) ?? DateTime.now(),
    );
  }

  double get amount => quantity * rate;
  String get quantityText => '${_trim(quantity)} L';
  String get rateText => _money(rate);
  String get amountText => _money(amount);
}

class _SaleEntry {
  const _SaleEntry(
    this.customer,
    this.product,
    this.quantity,
    this.rate,
    this.status,
    this.date,
  );

  final String customer;
  final String product;
  final double quantity;
  final double rate;
  final String status;
  final DateTime date;

  factory _SaleEntry.fromJson(Map<String, dynamic> json) {
    return _SaleEntry(
      _asString(json['customerName'], fallback: _asString(json['customer'])),
      _asString(json['productName'], fallback: _asString(json['product'])),
      _asDouble(json['quantity']) ?? 0,
      _asDouble(json['rate']) ?? 0,
      _asString(json['paymentStatus'], fallback: _asString(json['status'])),
      _asDate(json['saleDate']) ?? DateTime.now(),
    );
  }

  double get amount => quantity * rate;
  String get quantityText =>
      '${_trim(quantity)} ${product == 'Milk' ? 'L' : 'kg'}';
  String get amountText => _money(amount);
}

class _CustomerEntry {
  const _CustomerEntry(
    this.name,
    this.phone,
    this.type,
    this.balance,
    this.address,
  );

  final String name;
  final String phone;
  final String type;
  final double balance;
  final String address;

  factory _CustomerEntry.fromJson(Map<String, dynamic> json) {
    return _CustomerEntry(
      _asString(json['name']),
      _asString(json['phone']),
      _asString(json['type']),
      _asDouble(json['balance']) ?? _asDouble(json['openingBalance']) ?? 0,
      _asString(json['address']),
    );
  }
}

class _ProductEntry {
  const _ProductEntry(
    this.name,
    this.unit,
    this.stock,
    this.purchasePrice,
    this.sellingPrice,
  );

  final String name;
  final String unit;
  final double stock;
  final double purchasePrice;
  final double sellingPrice;

  factory _ProductEntry.fromJson(Map<String, dynamic> json) {
    return _ProductEntry(
      _asString(json['name']),
      _asString(json['unit']),
      _asDouble(json['stock']) ?? 0,
      _asDouble(json['purchasePrice']) ?? 0,
      _asDouble(json['sellingPrice']) ?? 0,
    );
  }

  String get stockText => '${_trim(stock)} $unit';
}

class _PaymentEntry {
  const _PaymentEntry(
    this.party,
    this.amount,
    this.mode,
    this.status,
    this.date,
  );

  final String party;
  final double amount;
  final String mode;
  final String status;
  final DateTime date;

  factory _PaymentEntry.fromJson(Map<String, dynamic> json) {
    return _PaymentEntry(
      _asString(json['partyName'], fallback: _asString(json['party'])),
      _asDouble(json['amount']) ?? 0,
      _asString(json['mode']),
      _asString(json['status']),
      _asDate(json['paymentDate']) ?? DateTime.now(),
    );
  }
}

Map<String, dynamic> _asMap(Object? value) {
  return value is Map<String, dynamic> ? value : <String, dynamic>{};
}

List<dynamic> _asList(Object? value) {
  return value is List<dynamic> ? value : const [];
}

String _asString(Object? value, {String fallback = ''}) {
  if (value == null) return fallback;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return fallback;
}

int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double? _asDouble(Object? value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

DateTime? _asDate(Object? value) {
  final string = _asString(value);
  return string.isEmpty ? null : DateTime.tryParse(string);
}

String _displayValue(
  Object? value, {
  required String fallback,
  String numericSuffix = '',
  bool currency = false,
}) {
  if (value is Map<String, dynamic>) {
    final display = _asString(value['displayValue']);
    if (display.isNotEmpty) return display;
    final number = _asDouble(value['amount']) ?? _asDouble(value['quantity']);
    if (number != null) {
      return currency ? _money(number) : '${_trim(number)}$numericSuffix';
    }
  }
  if (value is num && currency) return _money(value.toDouble());
  final string = _asString(value);
  return string.isEmpty ? fallback : string;
}

