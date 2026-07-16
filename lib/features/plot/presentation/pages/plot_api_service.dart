part of 'plot_directory_page.dart';

class _PlotApiService {
  _PlotApiService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;
  String get _token => AuthSession.instance.bearerToken;
  Uri get _plotsUri => Uri.parse('${AppConfig.baseUrl}/plots');

  Future<List<_PlotData>> fetchPlots() async {
    final response = await _client.get(_plotsUri, bearerToken: _token);
    return _items(response.body).map(_plotFromJson).toList();
  }

  Future<_PlotData> fetchPlot(String id) async {
    final response = await _client.get(
      Uri.parse('${AppConfig.baseUrl}/plots/$id'),
      bearerToken: _token,
    );
    return _plotFromJson(_data(response.body));
  }

  Future<List<_PlotData>> fetchSaved() async {
    final response = await _client.get(
      Uri.parse('${AppConfig.baseUrl}/plots/saved'),
      bearerToken: _token,
    );
    return _items(response.body).map(_plotFromJson).toList();
  }

  Future<void> savePlot(String id) async {
    await _client.post(
      Uri.parse('${AppConfig.baseUrl}/plots/$id/save'),
      bearerToken: _token,
    );
  }

  Future<void> removeSaved(String id) async {
    final response = await _client.send(
      'DELETE',
      Uri.parse('${AppConfig.baseUrl}/plots/$id/save'),
      headers: {
        'accept': '*/*',
        if (_token.isNotEmpty) 'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        _errorMessage(response.body) ?? 'Unable to remove saved plot.',
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> bookVisit({
    required String plotId,
    required String name,
    required String mobileNumber,
    required DateTime visitDate,
    required TimeOfDay visitTime,
    required String remarks,
  }) async {
    await _client.post(
      Uri.parse('${AppConfig.baseUrl}/plots/$plotId/visits'),
      bearerToken: _token,
      body: {
        'name': name,
        'mobileNumber': mobileNumber,
        'visitDate': _dateOnly(visitDate),
        'visitTime': '${visitTime.hour.toString().padLeft(2, '0')}:${visitTime.minute.toString().padLeft(2, '0')}:00',
        'remarks': remarks,
      },
    );
  }

  Future<List<_VisitData>> fetchVisits() async {
    final response = await _client.get(
      Uri.parse('${AppConfig.baseUrl}/plots/visits'),
      bearerToken: _token,
    );
    return _items(response.body).map(_visitFromJson).toList();
  }

  List<Map<String, dynamic>> _items(String body) {
    final decoded = _decode(body);
    final values = switch (decoded) {
      {'data': {'items': final List<dynamic> items}} => items,
      {'data': final List<dynamic> items} => items,
      {'items': final List<dynamic> items} => items,
      List<dynamic> items => items,
      _ => const <dynamic>[],
    };
    return values.whereType<Map<String, dynamic>>().toList();
  }

  Map<String, dynamic> _data(String body) {
    final decoded = _decode(body);
    return switch (decoded) {
      {'data': final Map<String, dynamic> data} => data,
      Map<String, dynamic> data => data,
      _ => throw const ApiException('Unable to parse plot response.'),
    };
  }

  Object? _decode(String body) {
    try {
      return body.trim().isEmpty ? null : jsonDecode(body);
    } catch (_) {
      throw const ApiException('Unable to parse plot response.');
    }
  }
}

_PlotData _plotFromJson(Map<String, dynamic> json) {
  final imageValues = json['images'] is List ? json['images'] as List : const [];
  final images = imageValues.map((value) {
    if (value is Map<String, dynamic>) return value['imageUrl']?.toString() ?? '';
    return value?.toString() ?? '';
  }).where((value) => value.isNotEmpty).toList();
  final thumbnail = json['thumbnailUrl']?.toString() ?? '';
  if (images.isEmpty && thumbnail.isNotEmpty) images.add(thumbnail);
  if (images.isEmpty) images.add('');
  final seller = json['seller'] is Map<String, dynamic>
      ? json['seller'] as Map<String, dynamic>
      : const <String, dynamic>{};
  return (
    id: json['id']?.toString() ?? '',
    title: json['title']?.toString() ?? '',
    location: json['location']?.toString() ?? '',
    area: '${_number(json['areaSqFt'])} sq.ft',
    price: _price(json['price']),
    status: json['status']?.toString() ?? '',
    propertyType: json['propertyType']?.toString() ?? '',
    roadWidth: json['roadWidth']?.toString() ?? '',
    electricity: json['electricity']?.toString() ?? '',
    water: json['water']?.toString() ?? '',
    registration: json['registration']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    sellerName: seller['name']?.toString() ?? '',
    sellerPhone: seller['phone']?.toString() ?? '',
    images: images,
    amenities: (json['amenities'] is List ? json['amenities'] as List : const [])
        .map((value) => value.toString()).toList(),
    isSaved: json['isSaved'] == true,
  );
}

_VisitData _visitFromJson(Map<String, dynamic> json) => (
  id: json['id']?.toString() ?? '',
  plotId: json['plotId']?.toString() ?? '',
  propertyName: json['propertyName']?.toString() ?? '',
  date: _displayApiDate(json['visitDate']?.toString() ?? ''),
  time: json['visitTime']?.toString() ?? '',
  status: json['status']?.toString() ?? '',
  imageUrl: json['imageUrl']?.toString() ?? '',
);

_PlotData _copyPlot(_PlotData plot, {required bool isSaved}) => (
  id: plot.id, title: plot.title, location: plot.location, area: plot.area,
  price: plot.price, status: plot.status, propertyType: plot.propertyType,
  roadWidth: plot.roadWidth, electricity: plot.electricity, water: plot.water,
  registration: plot.registration, description: plot.description,
  sellerName: plot.sellerName, sellerPhone: plot.sellerPhone,
  images: plot.images, amenities: plot.amenities, isSaved: isSaved,
);

String _number(Object? value) {
  final number = value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
  return number == number.roundToDouble() ? number.toInt().toString() : number.toStringAsFixed(1);
}

String _price(Object? value) {
  final price = value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
  if (price >= 100000) {
    final lakhs = price / 100000;
    final text = lakhs == lakhs.roundToDouble() ? lakhs.toInt().toString() : lakhs.toStringAsFixed(1);
    return 'Rs. ${text}L';
  }
  return 'Rs. ${price.toStringAsFixed(0)}';
}

String _dateOnly(DateTime value) => '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
String _displayApiDate(String value) {
  final date = DateTime.tryParse(value);
  return date == null ? value : _formatDate(date);
}
String? _errorMessage(String body) {
  try {
    final value = jsonDecode(body);
    return value is Map<String, dynamic> ? value['message']?.toString() : null;
  } catch (_) { return null; }
}
