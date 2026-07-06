import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:finhub/core/constants/app_config.dart';

class CloudinaryService {
  CloudinaryService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _uploadTimeout = Duration(seconds: 60);

  bool get isConfigured =>
      AppConfig.cloudinaryCloudName.isNotEmpty &&
      AppConfig.cloudinaryUploadPreset.isNotEmpty;

  Future<String> uploadDocument({
    required PlatformFile file,
    required String applicationId,
    required String documentType,
    String? folder,
  }) async {
    if (!isConfigured) {
      throw Exception(
        'Cloudinary is not configured. Set CLOUDINARY_CLOUD_NAME and CLOUDINARY_UPLOAD_PRESET.',
      );
    }

    final uri = Uri.https(
      'api.cloudinary.com',
      '/v1_1/${AppConfig.cloudinaryCloudName}/auto/upload',
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = AppConfig.cloudinaryUploadPreset
      ..fields['folder'] = folder ?? AppConfig.cloudinaryFolder
      ..fields['public_id'] = _publicId(applicationId, documentType, file.name);

    if (file.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes('file', file.bytes!, filename: file.name),
      );
    } else if (file.path != null && file.path!.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path!,
          filename: file.name,
        ),
      );
    } else {
      throw Exception('Selected file could not be read.');
    }

    late final http.StreamedResponse streamedResponse;
    try {
      streamedResponse = await _client.send(request).timeout(_uploadTimeout);
    } on TimeoutException {
      throw Exception('Cloudinary upload timed out. Please try again.');
    } on http.ClientException {
      throw Exception('Cloudinary upload failed. Please check your connection.');
    }

    final response = await http.Response.fromStream(streamedResponse);
    final responseBody = _tryDecodeMap(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = responseBody?['error'];
      final message = error is Map<String, dynamic>
          ? error['message']?.toString()
          : null;
      throw Exception(message ?? 'Cloudinary upload failed.');
    }

    final secureUrl = responseBody?['secure_url']?.toString();
    if (secureUrl == null || secureUrl.isEmpty) {
      throw Exception('Cloudinary did not return a file URL.');
    }

    return secureUrl;
  }

  Future<String> uploadProfilePicture({
    required PlatformFile file,
    required String userId,
  }) {
    return uploadDocument(
      file: file,
      applicationId: userId,
      documentType: 'profile-picture',
      folder: 'loan-tracker/profiles',
    );
  }

  String _publicId(String applicationId, String documentType, String fileName) {
    return [
      applicationId,
      documentType,
      DateTime.now().millisecondsSinceEpoch.toString(),
    ].map(_slug).where((part) => part.isNotEmpty).join('-');
  }

  String _slug(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  Map<String, dynamic>? _tryDecodeMap(String body) {
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }
}


