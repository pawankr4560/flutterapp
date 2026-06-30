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
  });

  final String name;
  final DocumentUploadStatus status;
  final String? filePath;

  DocumentItem copyWith({
    DocumentUploadStatus? status,
    String? filePath,
  }) {
    return DocumentItem(
      name: name,
      status: status ?? this.status,
      filePath: filePath ?? this.filePath,
    );
  }
}
