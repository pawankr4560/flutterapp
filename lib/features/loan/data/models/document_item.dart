enum DocumentUploadStatus {
  notUploaded,
  uploading,
  uploaded,
  failed,
}

class DocumentItem {
  const DocumentItem({
    required this.name,
    required this.status,
    this.filePath,
    this.fileName,
    this.cloudinaryUrl,
  });

  final String name;
  final DocumentUploadStatus status;
  final String? filePath;
  final String? fileName;
  final String? cloudinaryUrl;

  bool get isRequired {
    return name == 'PAN card' || name == 'Aadhaar card';
  }

  DocumentItem copyWith({
    DocumentUploadStatus? status,
    String? filePath,
    String? fileName,
    String? cloudinaryUrl,
  }) {
    return DocumentItem(
      name: name,
      status: status ?? this.status,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      cloudinaryUrl: cloudinaryUrl ?? this.cloudinaryUrl,
    );
  }
}


