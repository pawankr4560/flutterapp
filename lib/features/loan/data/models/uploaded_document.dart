class UploadedDocument {
  const UploadedDocument({
    required this.type,
    required this.url,
    this.fileName,
    this.status,
    this.uploadedAt,
    this.documentId,
  });

  final String type;
  final String url;
  final String? fileName;
  final String? status;
  final DateTime? uploadedAt;
  final String? documentId;

  factory UploadedDocument.fromJson(Map<String, dynamic> json) {
    return UploadedDocument(
      type: _readString(json, ['type', 'documentType', 'name']) ?? 'Document',
      url: _readString(json, ['url', 'documentUrl', 'fileUrl']) ?? '',
      fileName: _readString(json, ['fileName', 'filename', 'name']),
      status: _readString(json, ['status']),
      uploadedAt: DateTime.tryParse(
        _readString(json, ['uploadedAt', 'createdAt']) ?? '',
      ),
      documentId: _readString(json, ['documentId', 'id']),
    );
  }

  bool get isImage {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.endsWith('.jpg') ||
        lowerUrl.endsWith('.jpeg') ||
        lowerUrl.endsWith('.png') ||
        lowerUrl.endsWith('.webp');
  }

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    return null;
  }
}


