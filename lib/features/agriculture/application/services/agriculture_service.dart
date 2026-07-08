import 'dart:convert';

import 'package:finhub/core/constants/app_config.dart';
import 'package:finhub/data/api/api_client.dart';
import 'package:finhub/features/agriculture/domain/entities/agriculture_stock_item.dart';
import 'package:finhub/features/agriculture/domain/entities/field_record.dart';

class AgricultureDashboardData {
  const AgricultureDashboardData({
    required this.fields,
    required this.stockItems,
  });

  factory AgricultureDashboardData.fromJson(Map<String, dynamic> json) {
    return AgricultureDashboardData(
      fields: _asList(json['fields'])
          .whereType<Map<String, dynamic>>()
          .map(FieldRecord.fromJson)
          .where((field) => field.id.isNotEmpty)
          .toList(),
      stockItems: _asList(json['stockItems'])
          .whereType<Map<String, dynamic>>()
          .map(AgricultureStockItem.fromJson)
          .where((item) => item.id.isNotEmpty)
          .toList(),
    );
  }

  final List<FieldRecord> fields;
  final List<AgricultureStockItem> stockItems;
}

class SprayProduct {
  const SprayProduct({
    required this.id,
    required this.name,
    required this.dosagePerAcre,
    required this.dosageUnit,
    required this.displayLabel,
  });

  factory SprayProduct.fromJson(Map<String, dynamic> json) {
    final name = _asString(json['name']);
    final dosage = _asDouble(json['dosagePerAcre']) ?? 0;
    final unit = _asString(json['dosageUnit']);
    return SprayProduct(
      id: _asString(json['id']),
      name: name,
      dosagePerAcre: dosage,
      dosageUnit: unit,
      displayLabel: _asString(
        json['displayLabel'],
        fallback: '$name - ${_trim(dosage)} $unit/acre',
      ),
    );
  }

  final String id;
  final String name;
  final double dosagePerAcre;
  final String dosageUnit;
  final String displayLabel;
}

class AgricultureService {
  AgricultureService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Uri get _dashboardUri =>
      Uri.parse('${AppConfig.baseUrl}/agriculture/dashboard');
  Uri get _sprayProductsUri =>
      Uri.parse('${AppConfig.baseUrl}/agriculture/spray-products');
  Uri get _sprayLogsUri =>
      Uri.parse('${AppConfig.baseUrl}/agriculture/spray-logs');
  Uri get _stockUri => Uri.parse('${AppConfig.baseUrl}/agriculture/stock');

  Future<AgricultureDashboardData> fetchDashboard(String bearerToken) async {
    final response = await _apiClient.get(
      _dashboardUri,
      bearerToken: bearerToken,
    );
    return AgricultureDashboardData.fromJson(_dataMap(response.body));
  }

  Future<List<SprayProduct>> fetchSprayProducts(String bearerToken) async {
    final response = await _apiClient.get(
      _sprayProductsUri,
      bearerToken: bearerToken,
    );
    return _dataList(response.body)
        .whereType<Map<String, dynamic>>()
        .map(SprayProduct.fromJson)
        .where((product) => product.id.isNotEmpty)
        .toList();
  }

  Future<void> logSpray({
    required String bearerToken,
    required FieldRecord field,
    required SprayProduct product,
    required DateTime applicationDate,
  }) async {
    await _apiClient.post(
      _sprayLogsUri,
      bearerToken: bearerToken,
      body: {
        'fieldId': field.id,
        'sprayProductId': product.id,
        'applicationDate': _apiDate(applicationDate),
        'dosagePerAcre': product.dosagePerAcre,
        'dosageUnit': product.dosageUnit,
        'estimatedDosage': field.areaAcres * product.dosagePerAcre,
      },
    );
  }

  Future<AgricultureStockItem> createStockItem({
    required String bearerToken,
    required String name,
    required double quantity,
    required String unit,
    required String status,
  }) async {
    final response = await _apiClient.post(
      _stockUri,
      bearerToken: bearerToken,
      body: {
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'status': status,
      },
    );
    return AgricultureStockItem.fromJson(_dataMap(response.body));
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

String _asString(Object? value, {String fallback = ''}) {
  if (value == null) return fallback;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return fallback;
}

double? _asDouble(Object? value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

List<dynamic> _asList(Object? value) {
  return value is List<dynamic> ? value : const [];
}

String _trim(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}
